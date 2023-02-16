//
//  ProfileSettings.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import RealmSwift
import PhotosUI

struct ProfileSettingsView: View {
    
    @FocusState var focusedInput: Int?
    @FocusState var keyboard: Bool
    @StateObject var profileSettingViewModel = ProfileSettingViewModel()
    @EnvironmentObject var realmManager: RealmManager
    @Environment(\.dismiss) var dismiss
    @ObservedResults(Profile.self) var profileData
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: Strings.chevronBackwards)
                                    .foregroundColor(.white)
                                    .offset(x: Scales.seventTeenPt)
                                    .frame(width: Scales.thirtyPt, height: Scales.thirtyPt)
                            }
                            
                            Spacer()
                            
                            Text(Strings.editProfile)
                                .foregroundColor(Constants.textColor)
                                .font(.callout)
                                .offset(x: geometry.size.width * -Scales.zeroDotZeroThreePt)
                            
                            Spacer()
                        }
                        .offset(y: geometry.size.height * Scales.zeroDotTwo)
                        
                        CustomDivider(
                            width: geometry.size.width * Scales.zeroDotNinePt,
                            height: Scales.onePt, color: .white
                        )
                        .padding(.top, geometry.size.height * Scales.zeroDotZeroThreePt)
                        .padding(.bottom, geometry.size.height * Scales.zeroDotZeroOne)
                        .opacity(Scales.zeroDotFifteenPt)
                        
                        if let image = profileSettingViewModel.profileImage {
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width * Scales.zeroDorEightyNinePt,
                                       height: geometry.size.height * Scales.zeroDotThreePt)
                                .clipShape(Circle())
                            
                            Button {
                                profileSettingViewModel.showPicker = true
                            } label: {
                                Text(Strings.upload)
                                    .foregroundColor(Constants.textColor)
                                    .padding([.leading, .trailing],
                                             geometry.size.width * Scales.zeroDotThreeHundredEightyOnePt)
                                    .padding([.top, .bottom], Scales.tenPt)
                                    .background(.gray.opacity(Scales.zeroDotFivePt))
                                    .cornerRadius(Scales.fivePt)
                            }
                            .padding([.bottom, .top], Scales.tenPt)
                            
                        } else {
                            
                            Button {
                                profileSettingViewModel.showPicker = true
                            } label: {
                                AddItemPlaceholder(
                                    geometry: geometry,
                                    addItemText: Strings.addPicture
                                )
                                .frame(
                                    width: geometry.size.width * Scales.zeroDorEightyNinePt,
                                    height: geometry.size.height * Scales.zeroDotThreePt
                                )
                                .background(Constants.inputFieldColor.opacity(Scales.zeroDotZeroFivePt))
                                .clipShape(Circle())
                                .padding(.bottom, Scales.tenPt)
                            }
                        }
                        
                        Group {
                            InputField(
                                textFieldName: Strings.yourName,
                                textFieldType: .singularLine,
                                placeHolderTextField: Strings.writeYourName,
                                currentDate: $profileSettingViewModel.dateOfBirthday,
                                text: $profileSettingViewModel.userName
                            )
                            .focused($keyboard)
                            
                            InputField(
                                textFieldName: Strings.yourBirthDate,
                                textFieldType: .datePicker,
                                placeHolderTextField: Strings.empty,
                                currentDate: $profileSettingViewModel.dateOfBirthday, text: $profileSettingViewModel.userBio,
                                userAge: $profileSettingViewModel.userAge
                            )
                            .focused($keyboard)
                            
                            InputField(
                                textFieldName: Strings.yourBio,
                                textFieldType: .multipleLines,
                                placeHolderTextField: Strings.writeYourBio,
                                currentDate: $profileSettingViewModel.dateOfBirthday,
                                text: $profileSettingViewModel.userBio
                            )
                            .toolbar {
                                
                                ToolbarItemGroup(placement: .keyboard) {
                                    
                                    Spacer()
                                    
                                    Button {
                                        keyboard = false
                                    } label: {
                                        Text(Strings.done)
                                    }
                                }
                            }
                            .id(profileSettingViewModel.id)
                            .focused($keyboard)
                        }
                        .frame(width: geometry.size.width * Scales.zeroDotEightHundrerFifteenPt)
                        .padding([.top, .bottom], Scales.eleventPt)
                        .padding([.leading, .trailing])
                        .background(Constants.inputFieldColor.opacity(Scales.zeroDotZeroFivePt))
                        .cornerRadius(Scales.fivePt)
                        .padding(.bottom, Scales.tenPt)
                        
                        Button {
                            realmManager.elimanteLastObject()
                            $profileData.append(Profile(
                                name: profileSettingViewModel.userName,
                                userAge: profileSettingViewModel.userAge,
                                bioDescription: profileSettingViewModel.userBio,
                                pictureProfile: profileSettingViewModel.imageCode ?? Data()))
                            dismiss()
                        } label: {
                            Text(Strings.save)
                                .foregroundColor(Constants.textColor)
                                .padding([.leading, .trailing],
                                         geometry.size.width * Scales.zeroDorFourHundrerOnePt)
                                .padding([.top, .bottom], Scales.tenPt)
                                .background(Constants.inputFieldColor.opacity( Scales.zeroDotFifteenPt))
                                .cornerRadius(Scales.fivePt)
                                .padding(.top)
                        }
                        .disabled(profileSettingViewModel.profileImage == nil)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: profileSettingViewModel.userBio) { _ in
                        withAnimation {
                            proxy.scrollTo(profileSettingViewModel.id, anchor: .bottom)
                        }
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded({ _ in keyboard = false })
                    )
                }
                .background {
                    Constants.backgroundColorApp
                        .ignoresSafeArea(.all)
                }
                .overlay {
                    OverView(geometry: geometry)
                }
            }
        }
        .onAppear {
            profileSettingViewModel.presentDataStorageOnDataBase(profileData.last)
        }
        .task {
            await profileSettingViewModel.convertDataToImage(profileData.last?.pictureProfile)
        }
        .onChange(of: profileSettingViewModel.photosItem) { profileSettingViewModel.getPhotoFromDevice($0)}
        .photosPicker(
            isPresented: $profileSettingViewModel.showPicker,
            selection: $profileSettingViewModel.photosItem,
            matching: .images)
        .fullScreenCover(
            isPresented: $profileSettingViewModel.showEditPictureMode,
            content: {
                EditProfilePictureView(
                    image: $profileSettingViewModel.profileImage, onCrop: { image, data in
                        profileSettingViewModel.profileImage = image
                        profileSettingViewModel.imageCode = data
                        
                    }
                )
            }
        )
    }
}

struct ProfileSettings_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
