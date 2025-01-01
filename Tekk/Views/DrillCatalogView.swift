////
////  DrillCatalogView.swift
////  BravoBall
////
////  Created by Jordan on 12/30/24.
////
//
//import SwiftUI
//
//struct DrillCatalogView: View {
//    let categories = ["Dribbling", "Passing", "Shooting", "Tight Space", "Juggling"]
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(categories, id: \.self) { category in
//                    NavigationLink(destination: DrillListView(category: category)) {
//                        Text(category)
//                            .font(.custom("Poppins-Regular", size: 16))
//                    }
//                }
//            }
//            .navigationTitle("Drill Catalog")
//        }
//    }
//}
