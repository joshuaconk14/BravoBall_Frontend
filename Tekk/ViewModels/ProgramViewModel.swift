//
//  ProgramViewModel.swift
//  BravoBall
//
//  Created by Jordan on 11/12/24.
//

import Foundation

@MainActor
class ProgramViewModel: ObservableObject {
    @Published var currentWeek: Int = 1
    @Published var program: Program?
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchProgram(userId: Int) {
        isLoading = true
        
        Task {
            do {
                let fetchedProgram = try await ProgramService.shared.fetchUserProgram(userId: userId)
                program = fetchedProgram
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
}
