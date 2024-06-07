//
//  CameraManager.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/7/24.
//

import Foundation
import AVFoundation

class CameraManager: NSObject 
{
    private let captureSession = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    private var isAuthorized: Bool 
    {
        get async
        {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    private var addToPreviewStream: ((CGImage) -> Void)?
        
    lazy var previewStream: AsyncStream<CGImage> =
    {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    // Init
    override init() 
    {
        super.init()
        
        Task{
            await configureSession()
            await startSession()
        }
    }
    
    private func configureSession() async 
    {
        guard await isAuthorized,
                  let systemPreferredCamera,
                  let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
            else { return }
            
            captureSession.beginConfiguration()
            
            defer {
                self.captureSession.commitConfiguration()
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
            
            guard captureSession.canAddInput(deviceInput) else {
                print("Unable to add device input to capture session.")
                return
            }
            guard captureSession.canAddOutput(videoOutput) else {
                print("Unable to add video output to capture session.")
                return
            }
        
            captureSession.addInput(deviceInput)
            captureSession.addOutput(videoOutput)
    }
    
    private func startSession() async
    {
        // Check authorizaton
        guard await isAuthorized else { return }
        captureSession.startRunning()
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate
{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        guard let currentFrame = sampleBuffer.cgImage else {return}
        addToPreviewStream?(currentFrame)
    }
}
