//
//  MilestonePlaceHolder.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

struct AddItemPlaceholder: View {
    
    let geometry: GeometryProxy
    let addItemText: String
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Image(systemName: Strings.plusIcon)
                .resizable()
                .frame(width: Scales.twentyPt,
                       height: geometry.size.height * Scales.zeroDotZeroThreePt)
                .foregroundColor(.white)
                .padding(.bottom)
            
            Text(addItemText)
                .font(.system(size: Scales.fourTeenPt, weight: .bold ))
                .foregroundColor(Constants.textColor)
            
        }
        .frame(maxWidth: .infinity)
    }
}

struct MilestonePlaceHolder_Previews: PreviewProvider {
    static var previews: some View {
        
        GeometryReader { geometry in
            
            AddItemPlaceholder(
                geometry: geometry,
                addItemText: "Add Milestone"
            )
        }
    }
}
