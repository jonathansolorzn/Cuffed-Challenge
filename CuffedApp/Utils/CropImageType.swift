//
//  CropImagesModel.swift
//  CuffedApp
//
//  Created by Jonathan on 15/2/23.
//

import SwiftUI

enum CropImageType: Equatable {
    
    case circle
    case rectangle
    case square
    case custom(CGSize)
    
    func name() -> String {
        switch self {
        case .circle: return Strings.circle
        case .rectangle: return Strings.rectangle
        case .square: return Strings.square
        case let .custom( cGSize):
            return "Custom \(Int(cGSize.width)) x \(Int(cGSize.height))"
        }
    }
    func size() -> CGSize {
        switch self {
        case .circle: return .init(
            width: Scales.threeHundredPt,
            height: Scales.threeHundredPt
        )
        case .rectangle: return .init(
            width: Scales.threeHundredPt,
            height: Scales.oneHundrerPt
        )
        case .square: return .init(
            width: Scales.threeHundredPt,
            height: Scales.threeHundredPt
        )
        case .custom(let cGSize): return cGSize
        }
    }
}
