//
//  ContentView.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import RealmSwift

struct HomeScreen: View {
    @ObservedResults(MilestoneData.self) var milestoneData
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                
                Constants.backgroundColorApp
                    .ignoresSafeArea(.all)
                
                VStack(alignment: .center) {
                    
                    Text(Strings.Shared.yourProfile)
                        .foregroundColor(Constants.textColor)
                        .font(.callout)
                        .padding(.bottom)
                    
                    CustomDivider(
                        width: geometry.size.width * Scales.Shared.zeroDotNinePt,
                        height: Scales.Shared.onePt, color: .white
                    )
                    
                    ProfileDetails(geometry: geometry)
                        .frame(
                            width: geometry.size.width * Scales.Shared.zeroDotNinePt,
                            height: geometry.size.height * Scales.Shared.zeroDotThirtyFivePt
                        )
                    
                    HStack {
                        
                        Text(Strings.Shared.milestones)
                            .font(.system(size: Scales.Shared.sixteenPt, weight: .bold))
                            .foregroundColor(Constants.textColor)
                            .padding(.trailing, Scales.Shared.fortyFivePt)
                        
                        CustomDivider(
                            width: geometry.size.width * Scales.Shared.zeroDotFivePt,
                            height: Scales.Shared.onePt, color: .white
                        )
                    }
                    
                    ScrollView {
                        
                        ForEach(milestoneData, id: \.id) { milestone in
                            
                            MilestoneDetails(
                                title: milestone.title,
                                descrition: milestone.descriptionMilestone,
                                geometry: geometry,
                                imageData: milestone.milestoneImage ?? Data()
                            )
                            .contextMenu {
                                
                                Button(action: {
                                    $milestoneData.remove(milestone)
                                }, label: {
                                    HStack {
                                        Text(Strings.Shared.delete)
                                        Spacer()
                                        Image(systemName: Strings.Shared.trash)
                                    }
                                })
                                
                            }
                            .frame(
                                width: geometry.size.width * Scales.Shared.zeroDotEightySevenPt,
                                height: geometry.size.height * Scales.Shared.zeroDotThreePt
                            )
                            .cornerRadius(Scales.Shared.sixteenPt)
                            
                        }
                        NavigationLink {
                            MilestoneForm()
                                .navigationBarHidden(true)
                        } label: {
                            
                            AddItemPlaceHolder(
                                geometry: geometry,
                                addItemText: Strings.Shared.addMilestone
                            )
                            .frame(
                                width: geometry.size.width * Scales.Shared.zeroDotEightySevenPt,
                                height: geometry.size.height * Scales.Shared.zeroDotThreePt
                            )
                            .background(Constants.accentPlaceHolderColor.opacity(Scales.Shared.zeroDotSeventyFivePt))
                            .cornerRadius(Scales.Shared.sixteenPt)
                            .padding(.top, Scales.Shared.eightPt)
                        }
                    }
                }.frame(maxWidth: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
