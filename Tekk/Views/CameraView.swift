//
//  CameraView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//  This file contains the CameraView, which is used to display the camera feed.

import SwiftUI

 struct CameraView: View {
    
     @Binding var image: CGImage?
    
     var body: some View {
         GeometryReader { geometry in
             if let image = image {
                 Image(decorative: image, scale: 1)
                     .resizable()
                     .scaledToFit()
                     .frame(width: geometry.size.width,
                            height: geometry.size.height)
             } else {
                 ContentUnavailableView("No camera feed", systemImage: "xmark.circle.fill")
                     .frame(width: geometry.size.width,
                            height: geometry.size.height)
             }
         }
     }
    
 }

//#Preview {
//    CameraView()
//}
