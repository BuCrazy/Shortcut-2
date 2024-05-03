import SwiftUI
import AVKit

struct DictionaryView: View {
    
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @State private var resetChartAnimation = false
    @State var consecutiveCorrectRecalls: Int
    @State var progress: Double

    
    @State private var animatedNumber: Int = 0
    @State private var chartData: [TotalWords] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        DictionaryHeaderView(resetChartAnimation: $resetChartAnimation, animatedNumber: $animatedNumber, chartData: $chartData)
                        switch currentLevelSelected {
                        case "elementary":
                            //NOTE: Don't delete this
//                            Text("Known words:")
//                            Spacer()
//                                .frame(height:10)
//                            ForEach(storedNewWordItemsDataLayer.elementaryKnewAlready) { word in
//                                Text("\(word.position), \(word.word)")
//                            }
//                            Spacer()
//                                .frame(height:10)
//                            Text("Unknown words:")
//                            Spacer()
//                                .frame(height:10)
                        ForEach(storedNewWordItemsDataLayer.elementaryBeingLearned) { word in
                            LexCardView(
                                consecutiveCorrectRecalls: $consecutiveCorrectRecalls,
                                progress: $progress,
                                word: word.word,
                                transcription: elementaryWordsStorageSource.first { $0.position_now == word.position_now }?.phonetics ?? "phonetics"
                            )
                            // Это потом удалить - сейчас оно для отладки экрана прогресса
                            .onTapGesture {
                                print("tapped!")
                                if let matchingItemIndex = storedNewWordItemsDataLayer.elementaryBeingLearned.firstIndex(where: { $0.position_now == word.position_now }) {
                                    var matchingItem = storedNewWordItemsDataLayer.elementaryBeingLearned[matchingItemIndex]
                                    matchingItem.consecutiveCorrectRecalls += 1
                                    matchingItem.timesReviewed += 1
                                    storedNewWordItemsDataLayer.elementaryBeingLearned[matchingItemIndex] = matchingItem
                                }
                            }
                        }
                        case "beginner":
                            ForEach(storedNewWordItemsDataLayer.beginnerBeingLearned) { word in
                                LexCardView(
                                    consecutiveCorrectRecalls: $consecutiveCorrectRecalls,
                                    progress: $progress,
                                    word: word.word,
                                    transcription: beginnerWordsStorageSource.first { $0.position_now == word.position_now }?.phonetics ?? "phonetics"
                                )
                                // Это потом удалить - сейчас оно для отладки экрана прогресса
                                .onTapGesture {
                                    print("tapped!")
                                    if let matchingItemIndex = storedNewWordItemsDataLayer.beginnerBeingLearned.firstIndex(where: { $0.position_now == word.position_now }) {
                                        var matchingItem = storedNewWordItemsDataLayer.beginnerBeingLearned[matchingItemIndex]
                                        matchingItem.consecutiveCorrectRecalls += 1
                                        matchingItem.timesReviewed += 1
                                        storedNewWordItemsDataLayer.beginnerBeingLearned[matchingItemIndex] = matchingItem
                                    }
                                }
                            }
                        case "intermediate":
                            ForEach(storedNewWordItemsDataLayer.intermediateBeingLearned) { word in
                                LexCardView(
                                    consecutiveCorrectRecalls: $consecutiveCorrectRecalls,
                                    progress: $progress,
                                    word: word.word,
                                    transcription: intermediateWordsStorageSource.first { $0.position_now == word.position_now }?.phonetics ?? "phonetics"
                                )
                                // Это потом удалить - сейчас оно для отладки экрана прогресса
                                .onTapGesture {
                                    print("tapped!")
                                    if let matchingItemIndex = storedNewWordItemsDataLayer.intermediateBeingLearned.firstIndex(where: { $0.position_now == word.position_now }) {
                                        var matchingItem = storedNewWordItemsDataLayer.intermediateBeingLearned[matchingItemIndex]
                                        matchingItem.consecutiveCorrectRecalls += 1
                                        matchingItem.timesReviewed += 1
                                        storedNewWordItemsDataLayer.intermediateBeingLearned[matchingItemIndex] = matchingItem
                                    }
                                }
                            }
                        default:
                            Text("No data to display")
                        }
                        
               
                    }
                }
                .navigationTitle(Text ("Dictionary")).navigationBarBackButtonHidden(false)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground( Color("mainCardBG"), for: .navigationBar)
            } // ZStack Ends
            .background(Color("dictionaryBGColor"))
            .onAppear {
               
                animatedNumber = storedNewWordItemsDataLayer.totalWordCount(for: currentLevelSelected)
                chartData = generateLast7DaysData(for: currentLevelSelected)
                print("ChartData in DictionaryView: \(chartData)")
            }
        }// NavigationStack Ends
        
    }
    func generateLast7DaysData(for level: String) -> [TotalWords] {
            var data: [TotalWords] = []
            let calendar = Calendar.current

            let wordsArray: [wordItemNew]
            switch level {
            case "elementary":
                wordsArray = storedNewWordItemsDataLayer.elementaryBeingLearned
            case "beginner":
                wordsArray = storedNewWordItemsDataLayer.beginnerBeingLearned
            case "intermediate":
                wordsArray = storedNewWordItemsDataLayer.intermediateBeingLearned
             //   print("Checking again \(storedNewWordItemsDataLayer.intermediateBeingLearned)")
            case "advanced":
                wordsArray = storedNewWordItemsDataLayer.advancedBeingLearned
            case "nativelike":
                wordsArray = storedNewWordItemsDataLayer.nativelikeBeingLearned
            case "borninengland":
                wordsArray = storedNewWordItemsDataLayer.borninenglandBeingLearned
            default:
                wordsArray = []
            }

            for i in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                    let wordsForDay = wordsArray.filter {
                        guard let dateAdded = $0.dateAdded.toDate() else { return false }
                        return calendar.isDate(dateAdded, inSameDayAs: date)
                    }
                    let wordCount = Double(wordsForDay.count)
                    data.append(TotalWords(day: date, wordsAdded: wordCount))
                }
            }
            return data.reversed()
        }
  
       
    
}

#Preview {
    DictionaryView(consecutiveCorrectRecalls: 5, progress: 0.5)
        .environmentObject(ActivityCalendar())
        .environmentObject(storedNewWordItems())
        .environmentObject(storedStates())
}
