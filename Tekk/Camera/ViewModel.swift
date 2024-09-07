//
//  ViewModel.swift
//  Tekk
//
//  Created by Jordan on 8/19/24.
//  This file contains the ViewModel, which is used to manage the camera feed.

import Foundation
import CoreImage
import Observation

@Observable
class ViewModel {
    var currentFrame: CGImage?
    private let cameraManager = CameraManager()
    
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            Task { @MainActor in
                currentFrame = image
            }
        }
    }

}
