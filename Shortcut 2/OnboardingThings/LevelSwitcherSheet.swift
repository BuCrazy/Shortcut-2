import SwiftUI
import Charts
import Marquee
struct LevelSelectorData: Identifiable {
    var id = UUID().uuidString
    var hour: Double
    var almostLearnedWords: Double
    var animate: Bool = false
}
var level_selector_data: [LevelSelectorData] = [
    LevelSelectorData(hour: 0, almostLearnedWords: 100),
    LevelSelectorData(hour: 1, almostLearnedWords: 50),
    LevelSelectorData(hour: 4, almostLearnedWords: 20),
    LevelSelectorData(hour: 10, almostLearnedWords: 10),
    LevelSelectorData(hour: 17, almostLearnedWords: 5),
    LevelSelectorData(hour: 25, almostLearnedWords: 2),
    LevelSelectorData(hour: 40, almostLearnedWords: 1)
]
struct MarqueeItem: Identifiable {
    let id = UUID()
    let word: String
}
var elementaryExamples = [
    "society",
    "heart",
    "send",
    "early",
    "watch",
    "father",
    "like",
    "place",
    "something",
    "very",
    "people",
    "thing",
    "call",
    "student",
    "move",
    "happen",
    "next",
    "book",
    "important",
    "air"
]
var elementaryExamples2 = [
    "air",
    "important",
    "book",
    "next",
    "happen",
    "move",
    "student",
    "call",
    "thing",
    "people",
    "very",
    "something",
    "place",
    "like",
    "father",
    "watch",
    "early",
    "send",
    "heart",
    "society"
]
var beginnerExamples = [
    "mention",
    "fight",
    "peace",
    "imagine",
    "avoid",
    "trip",
    "owner",
    "victim",
    "responsibility",
    "suffer",
    "successful",
    "achieve",
    "improve",
    "future",
    "drive",
    "justice",
    "damage",
    "disappear",
    "fruit"
]
var beginnerExamples2 = [
    "society",
    "fruit",
    "disappear",
    "damage",
    "justice",
    "drive",
    "future",
    "improve",
    "achieve",
    "successful",
    "suffer",
    "responsibility",
    "victim",
    "owner",
    "trip",
    "avoid",
    "imagine",
    "peace",
    "fight",
    "mention"
]
var intermediateExamples = [
    "depart",
    "twin",
    "tolerance",
    "flood",
    "hike",
    "habit",
    "flash",
    "desire",
    "genuine",
    "consist",
    "violation",
    "possess",
    "craft",
    "innocent",
    "blind",
    "flat",
    "award",
    "whisper",
    "agenda",
    "launch"
]
var intermediateExamples2 = [
    "launch",
    "agenda",
    "whisper",
    "award",
    "flat",
    "blind",
    "innocent",
    "craft",
    "possess",
    "violation",
    "consist",
    "genuine",
    "desire",
    "flash",
    "habit",
    "hike",
    "flood",
    "tolerance",
    "twin",
    "depart"
]
var advancedExamples = [
    "spine",
    "pea",
    "roar",
    "erupt",
    "lean",
    "precede",
    "fulfil",
    "thrill",
    "jerk",
    "decisive",
    "sleek",
    "obesity",
    "dusk",
    "contaminate",
    "sewer",
    "bypass",
    "damp",
    "lizard",
    "fasten",
    "slate",
]
var advancedExamples2 = [
    "slate",
    "fasten",
    "lizard",
    "damp",
    "bypass",
    "sewer",
    "contaminate",
    "dusk",
    "obesity",
    "sleek",
    "decisive",
    "jerk",
    "thrill",
    "fulfil",
    "precede",
    "lean",
    "erupt",
    "roar",
    "pea",
    "spine",
]
var nativelikeExamples = [
    "anticipated",
    "bunk",
    "misconduct",
    "fern",
    "dread",
    "redeem",
    "extinct",
    "ascend",
    "traverse",
    "devoid",
    "straddle",
    "vineyard",
    "thump",
    "whim",
    "sluggish",
    "zeal",
    "slug",
    "cradle",
    "hideous",
    "shrewd"
]
var nativelikeExamples2 = [
    "shrewd",
    "hideous",
    "cradle",
    "slug",
    "zeal",
    "sluggish",
    "whim",
    "thump",
    "vineyard",
    "straddle",
    "devoid",
    "traverse",
    "ascend",
    "extinct",
    "redeem",
    "dread",
    "fern",
    "misconduct",
    "bunk",
    "anticipated"
]
var shakespeareExamples = [
    "skid",
    "spatula",
    "spooky",
    "intractable",
    "maize",
    "privy",
    "flask",
    "peck",
    "courteous",
    "crackle",
    "lopsided",
    "twinge",
    "vagaries",
    "trifle",
    "grub",
    "strut",
    "gawk",
    "cog",
    "belch",
    "dowry"
]
var shakespeareExamples2 = [
    "dowry",
    "belch",
    "cog",
    "gawk",
    "strut",
    "grub",
    "trifle",
    "vagaries",
    "twinge",
    "lopsided",
    "crackle",
    "courteous",
    "peck",
    "flask",
    "privy",
    "maize",
    "intractable",
    "spooky",
    "spatula",
    "skid"
]
struct LevelSwitcherSheet: View {
    @AppStorage("levelSwitchSheetLevelSelected_key") var levelSwitchSheetLevelSelected = 1
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("levelSwitchSheetShown_key") var levelSwitchSheetShown: Bool = false
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    // Тут код для графика
    @State var level_selector_Data: [LevelSelectorData] = level_selector_data
    @State private var animationAmount = 1.0
    @State private var isAnimating: Bool = false
    @State var opacity1: Double = 0
    @State var opacity2: Double = 0
    @State var opacity3: Double = 0
    @State var opacity4: Double = 0
    @State var opacity5: Double = 0
    @State var opacity6: Double = 0
    @State private var currentOffset: CGFloat = 0
    @State private var timer: Timer?
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("basicOnboardingPassed_key") private var basicOnboardingPassed: Bool = false
    // Отдельно переменная, откуда из предыдущего экрана передаётся выбранный код языка. Из неё берётся этот код и подставляется в languageCodeForUse по onAppear данного вью:
    var languageCodePassed: String
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = ""
    var isShortVersion: Bool
    // Настройки градиента графика для Elementary
    let chartGradientAreaElementary = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.00),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.35),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.7),
        ],
        startPoint: .top,
        endPoint: .bottom
        )
    let chartGradientLineElementary = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.000),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.0125),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.0250),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    // Настройки градиента графика для Beginner
    let chartGradientAreaBeginner = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.35),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.55),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.9),
        ],
        startPoint: .top,
        endPoint: .bottom
        )
    let chartGradientLineBeginner = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.0250),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.0625),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.0999),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    // Настройки градиента графика для Intermediate
    let chartGradientAreaIntermediate = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.1000),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.1750),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.2500),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    let chartGradientLineIntermediate = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.1000),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.1750),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.2500),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    // Настройки градиента графика для Advanced
    let chartGradientAreaAdvanced = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.2500),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.3450),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.4250),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    let chartGradientLineAdvanced = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.2500),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.3450),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.4250),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    // Настройки градиента графика для Nativelike
    let chartGradientAreaNativelike = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.4250),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.5250),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.6250),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    let chartGradientLineNativelike = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.4250),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.5250),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.6250),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    // Настройки градиента графика для Shakespeare
    let chartGradientAreaShakespeare = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.6250),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.24), location: 0.8215),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.01), location: 0.1),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    let chartGradientLineShakespeare = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.157, green: 0.098, blue: 0.016).opacity(1), location: 0.6250),
            Gradient.Stop(color: Color(red: 1, green: 0.569, blue: 0).opacity(1), location: 0.8125),
            Gradient.Stop(color: Color(red: 0.161, green: 0.125, blue: 0.075).opacity(1), location: 0.1),
        ],
        startPoint: .leading,
        endPoint: .trailing
        )
    // Конец кода для графика
    @State var feedbackColor: Color = Color.clear
    var body: some View {
        NavigationStack{
            VStack {
                ZStack(alignment: .top) {
                    P171_CircleAnimation(feedbackColor: feedbackColor)
                        .blendMode(.screen)
                        .blur(radius: 28)
                        .offset(y: -400)
                        .opacity(0.4)
                    VStack{
                    }
                    VStack{
                        // Заголовок и подзаголовок
                        VStack(alignment: .leading){
                            Spacer()
                                .frame(height:43)
                            Text("Select Target Level")
                                .font(.system(size: 32))
                                .fontWeight(.bold)
                                .foregroundStyle(Color("MainFontColor"))
                            Spacer()
                                .frame(height:8)
                            if isShortVersion == false {
                                Text("Swipe left or right to pick the one that suits your needs the most.")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color("MainFontColor"))
                                Spacer()
                                    .frame(height:12)
                            }
                            Spacer()
                                .frame(height:12)
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.top, 0)
                        .padding(.leading, 20)
                        .padding(.trailing, 16)
                        // Бегущая строка
                        switch levelSwitchSheetLevelSelected {
                        case 1:
                            SimpleMarquee(words: elementaryExamples, speed: 90, movementDirection: "left")
                                .opacity(opacity1)
                            SimpleMarquee(words: elementaryExamples2, speed: 70, movementDirection: "left")
                                .opacity(opacity1)
                        case 2:
                            SimpleMarquee(words: beginnerExamples, speed: 90, movementDirection: "left")
                                .opacity(opacity2)
                            SimpleMarquee(words: beginnerExamples2, speed: 70, movementDirection: "left")
                                .opacity(opacity2)
                        case 3:
                            SimpleMarquee(words: intermediateExamples, speed: 90, movementDirection: "left")
                                .opacity(opacity3)
                            SimpleMarquee(words: intermediateExamples2, speed: 70, movementDirection: "left")
                                .opacity(opacity3)
                        case 4:
                            SimpleMarquee(words: advancedExamples, speed: 90, movementDirection: "left")
                                .opacity(opacity4)
                            SimpleMarquee(words: advancedExamples2, speed: 70, movementDirection: "left")
                                .opacity(opacity4)
                        case 5:
                            SimpleMarquee(words: nativelikeExamples, speed: 90, movementDirection: "left")
                                .opacity(opacity5)
                            SimpleMarquee(words: nativelikeExamples2, speed: 70, movementDirection: "left")
                                .opacity(opacity5)
                        case 6:
                            SimpleMarquee(words: shakespeareExamples, speed: 90, movementDirection: "left")
                                .opacity(opacity6)
                            SimpleMarquee(words: shakespeareExamples2, speed: 70, movementDirection: "left")
                                .opacity(opacity6)
                        default:
                            SimpleMarquee(words: elementaryExamples, speed: 90, movementDirection: "left")
                                .opacity(opacity1)
                            SimpleMarquee(words: elementaryExamples2, speed: 70, movementDirection: "left")
                                .opacity(opacity1)
                        }
                        Spacer()
                            .frame(height: 22)
                        // Код графика
                        VStack{
                            HStack {
                                VStack{
                                    Text("Frequency")
                                        .rotationEffect(Angle(degrees: 270))
                                        .font(.system(size: 12))
                                        .frame(width: 60)
                                        .offset(x: -4)
                                        .foregroundStyle(Color("secondaryFontColor"))
                                }
                                VStack {
                                    // Отсюда начинается область отображения графика, со всеми присущими ей слоями
                                    ZStack(alignment: .top) {
                                        // Фоновые линии-разделители
                                        Divider()
                                            .overlay(Color("secondaryCardColor"))
                                        Divider()
                                            .overlay(Color("secondaryCardColor"))
                                            .offset(y: 51)
                                        Divider()
                                            .overlay(Color("secondaryCardColor"))
                                            .offset(y: 102)
                                        Divider()
                                            .overlay(Color("secondaryCardColor"))
                                            .offset(y: 153)
                                        // Первый чарт (Elementary)
                                        VStack{
                                            Chart {
                                                ForEach(level_selector_Data) { item in
                                                    AreaMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientAreaElementary)
                                                    .interpolationMethod(.catmullRom)
                                                    LineMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientLineElementary)
                                                    .interpolationMethod(.catmullRom)
                                                    .shadow(radius: 2, x: 0, y: 2)
                                                }
                                            }
                                            .chartXAxis(.hidden)
                                            .chartYAxis(.hidden)
                                            .frame(height: 153)
                                            .frame(width: 338)
                                            .onAppear {
                                                animateGraph()
                                            }
                                        }
                                        .opacity(opacity1)
                                        // Второй чарт (Beginner)
                                        VStack{
                                            Chart {
                                                ForEach(level_selector_Data) { item in
                                                    AreaMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientAreaBeginner)
                                                    .interpolationMethod(.catmullRom)
                                                    LineMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientLineBeginner)
                                                    .interpolationMethod(.catmullRom)
                                                    .shadow(radius: 2, x: 0, y: 2)
                                                }
                                            }
                                            .chartXAxis(.hidden)
                                            .chartYAxis(.hidden)
                                            .frame(height: 153)
                                            .frame(width: 338)
                                            .onAppear {
                                                animateGraph()
                                            }
                                        }
                                        .opacity(opacity2)
                                        // Третий чарт (Intermediate)
                                        VStack{
                                            Chart {
                                                ForEach(level_selector_Data) { item in
                                                    AreaMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientAreaIntermediate)
                                                    .interpolationMethod(.catmullRom)
                                                    LineMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientLineIntermediate)
                                                    .interpolationMethod(.catmullRom)
                                                    .shadow(radius: 2, x: 0, y: 2)
                                                }
                                            }
                                            .chartXAxis(.hidden)
                                            .chartYAxis(.hidden)
                                            .frame(height: 153)
                                            .frame(width: 338)
                                            .onAppear {
                                                animateGraph()
                                            }
                                        }
                                        .opacity(opacity3)
                                        // Четвёртый чарт (Advanced)
                                        VStack{
                                            Chart {
                                                ForEach(level_selector_Data) { item in
                                                    AreaMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientAreaAdvanced)
                                                    .interpolationMethod(.catmullRom)
                                                    LineMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientLineAdvanced)
                                                    .interpolationMethod(.catmullRom)
                                                    .shadow(radius: 2, x: 0, y: 2)
                                                }
                                            }
                                            .chartXAxis(.hidden)
                                            .chartYAxis(.hidden)
                                            .frame(height: 153)
                                            .frame(width: 338)
                                            .onAppear {
                                                animateGraph()
                                            }
                                        }
                                        .opacity(opacity4)
                                        // Пятый чарт (Nativelike)
                                        VStack{
                                            Chart {
                                                ForEach(level_selector_Data) { item in
                                                    AreaMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientAreaNativelike)
                                                    .interpolationMethod(.catmullRom)
                                                    LineMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientLineNativelike)
                                                    .interpolationMethod(.catmullRom)
                                                    .shadow(radius: 2, x: 0, y: 2)
                                                }
                                            }
                                            .chartXAxis(.hidden)
                                            .chartYAxis(.hidden)
                                            .frame(height: 153)
                                            .frame(width: 338)
                                            .onAppear {
                                                animateGraph()
                                            }
                                        }
                                        .opacity(opacity5)
                                        // Шестой чарт (Shakespeare)
                                        VStack{
                                            Chart {
                                                ForEach(level_selector_Data) { item in
                                                    AreaMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientAreaShakespeare)
                                                    .interpolationMethod(.catmullRom)
                                                    LineMark(
                                                        x: .value("frequency", item.hour),
                                                        y: .value("data", item.animate ? item.almostLearnedWords : 0)
                                                    )
                                                    .foregroundStyle(chartGradientLineShakespeare)
                                                    .interpolationMethod(.catmullRom)
                                                    .shadow(radius: 2, x: 0, y: 2)
                                                }
                                            }
                                            .chartXAxis(.hidden)
                                            .chartYAxis(.hidden)
                                            .frame(height: 153)
                                            .frame(width: 338)
                                            .onAppear {
                                                animateGraph()
                                            }
                                        }
                                        .opacity(opacity6)
                                    }
                                    .offset(x: -26)
                                }
                            }
                        }
                        // Тут заканчивается область Z-Stack со слоями
                        VStack{
                            Text("Word Ranking")
                                .font(.system(size: 12))
                                .foregroundStyle(Color("secondaryFontColor"))
                                .offset(y: 7)
                        }
                        Spacer()
                            .frame(height:32)
                        TabView(selection: $levelSwitchSheetLevelSelected){
                            VStack{
                                VStack{
                                    Image("levelicons_elementary")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Elementary")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("First 500 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Absolute basics. Not enough to start speaking.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(1)
                            VStack{
                                VStack{
                                    Image("levelicons_beginner")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Beginner")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 501 - 2 000 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Enough to be able to express 80 % of your ideas.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(2)
                            VStack{
                                VStack{
                                    Image("levelicons_intermediate")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Intermediate")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 2 001 - 5 000 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Enough to work in an English-speaking country")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(3)
                            VStack{
                                VStack{
                                    Image("levelicons_advanced")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Advanced")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 5 001 - 8 500 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Enough to make an excellent impression on a date.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(4)
                            VStack{
                                VStack{
                                    Image("levelicons_nativelike")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Native-like")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 8 501 - 12 500 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Enough to communicate up to 99 % of your ideas.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(5)
                            VStack{
                                VStack{
                                    ZStack {}
                                        .frame(width: 42, height: 42)
                                        .background(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.76, green: 0.99, blue: 0.96), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 0.71, green: 0.97, blue: 0.9), location: 0.60),
                                                    Gradient.Stop(color: Color(red: 0.57, green: 0.92, blue: 0.78), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0.5, y: 0),
                                                endPoint: UnitPoint(x: 0.5, y: 1)
                                            )
                                        )
                                        .cornerRadius(60)
                                        .shadow(color: .black.opacity(0.11), radius: 21.86598, x: 9.71821, y: 9.71821)
                                        .shadow(color: .black.opacity(0.09), radius: 8.50344, x: 4.85911, y: 4.85911)
                                        .shadow(color: Color(red: 0.58, green: 0.89, blue: 0.76).opacity(0.5), radius: 11, x: 0, y: 0)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Shakespeare")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 12 501 - 20 000 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Words that aren't really useful in conversations.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(6)
                        }
                        .frame(height: 150)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                        Spacer()
                            .frame(height:32)
                        VStack{
                            switch levelSwitchSheetLevelSelected {
                            case 1:
                                Button(
                                    action: {
                                        switchToLevel(level: "elementary")
                                        //                        currentLevelSelected = "elementary"
                                        //                        levelSwitchSheetShown = false
                                        basicOnboardingPassed = true
                                        presentationMode.wrappedValue.dismiss()
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

                            case 2:
                                Button(
                                    action: {
                                        switchToLevel(level: "beginner")
                                        //                        currentLevelSelected = "beginner"
                                        //                        levelSwitchSheetShown = false
                                        basicOnboardingPassed = true
                                        presentationMode.wrappedValue.dismiss()
                                    },
                                    label: {
                                        Text("Choose Beginner")
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
                                        switchToLevel(level: "intermediate")
                                        //                            currentLevelSelected = "intermediate"
                                        //                            levelSwitchSheetShown = false
                                        basicOnboardingPassed = true
                                        presentationMode.wrappedValue.dismiss()
                                    },
                                    label: {
                                        Text("Choose Intermediate")
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
                                        //                        currentLevelSelected = "advanced"
                                        basicOnboardingPassed = true
                                        presentationMode.wrappedValue.dismiss()
                                    },
                                    label: {
                                        Text("Choose Advanced")
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
                                        //                        currentLevelSelected = "nativelike"
                                        basicOnboardingPassed = true
                                        presentationMode.wrappedValue.dismiss()
                                    },
                                    label: {
                                        Text("Choose Native-like")
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
                                        //                        currentLevelSelected = "borninengland"
                                        basicOnboardingPassed = true
                                        presentationMode.wrappedValue.dismiss()
                                    },
                                    label: {
                                        Text("Choose Shakespeare")
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
                                        switchToLevel(level: "elementary")
                                        // currentLevelSelected = "elementary"
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
                            }
                        }
                        Spacer()
                            .frame(height:24)
                        VStack{
                            HStack{
                                // Отдельно по кружочку для каждого слайда
                                Spacer()
                                    .frame(width:12, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 1 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 2 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 3 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 4 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 5 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 6 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                    
                                }
                                Spacer()
                                    .frame(width:12, height: 24)
                            }
                            .background(Color("Surface-component-parts"))
                            .cornerRadius(140)
                        }
                        Spacer()
                    }
                    .onAppear {
                        switch levelSwitchSheetLevelSelected {
                        case 1:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 1
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 2:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 1
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 3:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 1
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 4:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 1
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 5:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 1
                                opacity6 = 0
                            }
                        case 6:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 1
                            }
                        default:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 1
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        }
                    }
                    .onChange(of:levelSwitchSheetLevelSelected) {
                        switch levelSwitchSheetLevelSelected {
                        case 1:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 1
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 2:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 1
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 3:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 1
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 4:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 1
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 5:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 1
                                opacity6 = 0
                            }
                        case 6:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 1
                            }
                        default:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 1
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        }
                    }
                }
                .background(Color("sheetColor"))
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                languageCodeForUse = languageCodePassed
            }
        }
    }
    private func switchToLevel(level: String) {
            if currentLearningMode != "discovery" {
                currentLearningMode = "discovery"
            }
            currentLevelSelected = level
            levelSwitchSheetShown = false
    }
    func resetAnimation() {
            // Reset animation logic
            for (index, _) in level_selector_Data.enumerated() {
                level_selector_Data[index].animate = false
            }
            animateGraph(fromChange: true)
        }
    
    func animateGraph(fromChange: Bool = false) {
        for (index,_) in level_selector_Data.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    level_selector_Data[index].animate = true
                }
            }
        }
    }
}
struct SimpleMarquee: View {
    @State private var offset: CGFloat = 0
    @State private var animate: Bool = false

