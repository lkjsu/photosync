//
//  ImagePickerManager.swift
//  photosync
//
//  Created by Aditya Kishan Ankaraboyana on 2/12/21.
//

import SwiftUI
import Foundation
import CoreImage
import Security


struct ImagePickerManager: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerManager

        init(_ parent: ImagePickerManager) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            debugPrint(#function)

            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            self.parent.uploadImage(parentImage: parent.image!)
//          let image = ImageSender(auth_token: auth_token).sendImage(auth_token, parent.image)
            parent.presentationMode.wrappedValue.dismiss()
            
        }
    }
    
    func uploadImage(parentImage: UIImage) {
        let auth_token = KeyChainAccess().retrieveAuthToken()
        let uploadurl = URL(string: "http://localhost:5000/upload")!
        var uploadrequest = URLRequest(url: uploadurl)
        uploadrequest.httpMethod = "POST"
        uploadrequest.setValue("auth_token " + auth_token, forHTTPHeaderField: "Authorization")
        let uploadtask = URLSession.shared.uploadTask(with: uploadrequest, from: parentImage.pngData()) {
            data, response, error in
            if let error = error {
                print("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode
                  ) else {
                self.authenticated = false
                return
            }
            if let mimeType = response.mimeType,
               mimeType == "application/json",
               let data = data,
               let dataString = String(data: data, encoding: .utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    print("got data: \(json)")
                } catch {
                    print("Something is wrong")
            }
        }
        }
        uploadtask.resume()
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var authenticated: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerManager>) -> UIImagePickerController {
        debugPrint(#function)

        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerManager>) {
        debugPrint(#function)

    }
    
}
