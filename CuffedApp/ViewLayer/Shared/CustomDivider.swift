//
//  Divider.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

struct CustomDivider: View {
    
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct Divider_Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider(width: .infinity, height: 1, color: .red )
    }
}