    let words: [String]
    let speed: Double
    let movementDirection: String
    
    var body: some View {
            GeometryReader { geometry in
                let wordWidth = geometry.size.width / CGFloat(words.count)
                let totalWidth = wordWidth * CGFloat(words.count) + CGFloat(words.count - 1) * 60
                var firstAnimationArgument: CGFloat {
                    switch movementDirection {
                    case "left":
                        return -totalWidth
                    case "right":
                        return 0
                    default:
                        return -totalWidth
                    }
                }
                var secondAnimationArgument: CGFloat {
                    switch movementDirection {
                    case "left":
                        return 0
                    case "right":
                        return -totalWidth
                    default:
                        return 0
                    }
                }
                HStack(spacing: 17) {
                    ForEach(0..<2, id: \.self) { _ in
                        ForEach(words, id: \.self) { word in
                            ZStack {
                                RoundedRectangle(cornerRadius: 40)
                                    .foregroundColor(Color("surface"))
                                    .frame(height: 37)
                                Text(word)
                                    .fixedSize()
                                    .foregroundColor(Color("secondaryFontColor"))
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(top: 1, leading: 16, bottom: 1, trailing: 16))
                            }
                        }
                    }
                }
                .offset(
                    x: animate ? firstAnimationArgument : secondAnimationArgument
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: true)) {
                        animate.toggle()
                    }
                }
            }
            .frame(height: 40)
            .clipped()
    }
}

struct LevelSwitcherSheet_Preview: PreviewProvider {
    static var previews: some View {
        LevelSwitcherSheet(languageCodePassed: "ukranian", isShortVersion: false)
            .environmentObject(storedNewWordItems())
            .environmentObject(ActivityCalendar())
    }
}
