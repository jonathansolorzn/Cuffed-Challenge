//
//  ProfileSettingViewModel.swift
//  CuffedApp
//
//  Created by Jonathan on 15/2/23.
//

import Foundation
import SwiftUI
import PhotosUI

class ProfileSettingViewModel: ObservableObject {
    
    @Published var showEditPictureMode = false
    @Published var userName: String = ""
    @Published var userBio: String = ""
    @Published var userAge: Int = 0
    @Published var id = 1
    @Published var profileImage: UIImage?
    @Published var imageCode: Data?
    @Published var dateOfBirthday: Date = Date.now
    @Published var showPicker: Bool = false
    @Published var photosItem: PhotosPickerItem?
    
    init() {}
    
    /// This function Help us to gatter images from our device
    /// - Parameter photoPickerSelected: Selection from the device
    func getPhotoFromDevice(_ photoPickerSelected: PhotosPickerItem?) {
        if let photoPickerSelected {
            Task {
                if let imageData = try? await photoPickerSelected.loadTransferable(type: Data.self),
                   let image = UIImage(data: imageData) {
                    await MainActor.run(body: {
                        profileImage = image
                        showEditPictureMode = true
                    })
                }
            }
        }
    }
    
    /// This function help us to convert from data to Images to present
    /// - Parameter dataImage: type Data
    func convertDataToImage(_ dataImage: Data?) async {
        if let image = UIImage(data: dataImage ?? Data()) {
            await MainActor.run(body: {
                profileImage = image
                imageCode = dataImage ?? Data()
            })
        }
    }
    
    func presentDataStorageOnDataBase(_ type: Profile?) {
        self.userName = type?.name ?? Strings.empty
        self.userBio = type?.bioDescription ?? Strings.empty
        self.userAge = type?.userAge ?? 0
    }
}
