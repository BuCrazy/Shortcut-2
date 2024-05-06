import SwiftUI

struct SwiperSection: View {
    
    @AppStorage("wordsPerDiscoverySetting_key") var wordsPerDiscoverySetting: Int = 30
    @AppStorage("wordsPerRevisionSetting_key") var wordsPerRevisionSetting: Int = 30
    
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
    
    @AppStorage("wordsDiscoveredDuringTheCurrentDiscoverySession_key") var wordsDiscoveredDuringTheCurrentDiscoverySession: Int = 0
    @AppStorage("wordsDiscoveredDuringTheCurrentRevisionSession_key") var wordsDiscoveredDuringTheCurrentRevisionSession: Int = 0
    
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"

    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = ""
    
    // NOTE: Variables for storing swiping data for current week
    @AppStorage("weeklySwipeCount") var weeklySwipeCount: Int = 0
    @AppStorage("lastRecordedWeek") var lastRecordedWeek: String = ""

    @Binding var discoveryWordsStorageToWorkOn: [WordItemStruct]
    @Binding var topWords: [NewWordItem]
    @Binding var bottomWords: [NewWordItem]
    
    @State var feedbackColor: Color = Color.clear
    
    var body: some View {
        
        let displayedWords = Array(discoveryWordsStorageToWorkOn.prefix(2)).reversed()
        
        return ZStack {
            
            Color("BackgroundColor").ignoresSafeArea()
            
            P171_CircleAnimation(feedbackColor: feedbackColor)
                .blendMode(.screen)
                .blur(radius: 28)
            
            ForEach(Array(displayedWords), id: \.id) { (word: WordItemStruct) in
                
                let isFirst = discoveryWordsStorageToWorkOn.first?.id == word.id
                
                // Внутри этого цикла создаём переменную, которая всегда подгружает в себя слово из исходной базы, которое соответствует текущему слову в зависимости от уровня по параметру position_now. Из неё потом будем брать перевод слова в зависимости от выбранного языка:
                
                var currentCardWordObject: WordItemStruct? {
                    
                    switch currentLevelSelected {
                        case "elementary":
                            return elementaryWordsStorageSource.first(where: { $0.position_now == word.position_now })
                        case "beginner":
                            return beginnerWordsStorageSource.first(where: { $0.position_now == word.position_now })
                        case "intermediate":
                            return intermediateWordsStorageSource.first(where: { $0.position_now == word.position_now })
                        default:
                            return elementaryWordsStorageSource.first(where: { $0.position_now == word.position_now })
                    }
                    
                }
                
                // И теперь уже из переменной currentCardWordObject вытаскиваем перевод для отображения карточки в зависимости от выбранного языка, делая его доступным сomputed variable "currentCardTranslation":
                
                var currentCardTranslation: String {
                    switch languageCodeForUse {
                        case "ukranian": return currentCardWordObject?.ukranian ?? ""
                        case "russian": return currentCardWordObject?.russian ?? ""
                        case "bulgarian": return currentCardWordObject?.bulgarian ?? ""
                        case "chinese": return currentCardWordObject?.chinese ?? ""
                        case "czech": return currentCardWordObject?.czech ?? ""
                        case "danish": return currentCardWordObject?.danish ?? ""
                        case "dutch": return currentCardWordObject?.dutch ?? ""
                        case "estonian": return currentCardWordObject?.estonian ?? ""
                        case "finnish": return currentCardWordObject?.finnish ?? ""
                        case "french": return currentCardWordObject?.french ?? ""
                        case "german": return currentCardWordObject?.german ?? ""
                        case "greek": return currentCardWordObject?.greek ?? ""
                        case "hungarian": return currentCardWordObject?.hungarian ?? ""
                        case "indonesian": return currentCardWordObject?.indonesian ?? ""
                        case "italian": return currentCardWordObject?.italian ?? ""
                        case "japanese": return currentCardWordObject?.japanese ?? ""
                        case "korean": return currentCardWordObject?.korean ?? ""
                        case "latvian": return currentCardWordObject?.latvian ?? ""
                        case "lithuanian": return currentCardWordObject?.lithuanian ?? ""
                        case "norwegian": return currentCardWordObject?.norwegian ?? ""
                        case "polish": return currentCardWordObject?.polish ?? ""
                        case "portuguese": return currentCardWordObject?.portuguese ?? ""
                        case "romanian": return currentCardWordObject?.romanian ?? ""
                        case "slovak": return currentCardWordObject?.slovak ?? ""
                        case "slovenian": return currentCardWordObject?.slovenian ?? ""
                        case "spanish": return currentCardWordObject?.spanish ?? ""
                        case "swedish": return currentCardWordObject?.swedish ?? ""
                        case "turkish": return currentCardWordObject?.turkish ?? ""
                        default: return currentCardWordObject?.ukranian ?? ""
                    }
                }
                
                VerticalCard(
                    word: word.word,
                    flippedWord: currentCardTranslation,
                    phonetics: word.phonetics,
                    cardColor: isFirst ? .black : Color("secondaryCardColor"),
                    onRemove: {
                        withAnimation {
                            discoveryWordsStorageToWorkOn.removeAll(where: { $0.id == word.id })
                            switch currentLevelSelected {
                            case "elementary":
                                storedNewWordItemsDataLayer.elementaryWordsStorage.removeAll(where: { $0.id == word.id })
                            case "beginner":
                                storedNewWordItemsDataLayer.beginnerWordsStorage.removeAll(where: { $0.id == word.id })
                            case "intermediate":
                                storedNewWordItemsDataLayer.intermediateWordsStorage.removeAll(where: { $0.id == word.id })
                            case "advanced":
                                storedNewWordItemsDataLayer.advancedWordsStorage.removeAll(where: { $0.id == word.id })
                            case "nativelike":
                                storedNewWordItemsDataLayer.nativelikeWordsStorage.removeAll(where: { $0.id == word.id })
                            case "borninengland":
                                storedNewWordItemsDataLayer.borninenglandWordsStorage.removeAll(where: { $0.id == word.id })
                            default:
                                print("Default...")
                            }
                        }
                    }, onSwipe: { direction in
                        handleSwipe(direction: direction, word: word)
                    }
                )
                .offset(y: isFirst ? 24 : 0)
                .shadow(radius: isFirst ? 4 : 0)
                .scaleEffect(isFirst ? 1 : 0.95)
                .allowsHitTesting(isFirst)
                
            }
            
        }
        .frame(height: 300)

    }
    
