//
//  HomeViewModel.swift
//  CuffedApp
//
//  Created by Jonathan on 15/2/23.
//

import Foundation
import SwiftUI

class ImageViewModel: ObservableObject {
    
    @Published var imageRow: UIImage?
    
    /// This function help us to convert from data to Images to present
    /// - Parameter dataImage: type Data
    func convertDataToImage(_ dataImage: Data?) async {
        if let image = UIImage(data: dataImage ?? Data()) {
            await MainActor.run(body: {
                imageRow = image
            })
        }
    }
}
