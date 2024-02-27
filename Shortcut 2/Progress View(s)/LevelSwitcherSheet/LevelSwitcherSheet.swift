import SwiftUI
struct LevelSwitcherSheet: View {
    @State var levelSwitchSheetLevelSelected = 1
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    var body: some View {
        VStack{
            TabView(selection: $levelSwitchSheetLevelSelected){
                VStack{
                    VStack{
                        Image("levelicons_elementary")
                            .frame(width: 120)
                        Spacer()
                            .frame(height: 16)
                        Text("ELEMENTARY")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("MainFontColor"))
                        Spacer()
                            .frame(height: 3)
                        Text("First 500 words")
                            .foregroundStyle(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                        Spacer()
                            .frame(height: 11)
                        Text("Absolute basics to start with. Not enough to start speaking.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("MainFontColor"))
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 11)
                    }.padding([.leading, .trailing], 16)
                }.tag(1)
                VStack{
                    VStack{
                        Image("levelicons_beginner")
                            .frame(width: 120)
                        Spacer()
                            .frame(height: 16)
                        Text("BEGINNER")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("MainFontColor"))
                        Spacer()
                            .frame(height: 3)
                        Text("Top 501 - 2 000 words")
                            .foregroundStyle(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                        Spacer()
                            .frame(height: 11)
                        Text("Enough to be able to express 80 % of your ideas.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("MainFontColor"))
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 11)
                    }.padding([.leading, .trailing], 16)
                }.tag(2)
                VStack{
                    VStack{
                        Image("levelicons_intermediate")
                            .frame(width: 120)
                        Spacer()
                            .frame(height: 16)
                        Text("INTERMEDIATE")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("MainFontColor"))
                        Spacer()
                            .frame(height: 3)
                        Text("Top 2 001 - 5 000 words")
                            .foregroundStyle(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                        Spacer()
                            .frame(height: 11)
                        Text("Enough to work in an English-speaking country")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("MainFontColor"))
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 11)
                    }.padding([.leading, .trailing], 16)
                }.tag(3)
                VStack{
                    VStack{
                        Image("levelicons_advanced")
                            .frame(width: 120)
                        Spacer()
                            .frame(height: 16)
                        Text("ADVANCED")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("MainFontColor"))
                        Spacer()
                            .frame(height: 3)
                        Text("Top 5 001 - 8 500 words")
                            .foregroundStyle(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                        Spacer()
                            .frame(height: 11)
                        Text("Enough to make an excellent impression on a date.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("MainFontColor"))
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 11)
                    }.padding([.leading, .trailing], 16)
                }.tag(4)
                VStack{
                    VStack{
                        Image("levelicons_nativelike")
                            .frame(width: 120)
                        Spacer()
                            .frame(height: 16)
                        Text("NATIVE-LIKE")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("MainFontColor"))
                        Spacer()
                            .frame(height: 3)
                        Text("Top 8 501 - 12 500 words")
                            .foregroundStyle(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                        Spacer()
                            .frame(height: 11)
                        Text("Be able to communicate up to 99 % of your ideas with ease.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("MainFontColor"))
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 11)
                    }.padding([.leading, .trailing], 16)
                }.tag(5)
                VStack{
                    VStack{
                        Image("levelicons_borninengland")
                            .frame(width: 120)
                        Spacer()
                            .frame(height: 16)
                        Text("SHAKESPEARE")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(Color("MainFontColor"))
                        Spacer()
                            .frame(height: 3)
                        Text("Top 12 501 - 20 000 words")
                            .foregroundStyle(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                        Spacer()
                            .frame(height: 11)
                        Text("Not worth spending your time on it. All the previous level are just enough.")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("MainFontColor"))
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 11)
                    }.padding([.leading, .trailing], 16)
                }.tag(6)
            }
            .tabViewStyle(.page)
            .presentationDetents([.medium, .large])
            switch levelSwitchSheetLevelSelected {
            case 1:
                Button(
                    action: {
                        currentLevelSelected = "elementary"
                    },
                    label: {
                        Text("Switch to Elementary")
                            .frame(width: 358, height: 52)
                            .foregroundColor(.white)
                            .background(Color("switchLevelButtonColor"))
                            .cornerRadius(26)
                            .font(Font.custom("Avenir", size: 16))
                    }
                )
            case 2:
                Button(
                    action: {
                        currentLevelSelected = "beginner"
                    },
                    label: {
                        Text("Switch to Beginner")
                            .frame(width: 358, height: 52)
                            .foregroundColor(.white)
                            .background(Color("switchLevelButtonColor"))
                            .cornerRadius(26)
                            .font(Font.custom("Avenir", size: 16))
                    }
                )
            case 3:
                Button(
                    action: {
                        currentLevelSelected = "intermediate"
                    },
                    label: {
                        Text("Switch to Intermediate")
                            .frame(width: 358, height: 52)
                            .foregroundColor(.white)
                            .background(Color("switchLevelButtonColor"))
                            .cornerRadius(26)
                            .font(Font.custom("Avenir", size: 16))
                    }
                )
            case 4:
                Button(
                    action: {
                        currentLevelSelected = "advanced"
                    },
                    label: {
                        Text("Switch to Advanced")
                            .frame(width: 358, height: 52)
                            .foregroundColor(.white)
                            .background(Color("switchLevelButtonColor"))
                            .cornerRadius(26)
                            .font(Font.custom("Avenir", size: 16))
                    }
                )
            case 5:
                Button(
                    action: {
                        currentLevelSelected = "nativelike"
                    },
                    label: {
                        Text("Switch to Native-like")
                            .frame(width: 358, height: 52)
                            .foregroundColor(.white)
                            .background(Color("switchLevelButtonColor"))
                            .cornerRadius(26)
                            .font(Font.custom("Avenir", size: 16))
                    }
                )
            case 6:
                Button(
                    action: {
                        currentLevelSelected = "beginner"
                    },
                    label: {
                        Text("Switch to Beginner")
                            .frame(width: 358, height: 52)
                            .foregroundColor(.white)
                            .background(Color("switchLevelButtonColor"))
                            .cornerRadius(26)
                            .font(Font.custom("Avenir", size: 16))
                    }
                )
            default:
                Button(
                    action: {
                        currentLevelSelected = "borininengland"
                    },
                    label: {
                        Text("Switch to Shakespeare")
                            .frame(width: 358, height: 52)
                            .foregroundColor(.white)
                            .background(Color("switchLevelButtonColor"))
                            .cornerRadius(26)
                            .font(Font.custom("Avenir", size: 16))
                    }
                )
            }
            Spacer()
        }
        .background(Color("sheetColor"))
    }
}
#Preview {
    LevelSwitcherSheet()
}
