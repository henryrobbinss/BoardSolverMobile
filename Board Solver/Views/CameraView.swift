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
    
    var body: some View
    {
        GeometryReader
        {
            geometry in if let image = image
            {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            else
            {
                ContentUnavailableView("No camera available.",
                                       systemImage: "xmark.circle.fill").frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
