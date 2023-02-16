//
//  View+Frame.swift
//  CuffedApp
//
//  Created by Jonathan on 15/2/23.
//

import SwiftUI

extension View {
    
    func frame(_ size: CGSize ) -> some View {
        self.frame(width: size.width, height: size.height)
    }
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
