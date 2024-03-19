import SwiftUI

struct SwiperView: View {
    
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
    
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = "ENUK_transl"
    
    @State private var topWords: [NewWordItem] = []
    @State private var bottomWords: [NewWordItem] = []
    @State private var know = false
    @State private var selectedWordItem: NewWordItem?
    @State var discoveryWordsStorageToWorkOn: [WordItemStruct] = []
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .leading) {
                    
                    //KNOW SECTION
                    KnowSectionLabel()
                    
                    if topWords.isEmpty {
                        TopEmptyView()
                    } else {
                        KnowSection(
                            topWords: $topWords,
                            bottomWords: $bottomWords,
                            selectedWordItem: $selectedWordItem
                        )
                        .environmentObject(storedStates())
                    }
                    
                    Spacer()
                    
                    // SWIPER
                    SwiperSection(
                        discoveryWordsStorageToWorkOn: $discoveryWordsStorageToWorkOn,
                        topWords: $topWords,
                        bottomWords: $bottomWords
                    )
                    .environmentObject(storedStates())
                    
                    Spacer()
                    
                    // DONT'T KNOW SECTION
                    DontKnowSectionLabel()
                    
                    if bottomWords.isEmpty {
                        BottomEmptyView()
                    } else {
                        Don_tKnowSection(
                            topWords: $topWords,
                            bottomWords: $bottomWords,
                            selectedWordItem: $selectedWordItem
                        )
                        .environmentObject(storedStates())
                    }
                    
                    Spacer()
                    
                }
                .background(Color("BackgroundColor").ignoresSafeArea())
                .navigationTitle(Text ("Discovery")).navigationBarBackButtonHidden(false)
                .sheet(item: $selectedWordItem) { slovo in
                    AnnotationView(
                        id: slovo.id,
                        position_now: slovo.position_now,
                        pos: slovo.pos,
                        word: slovo.word,
                        phonetics: slovo.phonetics,
                        definition: slovo.definition,
                        collocations: slovo.collocations,
                        sentence: slovo.sentence,
                        video: slovo.video,
                        movie: slovo.movie,
                        movie_quote: slovo.movie_quote,
                        dateAdded: Date(),
                        timesReviewed: 1,
                        grade: 1,
                        ukranian: slovo.ukranian,
                        russian: slovo.russian,
                        bulgarian: slovo.bulgarian,
                        chinese: slovo.chinese,
                        czech: slovo.czech,
                        danish: slovo.danish,
                        dutch: slovo.dutch,
                        estonian: slovo.estonian,
                        finnish: slovo.finnish,
                        french: slovo.french,
                        german: slovo.german,
                        greek: slovo.greek,
                        hungarian: slovo.hungarian,
                        indonesian: slovo.indonesian,
                        italian: slovo.italian,
                        japanese: slovo.japanese,
                        korean: slovo.korean,
                        latvian: slovo.latvian,
                        lithuanian: slovo.lithuanian,
                        norwegian: slovo.norwegian,
                        polish: slovo.polish,
                        portuguese: slovo.portuguese,
                        romanian: slovo.romanian,
                        slovak: slovo.slovak,
                        slovenian: slovo.slovenian,
                        spanish: slovo.spanish,
                        swedish: slovo.swedish,
                        turkish: slovo.turkish
                    )
                    .presentationDetents([.fraction(0.25), .medium, .large])
                }   
            }
        }
        .onAppear{
            switch currentLevelSelected {
            case "elementary":
                discoveryWordsStorageToWorkOn = storedNewWordItemsDataLayer.elementaryWordsStorage
            case "beginner":
                discoveryWordsStorageToWorkOn = storedNewWordItemsDataLayer.beginnerWordsStorage
            case "intermediate":
                discoveryWordsStorageToWorkOn = storedNewWordItemsDataLayer.intermediateWordsStorage
            default:
                discoveryWordsStorageToWorkOn = storedNewWordItemsDataLayer.elementaryWordsStorage
            }
        }
    }
    
}

struct SwiperView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let wordItem = WordItemStruct(
            
            id: 1,
            position_now: 1,
            pos: "pos",
            word: "word",
            phonetics: "phonetics",
            definition: "definition",
            collocations: "collocations",
            sentence: "sentence",
            video: "video",
            movie: "movie",
            movie_quote: "movie_quote",
            ukranian: "ukranian",
            russian: "russian",
            bulgarian: "bulgarian",
            chinese: "chinese",
            czech: "czech",
            danish: "danish",
            dutch: "dutch",
            estonian: "estonian",
            finnish: "finnish",
            french: "french",
            german: "german",
            greek: "greek",
            hungarian: "hungarian",
            indonesian: "indonesian",
            italian: "italian",
            japanese: "japanese",
            korean: "korean",
            latvian: "latvian",
            lithuanian: "lithuanian",
            norwegian: "norwegian",
            polish: "polish",
            portuguese: "portuguese",
            romanian: "romanian",
            slovak: "slovak",
            slovenian: "slovenian",
            spanish: "spanish",
            swedish: "swedish",
            turkish: "turkish"
            
        )
        
        return SwiperView(discoveryWordsStorageToWorkOn: [wordItem])
            .environmentObject(ActivityCalendar())
            .environmentObject(storedNewWordItems())
            .environmentObject(storedStates())
        
    }
}
