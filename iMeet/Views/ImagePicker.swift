//
//  ImagePicker.swift
//  iMeet
//
//  Created by dominator on 31/03/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    class Cordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        let parent: ImagePicker
        
        init(_ parent: ImagePicker){
            self.parent = parent
            super.init()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let editedImage = info[.editedImage]
            parent.image = editedImage as? UIImage
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Cordinator {
        let cordinator = Cordinator(self)
        return cordinator
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
}

