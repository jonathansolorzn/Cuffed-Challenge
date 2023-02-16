//
//  MilestoneDetails.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

struct MilestoneDetailView: View {
    
    @State var imageData: Data
    @StateObject private var homeViewModel = ImageViewModel()
    
    let title: String
    let descrition: String
    let geometry: GeometryProxy
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            
            Image(uiImage: homeViewModel.imageRow ?? UIImage())
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .overlay {
                    LinearGradient(
                        colors: [
                            .clear,
                            .clear,
                            .black.opacity(Scales.zeroDotEightPt),
                            .black.opacity(Scales.zeroDotEightPt)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .frame(
                    width: geometry.size.width * Scales.zeroDorEightyNinePt,
                    height: geometry.size.height * Scales.zeroDotThreePt
                )
            
            VStack(alignment: .leading) {
                
                Text(title)
                    .font(.system(
                        size: geometry.size.height * Scales.zeroDotTwnetyTwo,
                        weight: .bold
                    ))
                    .foregroundColor(.white)
                    .minimumScaleFactor(Scales.zeroDotEightyEightPt)
                
                Text(descrition)
                    .font(.system(
                        size: geometry.size.height * Scales.zeroDotzeroOneHundredandFive,
                        weight: .regular
                    ))
                    .foregroundColor(.white)
                    .minimumScaleFactor(Scales.zeroDotEightyEightPt)
            }
            .padding(.horizontal, Scales.sixteenPt)
            .padding(.bottom, Scales.twentyFourPt )
        }
        .task {
            await homeViewModel.convertDataToImage(imageData)
        }
        
    }
}

struct MilestoneDetails_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            MilestoneDetailView(
                imageData: Data(),
                title: "Graduated Standford 2014",
                descrition: "Sent 4 years studying a CS degree. Met my best friend here.",
                geometry: geometry
            )
        }
    }
}
