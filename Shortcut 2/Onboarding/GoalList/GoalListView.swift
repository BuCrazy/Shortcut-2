//
//  GoalListView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 7/28/25.
//

import SwiftUI

struct GoalListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var goalsManager: GoalsManager
    @State var feedbackColor: Color = Color.clear
    @Binding var isSheet: Bool
    
    private var buttonLable: String {
        if isSheet {
            "Continue Learning"
        } else {
            "Start Learning"
        }
    }
    var body: some View {
        NavigationStack {
            ZStack {
            
              //  if !isSheet {
                    P171_CircleAnimation(feedbackColor: feedbackColor)
                        .blendMode(.screen)
                        .blur(radius: 28)
                        .offset(y: -450)
                        .opacity(0.4)
                        .allowsHitTesting(false)
                        .zIndex(0)
             //   } else {}
                
                VStack(alignment: .leading, spacing: 16) {
                    GoalPreviewCard_1()
                    GoalPreviewCard_2()
                    Spacer()
                    
//                    CTAButton(buttonText: buttonLable) {
//                        print("Skeo button tapped")
//                        let impact = UIImpactFeedbackGenerator(style: .medium)
//                        impact.impactOccurred()
//                        presentationMode.wrappedValue.dismiss()
//                    }
                //    if !isSheet {
//                        Skeo_Button(buttonLabel: buttonLable) {
//                            print("Skeo button tapped")
//                            let impact = UIImpactFeedbackGenerator(style: .medium)
//                            impact.impactOccurred()
//                            presentationMode.wrappedValue.dismiss()
//                        }
                   // } else {}
                    
                }
                .frame(maxHeight:.infinity)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                

                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor"))
            
        //    .navigationTitle(Text("Goal List"))
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar() {
                ToolbarItem(placement: .topBarLeading) {
                
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Goal List")
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                        Text("The list of goals you need to complete to attain glory!")
                            .font(.system(size: 14))
                            .foregroundColor(Color("Textprimary"))
                            .lineLimit(2)
                    }
                    .padding(.top, isSheet ? 72 : 32)
                }
            }
            .onAppear {
                print("1st Goal status is \(goalsManager.goals[0].status)")
            }
        }
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)

    
    GoalListView(isSheet: .constant(false))
        .environmentObject(goalsManager)
}
