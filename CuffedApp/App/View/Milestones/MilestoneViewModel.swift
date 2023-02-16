//
//  MilestoneViewModel.swift
//  CuffedApp
//
//  Created by Jonathan on 15/2/23.
//

import Foundation
import SwiftUI
import PhotosUI

class MilestoneViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var profileImage: UIImage?
    @Published var imageCode: Data?
    @Published var dateOfBirthday: Date = Date.now
    @Published var showPicker: Bool = false
    @Published var photosItem: PhotosPickerItem?
    @Published var id = 1
    @Published var crop: CropImageType = .square
    
    init() { }
    
    /// This function Help us to gatter images from our device
    /// - Parameter photoPickerSelected: Selection from the device
    func getPhotoFromDevice(_ photoPickerSelected: PhotosPickerItem?) {
        
        if let photoPickerSelected {
            
            Task {
                if let imageData = try? await photoPickerSelected.loadTransferable(type: Data.self),
                   let image = UIImage(data: imageData) {
                    await MainActor.run(body: {
                        
                        let renderer = ImageRenderer(content: Image(uiImage: image))
                        renderer.proposedSize = .init(crop.size())
                        
                        if let imageSquare = renderer.uiImage {
                            
                            let imageData = image.pngData()
                            profileImage = imageSquare
                            imageCode = imageData
                            
                        }
                    })
                }
            }
        }
    }
    
    func disableButton() -> Bool {
        profileImage == nil
    }
    
}
