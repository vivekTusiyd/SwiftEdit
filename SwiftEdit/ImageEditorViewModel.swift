//
//  ImageEditorViewModel.swift
//  SwiftEdit
//
//  Created by Aerologix Aerologix on 17/03/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

// View Model
class ImageEditorViewModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var displayImage: UIImage?

    @Published var brightness: Double = 0.0
    @Published var contrast: Double = 1.0
    @Published var selectedFilter: String = "none"

    let filters = ["none", "sepia", "mono", "invert"]

    private let context = CIContext()

    func applyEdits() {
        guard let inputImage = originalImage else { return }
        var ciImage = CIImage(image: inputImage)!

        // Basic adjustments
        let colorControls = CIFilter.colorControls()
        colorControls.inputImage = ciImage
        colorControls.brightness = Float(brightness)
        colorControls.contrast = Float(contrast)
        ciImage = colorControls.outputImage ?? ciImage

        // Apply filter
        switch selectedFilter {
        case "sepia":
            let filter = CIFilter.sepiaTone()
            filter.inputImage = ciImage
            filter.intensity = 0.8
            ciImage = filter.outputImage ?? ciImage
        case "mono":
            let filter = CIFilter.photoEffectMono()
            filter.inputImage = ciImage
            ciImage = filter.outputImage ?? ciImage
        case "invert":
            let filter = CIFilter.colorInvert()
            filter.inputImage = ciImage
            ciImage = filter.outputImage ?? ciImage
        default:
            break
        }

        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            DispatchQueue.main.async {
                self.displayImage = UIImage(cgImage: cgImage)
            }
        }
    }

    func saveImageToPhotos() {
        guard let image = displayImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
