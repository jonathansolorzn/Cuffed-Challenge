//
//  MilestoneForm.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import PhotosUI
import RealmSwift

struct MilestoneFormView: View {
    
    @FocusState var focusedInput: Int?
    @FocusState var keyboard: Bool
    @StateObject private var milestoneViewModel = MilestoneViewModel()
    @Environment(\.dismiss) var dismiss
    @ObservedResults(Milestone.self) var milestoneData
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    ZStack {
                        VStack(alignment: .center) {
                            HStack {
                                
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: Strings.backButton)
                                        .foregroundColor(.white)
                                        .offset(x: Scales.seventTeenPt)
                                        .frame(width: Scales.thirtyPt, height: Scales.thirtyPt)
                                }
                                
                                Spacer()
                                    .frame(width: geometry.size.width * Scales.zeroDotThreePt)
                                
                                Text(Strings.addMilestone)
                                    .foregroundColor(Constants.textColor)
                                    .font(.callout)
                                
                                Spacer()
                            }
                            .offset(y: geometry.size.height * -Scales.zeroDotTwnetyTwo)
                            
                            CustomDivider(
                                width: geometry.size.width * Scales.zeroDorEightyNinePt,
                                height: Scales.onePt, color: .white
                            )
                            .padding(.bottom)
                            .opacity(Scales.zeroDotFifteenPt)
                            
                            if let image = milestoneViewModel.profileImage {
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(
                                        width: geometry.size.width * Scales.zeroDotNinePt,
                                        height: geometry.size.height * Scales.zeroDotThreePt
                                    )
                                    .cornerRadius(Scales.sixteenPt)
                                    .padding(.bottom, Scales.tenPt)
                                
                            } else {
                                
                                Button {
                                    milestoneViewModel.showPicker = true
                                } label: {
                                    AddItemPlaceholder(
                                        geometry: geometry,
                                        addItemText: Strings.addPicture
                                    )
                                    .frame(
                                        width: geometry.size.width * Scales.zeroDotNinePt,
                                        height: geometry.size.height * Scales.zeroDotThreePt
                                    )
                                    .background(Constants.inputFieldColor.opacity(Scales.zeroDotZeroFivePt))
                                    .cornerRadius(Scales.sixteenPt)
                                    .padding(.bottom, Scales.tenPt)
                                }
                            }
                            
                            Group {
                                InputField(
                                    textFieldName: Strings.title,
                                    textFieldType: .singularLine,
                                    placeHolderTextField: Strings.writeATitle,
                                    currentDate: $milestoneViewModel.dateOfBirthday,
                                    text: $milestoneViewModel.title
                                )
                                .focused($keyboard)
                                
                                InputField(
                                    textFieldName: Strings.description,
                                    textFieldType: .multipleLines,
                                    placeHolderTextField: Strings.writeADescription,
                                    currentDate: $milestoneViewModel.dateOfBirthday,
                                    text: $milestoneViewModel.description
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
                                .id(milestoneViewModel.id)
                                .focused($keyboard)
                            }
                            .frame(width: geometry.size.width * Scales.zeroDotEightHundrerFifteenPt)
                            .padding([.top, .bottom], Scales.eleventPt)
                            .padding([.leading, .trailing])
                            .background(Constants.inputFieldColor.opacity(Scales.zeroDotZeroFivePt))
                            .cornerRadius(Scales.fivePt)
                            .padding(.bottom, Scales.tenPt)
                            
                            Button {
                                $milestoneData
                                    .append(
                                        Milestone(
                                            title: milestoneViewModel.title,
                                            descriptionMilestone: milestoneViewModel.description,
                                            milestoneImage: milestoneViewModel.imageCode ?? Data()
                                        )
                                    )
                                dismiss()
                            } label: {
                                Text(Strings.save)
                                    .foregroundColor(Constants.textColor)
                                    .padding(
                                        [.leading, .trailing],
                                        geometry.size.width * Scales.zeroDorFourHundrerOnePt
                                    )
                                    .padding([.top, .bottom], Scales.tenPt)
                                    .background(Constants.inputFieldColor.opacity( Scales.zeroDotFifteenPt))
                                    .cornerRadius(Scales.fivePt)
                                    .padding(.top)
                            }
                            .disabled(milestoneViewModel.disableButton())
                            
                        }
                        .frame(maxWidth: .infinity)
                        .onChange(of: milestoneViewModel.description) { _ in
                            withAnimation {
                                proxy.scrollTo(milestoneViewModel.id, anchor: .bottom)
                            }
                        }
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded({ _ in
                                    keyboard = false
                                })
                        )
                    }
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
        .onChange(of: milestoneViewModel.photosItem) { milestoneViewModel.getPhotoFromDevice($0) }
        .photosPicker(
            isPresented: $milestoneViewModel.showPicker,
            selection: $milestoneViewModel.photosItem,
            matching: .images
        )
        
    }
}

struct MilestoneForm_Previews: PreviewProvider {
    static var previews: some View {
        MilestoneFormView()
    }
}
