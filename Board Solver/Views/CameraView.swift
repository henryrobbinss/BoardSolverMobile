//
//  CameraView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/7/24.
//

import Foundation
import SwiftUI

struct CameraView : View
{
    @Binding var image: CGImage?
    @Binding var isLocked: Bool
    
    var body: some View
    {
        GeometryReader
        {
            geometry in if let image = image
            {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(.degrees(90)) // Rotate if landscape
                    .frame(width: geometry.size.width, height: geometry.size.height*1.2)
                    
            }
            else
            {
                ContentUnavailableView("No camera available.",
                                       systemImage: "xmark.circle.fill").frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
