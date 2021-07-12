//
//  UIImage.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/12.
//

import Foundation
import SwiftUI

extension UIImage {
    func transparent() -> UIImage {
        let filter = CIFilter.maskToAlpha()
        filter.setValue(CoreImage.CIImage(cgImage: self.cgImage!), forKey: kCIInputImageKey)
        
        if let output = filter.outputImage {
            let context = CIContext()
            
            if let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage()
    }

    func invert() -> UIImage {
        let filter = CIFilter.colorInvert()
        filter.setValue(CoreImage.CIImage(cgImage: self.cgImage!), forKey: kCIInputImageKey)
        
        if let output = filter.outputImage {
            let context = CIContext()
            
            if let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage()
    }
}
