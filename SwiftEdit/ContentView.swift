//
//  ContentView.swift
//  SwiftEdit
//
//  Created by Aerologix Aerologix on 17/03/25.
//

import SwiftUI
import PhotosUI

// Image Editor View
struct ImageEditorView: View {
    @StateObject private var viewModel = ImageEditorViewModel()
    @State private var showImagePicker = false

    var body: some View {
        VStack {
            if let image = viewModel.displayImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("Pick an image to edit")
                    .foregroundColor(.gray)
                    .padding()
            }

            HStack {
                Button("Choose Image") {
                    showImagePicker = true
                }
                .padding()

                Button("Save") {
                    viewModel.saveImageToPhotos()
                }
                .disabled(viewModel.displayImage == nil)
                .padding()
            }

            Slider(value: $viewModel.brightness, in: -1...1, step: 0.1) {
                Text("Brightness")
            }

            Slider(value: $viewModel.contrast, in: 0.5...2, step: 0.1) {
                Text("Contrast")
            }

            Picker("Filter", selection: $viewModel.selectedFilter) {
                ForEach(viewModel.filters, id: \.self) { filter in
                    Text(filter.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Apply") {
                viewModel.applyEdits()
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.originalImage)
        }
        .onChange(of: viewModel.originalImage) {
            viewModel.applyEdits()
        }
    }
}

// Preview
#Preview {
    ImageEditorView()
}
