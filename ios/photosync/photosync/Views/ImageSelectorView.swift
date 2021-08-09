//
//  ImageSelectorView.swift
//  photosync
//
//  Created by Aditya Kishan Ankaraboyana on 2/5/21.
//

import SwiftUI

struct ImageSelectorView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @Binding var authenticated: Bool

        var body: some View {
    
            VStack {
                if image != nil {
                image?
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical)
                Text("change image")
                    .onTapGesture {
                        self.showingImagePicker = false
                        self.showingImagePicker = true
                    }
                } else {
                    Text("select image")
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
                ImagePickerManager( image: self.$inputImage, authenticated: self.$authenticated)
            })
        }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}
