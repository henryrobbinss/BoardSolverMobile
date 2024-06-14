//
//  ViewModel.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/7/24.
//

import Foundation
import CoreImage
import Observation

@Observable
class ViewModel
{
    var currentFrame: CGImage?
    var isLocked = false
    private let cameraManager = CameraManager()
    
    init()
    {
        Task 
        {
            await handleCameraPreviews()
        }
    }
    
    // If not locked, set the current frame to be the image coming from the preview stream
    func handleCameraPreviews() async
    {
        for await image in cameraManager.previewStream
        {
            Task
            {
                @MainActor in
                if !isLocked
                {
                    currentFrame = image
                }
            }
        }
    }
    
    // Toggles the camera lock
    func toggleLock() {
        isLocked.toggle()
    }
}
