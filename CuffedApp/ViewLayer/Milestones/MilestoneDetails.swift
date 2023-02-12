//
//  MilestoneDetails.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

struct MilestoneDetails: View {
    
    let title: String
    let descrition: String
    let geometry: GeometryProxy
    @State var imageData: Data
    @State var imageRow: UIImage?
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            Image(uiImage: imageRow ?? UIImage())
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .overlay {
                    LinearGradient(
                        colors: [.clear, .clear, .black],
                        startPoint: .top,
                        endPoint: .bottom)
                }
            
            VStack(alignment: .leading) {
                
                Text(title)
                    .font(.system(size: Scales.Shared.seventTeenPt, weight: .bold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(Scales.Shared.zeroDotEightyEightPt)
                
                Text(descrition)
                    .font(.system(size: Scales.Shared.fourTeenPt, weight: .regular))
                    .foregroundColor(.white)
                    .minimumScaleFactor(Scales.Shared.zeroDotEightyEightPt)
            }
            .padding(.leading, Scales.Shared.twentyPt)
            .padding(.top, 150)
        }
        .task {
            if let image = UIImage(data: imageData) {
                await MainActor.run(body: {
                    imageRow = image
                })
            }
        }
        
    }
}

struct MilestoneDetails_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            MilestoneDetails(
                title: "Graduated Standford 2014",
                descrition: "Sent 4 years studying a CS degree. Met my best friend here.",
                geometry: geometry, imageData: Data()
            )
        }
    }
}
