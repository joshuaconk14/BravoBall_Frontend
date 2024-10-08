//
//  CameraView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//  This file contains the CameraView, which is used to display the camera feed.

import SwiftUI

struct CameraView: View {
    
    @Binding var image: CGImage?
    @Binding var activeTab: Tab
    
    enum Tab {
        case messages, camera, checklist, settings
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
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
            
             // Navigation Bar
             VStack {
                 Divider()
                     .background(Color.gray.opacity(0.3))
                     .frame(height: 1)
                 HStack {
                     Spacer()
                     navigationButton(tab: .messages, icon: "messages")
                     Spacer()
                     navigationButton(tab: .camera, icon: "camera")
                     Spacer()
                     navigationButton(tab: .checklist, icon: "checklist")
                     Spacer()
                     navigationButton(tab: .settings, icon: "gear")
                     Spacer()
                 }
                 .padding(.vertical, 30)
                 .background(Color.white)
            }
        }
    }
    
}

     private func navigationButton(tab: Tab, icon: String) -> some View {
         Button(action: {
             activeTab = tab
         }) {
             Image(systemName: icon)
                 .font(.system(size: 24))
                 .foregroundColor(activeTab == tab ? .green : .gray)
         }
     }
 }

//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Provide a constant binding for image and activeTab
//        CameraView(image: .constant(nil), activeTab: .constant(.camera))
//    }
//}
