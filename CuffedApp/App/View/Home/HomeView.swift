//
//  ContentView.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    
    @ObservedResults(Milestone.self) var milestoneData
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .center) {
                        
                        VStack {
                            
                            Text(Strings.yourProfile)
                                .foregroundColor(Constants.textColor)
                                .font(.callout)
                                .padding(.bottom)
                            
                            CustomDivider(
                                width: geometry.size.width * Scales.zeroDotNinePt,
                                height: Scales.onePt, color: .white
                            )
                            .opacity(Scales.zeroDotFifteenPt)
                            
                        }.padding(.top, geometry.size.height * Scales.zeroDotZeroThirtyFivept)
                        
                        ProfileDetailsView(geometry: geometry)
                            .frame(
                                width: geometry.size.width * Scales.zeroDorEightyNinePt,
                                height: geometry.size.height * Scales.zeroDotTwentyFivePt
                            )
                            .padding(.top, geometry.size.height * Scales.zeroDotZeroOne)
                            .zIndex(2)
                        
                        HStack {
                            Text(Strings.milestones)
                                .font(.system(size: Scales.sixteenPt, weight: .bold))
                                .foregroundColor(Constants.textColor)
                                .padding(.trailing, geometry.size.height * Scales.zeroDotZeroEigth)
                            
                            CustomDivider(
                                width: geometry.size.width * Scales.zeroDotFivePt,
                                height: Scales.onePt, color: .white
                            )
                            .opacity(Scales.zeroDotFifteenPt)
                        }
                        
                        ForEach(milestoneData, id: \.id) { milestone in
                            
                            MilestoneDetailView(
                                imageData: milestone.milestoneImage ?? Data(),
                                title: milestone.title,
                                descrition: milestone.description,
                                geometry: geometry
                            )
                            .zIndex(0)
                            .contextMenu {
                                Button(
                                    action: {
                                        withAnimation(.easeInOut) {
                                            $milestoneData.remove(milestone)
                                        }                                    },
                                    label: {
                                        HStack {
                                            Text(Strings.delete)
                                            Spacer()
                                            Image(systemName: Strings.trash)
                                        }
                                    }
                                )
                                
                            }
                            .mySwipeAction(
                                action: {
                                    withAnimation(.easeInOut) {
                                        $milestoneData.remove(milestone)
                                    }
                                })
                            .frame(
                                width: geometry.size.width * Scales.zeroDorEightyNinePt,
                                height: geometry.size.height * Scales.zeroDotThreePt
                            )
                            .cornerRadius(Scales.sixteenPt)
                            
                        }
                        
                        NavigationLink {
                            MilestoneFormView()
                                .navigationBarHidden(true)
                        } label: {
                            
                            AddItemPlaceholder(
                                geometry: geometry,
                                addItemText: Strings.addMilestone
                            )
                            .frame(
                                width: geometry.size.width * Scales.zeroDorEightyNinePt,
                                height: geometry.size.height * Scales.zeroDotThreePt
                            )
                            .background(Constants.inputFieldColor.opacity(Scales.zeroDotZeroFivePt))
                            .cornerRadius(Scales.sixteenPt)
                            .padding(.top, Scales.eightPt)
                        }
                        .zIndex(2)
                    }.frame(maxWidth: .infinity)
                }
                .background {
                    Constants.backgroundColorApp
                        .ignoresSafeArea(.all)
                }
                .overlay {
                    OverView(geometry: geometry)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
