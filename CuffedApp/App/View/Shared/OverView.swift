//
//  OverView.swift
//  CuffedApp
//
//  Created by Jonathan on 14/2/23.
//

import SwiftUI

struct OverView: View {
    
    let geometry: GeometryProxy
    
    var body: some View {
        
        ZStack {
                        
            Image(Strings.overView1)
                .resizable()
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height * Scales.zerDotFiftySixPt)
                .offset(
                    x: -(geometry.size.width * Scales.zeroDotOnePt),
                    y: -(geometry.size.height *  Scales.zeroDotThreePt))
                .allowsHitTesting(false)
                
            Image(Strings.overView2)
                .resizable()
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height * Scales.zeroDotNinePt)
                .offset(
                    x: -(geometry.size.width * Scales.zeroDotTwoPt),
                    y: (geometry.size.height * Scales.zeroDotTwentyFivePt) )
                .allowsHitTesting(false)

            Image(Strings.overView3)
                .resizable()
                .frame(
                    width: geometry.size.width * Scales.zeroDotSevenPt,
                    height: geometry.size.height * Scales.zeroDotSixPt)
                .offset(
                    x: geometry.size.width * Scales.zeroDotTwoPt,
                    y: Scales.zeroPt)
                .opacity(Scales.zeroDotEightPt)
                .allowsHitTesting(false)
        
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geomtry in
            OverView(geometry: geomtry)
        }
    }
}
