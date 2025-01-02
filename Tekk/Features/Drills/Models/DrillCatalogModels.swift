//
//  DrillCatalogModels.swift
//  BravoBall
//
//  Created by Jordan on 1/1/25.
//

import Foundation

// Struct for the drill catalog response
struct DrillCatalogResponse: Codable {
    let drills: [DrillRecommendation]
    let metadata: Metadata
    let filters: Filters
    
    struct Metadata: Codable {
        let total: Int
        let page: Int
        let pages: Int
        let has_next: Bool
        let has_prev: Bool
    }
    
    // Struct for the filters for the drill catalog
    struct Filters: Codable {
        let categories: [String]
        let difficulties: [String]
        let equipment: [String]
    }
}

// ViewModel for the drill catalog
class DrillCatalogViewModel: ObservableObject {
    // Published variables for the drill catalog for the UI
    @Published var drills: [DrillRecommendation] = []
    @Published var currentPage = 1
    @Published var selectedCategory: String?
    @Published var selectedDifficulty: String?
    @Published var selectedEquipment: Set<String> = []
    @Published var isLoading = false
    @Published var hasNextPage = false
    @Published var hasPrevPage = false
    @Published var availableFilters: DrillCatalogResponse.Filters?
    
    // Function to load the drills for the drill catalog
    func loadDrills() async {
        // Currently loading the drills
        isLoading = true
        do {
            // Fetch the drill catalog
            let response = try await DrillService.shared.fetchDrillCatalog(
                page: currentPage,
                category: selectedCategory,
                difficulty: selectedDifficulty,
                equipment: Array(selectedEquipment)
            )
            // Run on the main actor to update the UI
            await MainActor.run {
                self.drills = response.drills
                self.hasNextPage = response.metadata.has_next
                self.hasPrevPage = response.metadata.has_prev
                self.availableFilters = response.filters
                self.isLoading = false
            }
        // Catch any errors
        } catch {
            print("Error loading drills: \(error)")
            isLoading = false
        }
    }
}
