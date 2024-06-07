//
//  CIImage+Extension.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/7/24.
//

import Foundation
import CoreImage

extension CIImage
{
    var cgImage: CGImage?
    {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {return nil}
        return cgImage
    }
}
