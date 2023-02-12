//
//  ProfileSettings.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import RealmSwift
import PhotosUI

struct ProfileSettings: View {
    
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userAge: Int = 0
    @State var profileImage: UIImage?
    @State var imageCode: Data?
    @State var dateOfBirthday: Date = Date.now
    @State private var showPicker: Bool = false
    @State private var photosItem: PhotosPickerItem?
    
    @EnvironmentObject var realmManager: RealmManager
    @Environment(\.dismiss) var dismiss
    @ObservedResults(Profileinfo.self) var profileData
    
    var body: some View {
        
        GeometryReader { geometry in
            
            Constants.backgroundColorApp
                .ignoresSafeArea(.all)
            
            VStack(alignment: .center) {
                
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .offset(x: 20)
                    }
                    
                    Spacer()
                    Text("Edit profile")
                        .foregroundColor(Constants.textColor)
                        .font(.callout)
                        .padding(.bottom)
                    Spacer()
                }
                
                CustomDivider(
                    width: geometry.size.width * Scales.Shared.zeroDotNinePt,
                    height: Scales.Shared.onePt, color: .white
                )
                .padding(.bottom)
                
                if let image = profileImage {
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * Scales.Shared.zeroDotNinePt,
                               height: geometry.size.height * Scales.Shared.zeroDotThreePt)
                        .cornerRadius(Scales.Shared.sixteenPt)
                    
                    Button {
                        showPicker = true
                    } label: {
                        
                        Text(Strings.Shared.upload)
                            .foregroundColor(Constants.textColor)
                            .padding([.leading, .trailing], geometry.size.width * Scales.Shared.zeroDotThirtySevenPt)
                            .padding([.top, .bottom], Scales.Shared.tenPt)
                            .background(.gray.opacity(Scales.Shared.zeroDotFivePt))
                            .cornerRadius(Scales.Shared.fivePt)
                    }
                    
                } else {
                    
                    Button {
                        showPicker = true
                    } label: {
                        AddItemPlaceHolder(geometry: geometry,
                                           addItemText: Strings.Shared.addPicture)
                        .frame(width: geometry.size.width * Scales.Shared.zeroDotNinePt,
                               height: geometry.size.height * Scales.Shared.zeroDotThreePt)
                        .background(Constants.accentPlaceHolderColor.opacity(Scales.Shared.zeroDotSeventyFivePt))
                        .cornerRadius(Scales.Shared.sixteenPt)
                    }
                }
                
                Group {
                    InputField(
                        textFieldName: Strings.Shared.yourName,
                        textFieldType: .singularLine, currentDate: $dateOfBirthday,
                        text: $userName
                    )
                    
                    InputField(
                        textFieldName: Strings.Shared.yourBirthDate,
                        textFieldType: .datePicker, currentDate: $dateOfBirthday, text: $userBio,
                        userAge: $userAge
                    )
                    
                    InputField(
                        textFieldName: Strings.Shared.yourBio,
                        textFieldType: .multipleLines,
                        currentDate: $dateOfBirthday,
                        text: $userBio
                    )
                }
                .frame(width: geometry.size.width * Scales.Shared.zeroDotEightHundrerFifteenPt)
                .padding()
                .background(Constants.accentPlaceHolderColor.opacity(Scales.Shared.zeroDotSeventyFivePt))
                .cornerRadius(Scales.Shared.sixteenPt)
                
                Button {
                    realmManager.elimanteLastObject()
                    $profileData.append(Profileinfo(
                        name: userName,
                        userAge: userAge,
                        bioDescription: userBio,
                        pictureProfile: imageCode ?? Data()
                    ))
                    dismiss()
                } label: {
                    Text(Strings.Shared.save)
                        .foregroundColor(Constants.textColor)
                        .padding([.leading, .trailing], geometry.size.width * Scales.Shared.zeroDotThirtyNinept)
                        .padding([.top, .bottom], Scales.Shared.tenPt)
                        .background(.gray.opacity(Scales.Shared.zeroDotFivePt))
                        .cornerRadius(Scales.Shared.fivePt)
                }
            }.frame(maxWidth: .infinity)
        }
        .onAppear {
            self.userName = profileData.last?.name ?? Strings.Shared.empty
            self.userBio = profileData.last?.bioDescription ?? Strings.Shared.empty
            self.userAge = profileData.last?.userAge ?? 0
        }
        .task {
            if let image = UIImage(data: profileData.last?.pictureProfile ?? Data()) {
                await MainActor.run(body: {
                    profileImage = image
                    imageCode = profileData.last?.pictureProfile ?? Data()
                })
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $photosItem)
        .onChange(of: photosItem) { newValue in
            if let newValue {
                Task {
                    if let imageData = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: imageData) {
                        await MainActor.run(body: {
                            profileImage = image
                            imageCode = imageData
                        })
                    }
                }
            }
        }
    }
}

