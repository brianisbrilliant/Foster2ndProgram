//
//  Cam.swift
//  Foster2ndProgram
//
//  Created by Professor Foster on 9/9/20.
//  Copyright © 2020 Professor Foster. All rights reserved.
//

import SwiftUI

struct Cam: View {
    // this is a local variable.
    @State var imageData : Data = .init(capacity: 0)
    @State var show = false
    @State var imagepicker = false
    @State var source : UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: ImagePicker(show: $imagepicker, image: $imageData, source: source), isActive: $imagepicker) {
                    Text("")
                }
                VStack {
                    if imageData.count != 0 {
                        Image(uiImage:UIImage(data: self.imageData)!)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 250, height: 250)
                            .overlay(Circle().stroke(Color.red, lineWidth: 5))
                            .foregroundColor(Color.purple)
                    }
                    else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 250, height: 250)
                            .overlay(Circle().stroke(Color.red, lineWidth: 5))
                            .foregroundColor(Color.purple)
                    }
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Text("Take a Photo!")
                            .frame(width: 150, height: 150, alignment: .center)
                            .background(Color.green)
                    }
                }.actionSheet(isPresented: $show) {
                    ActionSheet(title: Text("Take a photo or select from photo library"), message: Text(""), buttons:
                        [.default(Text("Photo Library"), action: {
                            self.source = .photoLibrary
                            self.imagepicker.toggle()
                        }), .default(Text("Camera"), action: {
                            self.source = .camera
                            self.imagepicker.toggle()
                        })]
                    )
                }
            
            }
        }
    }
}

struct Cam_Previews: PreviewProvider {
    static var previews: some View {
        Cam()
    }
}

struct ImagePicker : UIViewControllerRepresentable {
    @Binding var show : Bool            // should I be showing the ActionSheet?
    @Binding var image : Data           // what image to use in the circle
    var source : UIImagePickerController.SourceType
    
    // this returns a variable that we will build in a bit. I think.
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent : ImagePicker
        init(parent1 : ImagePicker) {
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
        }
        
        
        // this part is for the camera, i am pretty sure!
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let data = image.pngData()
            self.parent.image = data!
            self.parent.show.toggle()
        }
    }
}
