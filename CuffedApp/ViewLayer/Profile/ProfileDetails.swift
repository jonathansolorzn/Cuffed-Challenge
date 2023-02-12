//
//  ProfileDetails.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import RealmSwift

struct ProfileDetails: View {
    
    let geometry: GeometryProxy
    
    private var userInformation: UserInformation {
        if !profileData.isEmpty {
            return .init(
                name: profileData.last?.name ?? "",
                age: "\(profileData.last?.userAge ?? 0)",
                bioDescription: profileData.last?.bioDescription ?? ""
            )
        } else {
            return .init(
                name: Strings.Shared.yourName,
                age: Strings.Shared.yourAge,
                bioDescription: Strings.Shared.aShortBio
            )
        }
    }
    
    @State var showSettingView: Bool = false
    @State var imageRow: UIImage?
    
    @ObservedResults(Profileinfo.self) var profileData
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            HStack {
                
                if profileData.isEmpty {
                    Image(Strings.Shared.progilePictureExample)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * Scales.Shared.zeroDotThirtyFivePt, height: geometry.size.height * Scales.Shared.zeroDotFourPt)
                        .clipShape(Circle())
                        .padding(.leading)
                } else {
                    Image(uiImage: imageRow ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * Scales.Shared.zeroDotThirtyFivePt, height: geometry.size.height * Scales.Shared.zeroDotFourPt)
                        .clipShape(Circle())
                        .padding(.leading)
                }
                
                VStack(alignment: .leading, spacing: Scales.Shared.twentyPt) {
                    
                    Text(userInformation.name)
                        .foregroundColor(Constants.textColor)
                        .font(.title3)
                        .bold()
                    
                    Text(userInformation.age)
                        .foregroundColor(Constants.textColor)
                        .font(.subheadline)
                    
                    Text(userInformation.bioDescription)
                        .foregroundColor(Constants.textColor)
                        .font(.subheadline)
                }
                
                Spacer()
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: geometry.size.height * Scales.Shared.zeroDotTwentyFivePt
            )
            .background(Constants.profileBackgoundColor.opacity(Scales.Shared.zeroDotZeroFivePt))
            .cornerRadius(Scales.Shared.twelvePt)
            
            NavigationLink {
                ProfileSettings()
                    .navigationBarHidden(true)
            } label: {
                Text(Strings.Shared.edit)
                    .foregroundColor(Constants.textColor)
                    .padding([.leading, .trailing], geometry.size.width * Scales.Shared.zeroDotFourPt)
                    .padding([.top, .bottom], Scales.Shared.tenPt)
                    .background(.gray.opacity(Scales.Shared.zeroDotTwoPt))
                    .cornerRadius(Scales.Shared.fivePt)
            }
        }
        .task {
            if let image = UIImage(data: profileData.last?.pictureProfile ?? Data()) {
                await MainActor.run(body: {
                    imageRow = image
                })
            }
        }
    }
}

struct ProfileDetails_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ProfileDetails(geometry: geometry)
        }
    }
}
