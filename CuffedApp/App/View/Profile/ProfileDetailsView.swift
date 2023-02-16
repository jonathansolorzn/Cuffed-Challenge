//
//  ProfileDetails.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import RealmSwift

struct ProfileDetailsView: View {
    
    @StateObject private var imageViewModel = ImageViewModel()
    @ObservedResults(Profile.self) var profileData
    
    let geometry: GeometryProxy
    
    private var userInformation: UserInformation {
        
        if !profileData.isEmpty {
            return .init(
                name: profileData.last?.name ?? "",
                age: "\(profileData.last?.userAge ?? 0) \(Strings.yearsOld)",
                bioDescription: profileData.last?.bioDescription ?? ""
            )
        } else {
            return .init(
                name: Strings.yourName,
                age: Strings.yourAge,
                bioDescription: Strings.aShortBio
            )
        }
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            HStack(spacing: geometry.size.width * Scales.zeroDotSix) {
                
                if profileData.isEmpty {
                    Image(Strings.progilePictureExample)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.width * Scales.zeroDotTwentyEightPt,
                            height: geometry.size.width * Scales.zeroDotTwentyEightPt
                        )
                        .clipShape(Circle())
                        .padding(.leading)
                    
                } else {
                    Image(uiImage: imageViewModel.imageRow ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width * Scales.zeroDotTwentyEightPt,
                            height: geometry.size.width * Scales.zeroDotTwentyEightPt
                        )
                        .clipShape(Circle())
                        .padding(.leading)
                }
                
                VStack(alignment: .leading, spacing: Scales.tenPt) {
                    
                    Text(userInformation.name.isEmpty ?
                         Strings.yourName :
                            userInformation.name )
                    .foregroundColor(Constants.textColor)
                    .font(.title2)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(Constants.two)
                    
                    Text(userInformation.age == "0" ?
                         Strings.yourAge :
                            userInformation.age )
                    .foregroundColor(Constants.textColor)
                    .font(.caption)
                    
                    Text(userInformation.bioDescription.isEmpty ?
                         Strings.aShortBio :
                            userInformation.bioDescription )
                    .foregroundColor(Constants.textColor)
                    .font(.caption)
                }
                
                Spacer()
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: geometry.size.height * Scales.zeroDotTwentyFivePt
            )
            .background(Constants.inputFieldColor.opacity(Scales.zeroDotZeroFivePt))
            .cornerRadius(Scales.twelvePt)
            
            NavigationLink {
                ProfileSettingsView()
                    .navigationBarHidden(true)
            } label: {
                Text(Strings.edit)
                    .frame(width: geometry.size.width * Scales.zeroDotEightryEightPt)
                    .font(.subheadline)
                    .foregroundColor(Constants.textColor)
                    .padding([.top, .bottom], Scales.tenPt)
                    .background(.gray.opacity(Scales.zeroDotTwoPt))
                    .cornerRadius(Scales.fivePt)
            }
        }
        .task {
            await imageViewModel.convertDataToImage(profileData.last?.pictureProfile)
        }
    }
}

struct ProfileDetails_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in        
            ProfileDetailsView(geometry: geometry)
        }
    }
}
