//
//  MilestoneForm.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import PhotosUI
import RealmSwift

struct MilestoneForm: View {
    
    @State var title: String = ""
    @State var description: String = ""
    @State var profileImage: UIImage?
    @State var imageCode: Data?
    @State var dateOfBirthday: Date = Date.now
    @State private var showPicker: Bool = false
    @State private var photosItem: PhotosPickerItem?
    
    
    @Environment(\.dismiss) var dismiss
    @ObservedResults(MilestoneData.self) var milestoneData
    
    var body: some View {
        
        GeometryReader { geometry in
            
            Constants.backgroundColorApp
                .ignoresSafeArea(.all)
            
            VStack(alignment: .center) {
                
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: Strings.Shared.backButton)
                            .foregroundColor(.white)
                            .offset(x: 20)
                    }
                    
                    Spacer()
                    Text(Strings.Shared.addMilestone)
                        .foregroundColor(Constants.textColor)
                        .font(.callout)
                        .padding(.bottom)
                    Spacer()
                }
                
                CustomDivider(width: geometry.size.width * Scales.Shared.zeroDotNinePt,
                              height: Scales.Shared.onePt, color: .white)
                .padding(.bottom)
                
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * Scales.Shared.zeroDotNinePt,
                               height: geometry.size.height * Scales.Shared.zeroDotThreePt)
                        .cornerRadius(Scales.Shared.sixteenPt)
                    
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
                        textFieldName: Strings.Shared.title,
                        textFieldType: .singularLine, currentDate: $dateOfBirthday,
                        text: $title
                    )
                    
                    InputField(
                        textFieldName: Strings.Shared.description,
                        textFieldType: .multipleLines,
                        currentDate: $dateOfBirthday,
                        text: $description
                    )
                }
                .frame(width: geometry.size.width * Scales.Shared.zeroDotEightHundrerFifteenPt)
                .padding()
                .background(Constants.accentPlaceHolderColor.opacity(Scales.Shared.zeroDotSeventyFivePt))
                .cornerRadius(Scales.Shared.sixteenPt)
                
                Button {
                    
                    $milestoneData
                        .append(MilestoneData(
                            title: title,
                            descriptionMilestone: description,
                            milestoneImage: imageCode ?? Data()
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

struct MilestoneForm_Previews: PreviewProvider {
    static var previews: some View {
        MilestoneForm()
    }
}
