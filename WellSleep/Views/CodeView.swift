//
//  CodeView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/12.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct CodeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var id: Int
    
    var body: some View {
        Image(uiImage: generate(isDark: colorScheme == .dark))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .padding(.all, 10)
            .background(Color(UIColor.label).opacity(0.25))
            .cornerRadius(20.0)
    }
    
    func generate(isDark: Bool) -> UIImage {
        let data = Data(String(format: "%d", id).utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let output = filter.outputImage {
            if let cgImage = context.createCGImage(output, from: output.extent) {
                if isDark {
                    return UIImage(cgImage: cgImage).transparent()
                } else {
                    return UIImage(cgImage: cgImage).invert().transparent()
                }
            }
        }
        
        return UIImage()
    }
}

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView(id: 0)
    }
}
