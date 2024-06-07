//
//  CMSampleBuffer+Extension.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/7/24.
//

import Foundation
import AVFoundation
import CoreImage

extension CMSampleBuffer
{
    var cgImage: CGImage?
    {
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(self)
        
        guard let imagePixelBuffer = pixelBuffer else
        {
            return nil
        }
        return CIImage(cvPixelBuffer: imagePixelBuffer).cgImage
    }
}
