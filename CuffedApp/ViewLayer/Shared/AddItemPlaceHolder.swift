//
//  MilestonePlaceHolder.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

struct AddItemPlaceHolder: View {
    
    let geometry: GeometryProxy
    let addItemText: String
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Image(systemName: Strings.Shared.plusIcon)
                .resizable()
                .frame(
                    width: Scales.Shared.twentyPt,
                    height: geometry.size.height * Scales.Shared.zeroDotZeroThreePt
                )
                .foregroundColor(.white)
                .padding(.bottom)
            
            Text(addItemText)
                .font(.system(size: Scales.Shared.fourTeenPt, weight: .bold ))
                .foregroundColor(Constants.textColor)
            
        }
        .frame(maxWidth: .infinity)
    }
}

struct MilestonePlaceHolder_Previews: PreviewProvider {
    static var previews: some View {
        
        GeometryReader { geometry in
            
            AddItemPlaceHolder(
                geometry: geometry,
                addItemText: "Add Milestone"
            )
        }
    }
}
