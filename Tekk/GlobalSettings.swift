//
//  GlobalSettings.swift
//  BravoBall
//
//  Created by Jordan on 10/30/24.
//

import SwiftUI
import Foundation

// global view settings
class GlobalSettings: ObservableObject {
    @Published var primaryYellowColor: Color = Color(hex: "F6C356")
    @Published var secondaryYellowColor: Color = Color(hex: "C8A369")
    @Published var primaryDarkColor: Color = Color(hex:"1E272E")
    
}

// settings for services, dont need ObservableObject annotation
struct AppSettings {
    static let baseURL = "http://localhost:8000"
}
