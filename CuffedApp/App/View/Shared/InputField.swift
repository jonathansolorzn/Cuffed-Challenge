//
//  InputField.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

struct InputField: View {
    
    @Binding var userAge: Int
    @Binding var currentDate: Date
    @Binding var text: String
    
    let textFieldName: String
    let textFieldType: TextFieldType
    let placeHolderTextField: String
    
    init (
        textFieldName: String,
        textFieldType: TextFieldType,
        placeHolderTextField: String,
        currentDate: Binding<Date>,
        text: Binding<String>
    ) {
        self.textFieldName = textFieldName
        self.textFieldType = textFieldType
        self.placeHolderTextField = placeHolderTextField
        self._currentDate = currentDate
        self._text = text
        self._userAge = Binding.constant(0)
    }
    
    init (
        textFieldName: String,
        textFieldType: TextFieldType,
        placeHolderTextField: String,
        currentDate: Binding<Date>,
        text: Binding<String>,
        userAge: Binding<Int>
    ) {
        self.textFieldName = textFieldName
        self.textFieldType = textFieldType
        self.placeHolderTextField = placeHolderTextField
        self._currentDate = currentDate
        self._text = text
        self._userAge = userAge
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(textFieldName)
                .font(.subheadline)
                .foregroundColor(Constants.inputFieldColor.opacity(Scales.zeroDotFivePt))
            
            switch textFieldType {
                
            case .singularLine:
                TextField(text: $text) {
                    Text(placeHolderTextField)
                        .font(.custom(Fonts.PoppinsLightItalic, size: Scales.sixteenPt))
                        .foregroundColor(.white)
                        .padding(.leading)
                }
                .font(Font.system(size: Scales.fourTeenPt))
                .foregroundColor(.white)
                .padding(Scales.tenPt)
                .background(
                    RoundedRectangle(cornerRadius: Scales.fivePt)
                        .fill(Color.white.opacity(Scales.zeroDotOnePt))
                )
                
            case .multipleLines:
                TextField(Strings.empty, text: $text, axis: .vertical)
                    .lineLimit(Constants.four, reservesSpace: true)
                    .foregroundColor(.white)
                    .font(Font.system(size: Scales.fourTeenPt))
                    .padding()
                    .background(ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: Scales.fivePt)
                            .fill(Color.white.opacity(Scales.zeroDotOnePt))
                        Text(placeHolderTextField)
                            .font(.custom(Fonts.PoppinsLightItalic, size: Scales.sixteenPt))
                            .foregroundColor(.white)
                            .padding(.leading)
                            .opacity(text.isEmpty ? Constants.one : Constants.zero)
                    })
                
            case .datePicker:
                DatePicker(
                    selection: $currentDate,
                    displayedComponents: [.date]) {
                        Text(Strings.selectADate)
                    }
                    .colorScheme(.dark)
                    .onChange(of: currentDate, perform: { _ in
                        
                        let ageComponent = Calendar.current
                            .dateComponents([.year, .month, .day], from: currentDate, to: Date())
                        
                        userAge = Int(ageComponent.year ?? 0)
                    })
            }
        }
    }
}
