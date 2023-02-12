//
//  InputField.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

struct InputField: View {
    
    let textFieldName: String
    let textFieldType: TextFieldType
    
    @Binding var userAge: Int
    @Binding var currentDate: Date
    @Binding var text: String
    
    init(
        textFieldName: String,
        textFieldType: TextFieldType,
        currentDate: Binding<Date>,
        text: Binding<String>
    ) {
        self.textFieldName = textFieldName
        self.textFieldType = textFieldType
        self._currentDate = currentDate
        self._text = text
        self._userAge = Binding.constant(0)
    }
    
    init(
        textFieldName: String,
        textFieldType: TextFieldType,
        currentDate: Binding<Date>,
        text: Binding<String>,
        userAge: Binding<Int>
    ) {
        self.textFieldName = textFieldName
        self.textFieldType = textFieldType
        self._currentDate = currentDate
        self._text = text
        self._userAge = userAge
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(textFieldName)
                .font(.subheadline)
                .foregroundColor(Constants.textColor)
            
            switch textFieldType {
                
            case .singularLine:
                TextField(Strings.Shared.empty, text: $text)
                    .font(Font.system(size: Scales.Shared.fourTeenPt))
                    .padding(Scales.Shared.tenPt)
                    .background(RoundedRectangle(cornerRadius: Scales.Shared.tenPt).fill(Color.white))
                    .foregroundColor(.black)
                
            case .multipleLines:
                TextField(Strings.Shared.empty, text: $text, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
                    .font(Font.system(size: Scales.Shared.fourTeenPt))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: Scales.Shared.tenPt).fill(Color.white))
                    .foregroundColor(.black)
                
            case .datePicker:
                DatePicker(
                    selection: $currentDate,
                    displayedComponents: [.date]) {
                        Text(Strings.Shared.selectADate)
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