    func handleSwipe(direction: Direction, word: WordItemStruct) {
        
            let newItem = NewWordItem(
                id: word.id,
                position_now: word.position_now,
                pos: word.pos,
                word: word.word,
                phonetics: word.phonetics,
                definition: word.definition,
                collocations: word.collocations,
                sentence: word.sentence,
                video: word.video,
                movie: word.movie,
                movie_quote:   word.movie_quote,
                dateAdded: Date(),
                timesReviewed: 1,
                grade: 1,
                ukranian: word.ukranian,
                russian: word.russian,
                bulgarian: word.bulgarian,
                chinese: word.chinese,
                czech: word.czech,
                danish: word.danish,
                dutch: word.dutch,
                estonian: word.estonian,
                finnish: word.finnish,
                french: word.french,
                german: word.german,
                greek: word.greek,
                hungarian: word.hungarian,
                indonesian: word.indonesian,
                italian: word.italian,
                japanese: word.japanese,
                korean: word.korean,
                latvian:   word.latvian,
                lithuanian: word.lithuanian,
                norwegian: word.norwegian,
                polish: word.polish,
                portuguese: word.portuguese,
                romanian: word.romanian,
                slovak: word.slovak,
                slovenian: word.slovenian,
                spanish: word.spanish,
                swedish: word.swedish,
                turkish: word.turkish
            )
        
        print("New item added with date: \(newItem.dateAdded)")
        withAnimation {
            if direction == .up {
                
                topWords.insert(newItem, at: 0)
                wordsDiscoveredDuringTheCurrentDiscoverySession += 1
                activityLogDataLayer.logEachAction()
                try! activityLogDataLayer.saveDataToJSON()
                
                switch currentLevelSelected {
                    case "elementary":
                    storedNewWordItemsDataLayer.elementaryKnewAlready.insert(
                        wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0.0
                        )
                        , at: 0
                    )
                    case "beginner":
                    storedNewWordItemsDataLayer.beginnerKnewAlready.insert(
                        wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0.0
                        )
                        , at: 0
                    )
                    case "intermediate":
                    storedNewWordItemsDataLayer.intermediateKnewAlready.insert(
                        wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0.0
                        )
                        , at: 0
                    )
                    case "advanced":
                    storedNewWordItemsDataLayer.advancedKnewAlready.insert(
                        wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0.0
                        )
                        , at: 0
                    )
                    case "nativelike":
                    storedNewWordItemsDataLayer.nativelikeKnewAlready.insert(
                        wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0.0
                        )
                        , at: 0
                    )
                    case "borninengland":
                    storedNewWordItemsDataLayer.nativelikeKnewAlready.insert(
                        wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0.0
                        )
                        , at: 0
                    )
                    default:
                        print("Nothing added nowhere")
                }
                
                if wordsDiscoveredDuringTheCurrentDiscoverySession >= wordsPerDiscoverySetting {
                    currentLearningMode = "revision"
                    wordsDiscoveredDuringTheCurrentDiscoverySession = 0
                }
            } else if direction == .down {
                bottomWords.insert(newItem, at: 0)
                wordsDiscoveredDuringTheCurrentDiscoverySession += 1
                activityLogDataLayer.logEachAction()
                try! activityLogDataLayer.saveDataToJSON()
                
                let wordToAdd = wordItemNew(
                        id: newItem.id,
                        position_now: newItem.position_now,
                        word: newItem.word,
                        dateAdded: storedStatesDataLayer.currentDate,
                        timesReviewed: 1,
                        consecutiveCorrectRecalls: 0,
                        progress: 0.0
                    )
                
                switch currentLevelSelected {
                    case "elementary":
                        storedNewWordItemsDataLayer.elementaryBeingLearned.insert(wordToAdd, at: 0)
                  //  print("Added to elementaryBeingLearned: \(wordToAdd)")
                    case "beginner":
                        storedNewWordItemsDataLayer.beginnerBeingLearned.insert(wordToAdd, at: 0)
                //    print("Added to beginnerBeingLearned: \(wordToAdd)")
                    case "intermediate":
                        storedNewWordItemsDataLayer.intermediateBeingLearned.insert(wordToAdd, at: 0)
               
               //     print("Added to intermediateBeingLearned: \(wordToAdd)")
                    print("intermediateBeingLearned contents: \( storedNewWordItemsDataLayer.intermediateBeingLearned)")
                    case "advanced":
                        storedNewWordItemsDataLayer.advancedBeingLearned.insert(wordToAdd, at: 0)
                //    print("Added to advancedBeingLearned: \(wordToAdd)")
                    case "nativelike":
                        storedNewWordItemsDataLayer.nativelikeBeingLearned.insert(wordToAdd, at: 0)
                //    print("Added to nativelikeBeingLearned: \(wordToAdd)")
                    case "borninengland":
                        storedNewWordItemsDataLayer.borninenglandBeingLearned.insert(wordToAdd, at: 0)
                //    print("Added to borninenglandBeingLearned: \(wordToAdd)")
                    default:
                        print("Nothing added anywhere")
                    
                }
                
                if wordsDiscoveredDuringTheCurrentDiscoverySession >= wordsPerDiscoverySetting {
                    currentLearningMode = "revision"
                    wordsDiscoveredDuringTheCurrentDiscoverySession = 0
                }
            }
        }
        
        updateWeeklySwipeCounter()
        
    } // NOTE: handleSwipe over
    
    func updateWeeklySwipeCounter() {
        let currentWeek = getCurrentWeek()
        if lastRecordedWeek != currentWeek {
            weeklySwipeCount = 0
            lastRecordedWeek = currentWeek
        }
        weeklySwipeCount += 1
    }
    
    
    //NOTE: Getting current Week
    func getCurrentWeek() -> String {
        let dateFormetter = DateFormatter()
        dateFormetter.dateFormat = "yyyy-WW" // NOTE: year and week number
        return dateFormetter.string(from: Date())
    }
}



struct SwiperSection_Previews: PreviewProvider {
    
    @State static var wordItem = [WordItemStruct(
    
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
        
    )]

    @State static var topWords = [NewWordItem]()
    @State static var bottomWords = [NewWordItem]()
    static var previews: some View {
        SwiperSection(discoveryWordsStorageToWorkOn: $wordItem, topWords: $topWords, bottomWords: $bottomWords)
            .environmentObject(ActivityCalendar())
            .environmentObject(storedNewWordItems())
            .environmentObject(storedStates())
    }
}


