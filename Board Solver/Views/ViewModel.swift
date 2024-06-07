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
    private let cameraManager = CameraManager()
    init() { 
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async
    {
        for await image in cameraManager.previewStream
        {
            Task
            {
                @MainActor in currentFrame = image
            }
        }
    }
}
