import SwiftUI
struct LanguageSelectionSheet: View {
    @State var feedbackColor: Color = Color.clear
    var body: some View {
        VStack {
            ZStack(alignment: .top){
                VStack{
                    P171_CircleAnimation(feedbackColor: feedbackColor)
                        .blendMode(.screen)
                        .blur(radius: 28)
                        .offset(y: -100)
                        .opacity(0.4)
                    Spacer()
                        .frame(height: .infinity)
                }
                VStack{
                    // Заголовок и подзаголовок
                    VStack(alignment: .leading){
                        Spacer()
                            .frame(height:43)
                        Text("Your native language")
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("MainFontColor"))
                        Spacer()
                            .frame(height:8)
                        Text("This will be the language you'll see translations of English words in.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("MainFontColor"))
                        Spacer()
                            .frame(height:24)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, 0)
                    .padding(.leading, 20)
                    .padding(.trailing, 16)
                    Button(
                        action: {

                        },
                        label: {
                            Text("Choose Elementary")
                                .frame(width: 358, height: 52)
                                .foregroundColor(.white)
                                .background(Color("switchLevelButtonColor"))
                                .cornerRadius(26)
                                .font(Font.custom("Avenir", size: 16))
                        }
                    )
                    Spacer()
                }
            }
            .background(Color("sheetColor"))
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
struct LanguageSelectionSheet_Preview: PreviewProvider {
    @State static var resetAnimationTrigger = false
    static var previews: some View {
        LanguageSelectionSheet()
    }
}
