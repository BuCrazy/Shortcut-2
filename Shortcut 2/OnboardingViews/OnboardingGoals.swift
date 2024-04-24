import SwiftUI
struct OnboardingGoals: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    var elementarySwipedWordsTotalCount: Int{
        return storedNewWordItemsDataLayer.elementaryBeingLearned.count + storedNewWordItemsDataLayer.elementaryKnewAlready.count
    }
    // Переменные, хранящие статусы выполнения целей онбординга
    @State var firstGoalIsCompleted = false
    @State var secondGoalIsCompleted = false
    @State var thirdGoalIsCompleted = false
    @State var fourthGoalIsCompleted = false
    @State var fifthGoalIsCompleted = false
    @State var firstGoalIsCurrent = false
    @State var secondGoalIsCurrent = false
    @State var thirdGoalIsCurrent = false
    @State var fourthGoalIsCurrent = false
    @State var fifthGoalIsCurrent = false
    // Настройка количества слов в квизе
    @AppStorage("wordsPerQuiz_key") var wordsPerQuiz: Int = 30
    @AppStorage("wordsPerDiscovery_key") var wordsPerDiscovery: Int = 100
    var firstGoalProgress: Double {
        if firstGoalIsCompleted != true {
            switch currentLevelSelected {
            case "elementary":
                return Double(storedNewWordItemsDataLayer.elementaryBeingLearned.count + storedNewWordItemsDataLayer.elementaryKnewAlready.count) / Double(wordsPerDiscovery)
            case "beginner":
                return Double(storedNewWordItemsDataLayer.beginnerBeingLearned.count + storedNewWordItemsDataLayer.beginnerKnewAlready.count) / Double(wordsPerDiscovery)
            case "intermediate":
                return Double(storedNewWordItemsDataLayer.intermediateBeingLearned.count + storedNewWordItemsDataLayer.intermediateKnewAlready.count) / Double(wordsPerDiscovery)
            default:
                return 0
            }
        } else {
            return 1
        }
    }
    var secondGoalProgress: Double {
        if secondGoalIsCompleted != true {
            switch currentLevelSelected {
            case "elementary":
                return Double(storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
                    item.timesReviewed >= 2
                }.count) / Double(wordsPerQuiz)
            case "beginner":
                return Double(storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
                    item.timesReviewed >= 2
                }.count) / Double(wordsPerQuiz)
            case "intermediate":
                return Double(storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
                    item.timesReviewed >= 2
                }.count) / Double(wordsPerQuiz)
            default:
                return 0
            }
        } else {
            return 1
        }
    }
    var thirdGoalProgress: Double {
        if thirdGoalIsCompleted != true && secondGoalIsCompleted == true {
            switch currentLevelSelected {
            case "elementary":
                return (Double(storedNewWordItemsDataLayer.elementaryBeingLearned.count) + Double(storedNewWordItemsDataLayer.elementaryKnewAlready.count)) / Double(elementaryWordsStorageSource.count)
            case "beginner":
                return (Double(storedNewWordItemsDataLayer.beginnerBeingLearned.count) + Double(storedNewWordItemsDataLayer.beginnerKnewAlready.count)) / Double(beginnerWordsStorageSource.count)
            case "intermediate":
                return (Double(storedNewWordItemsDataLayer.intermediateBeingLearned.count) + Double(storedNewWordItemsDataLayer.intermediateKnewAlready.count)) / Double(intermediateWordsStorageSource.count)
            default:
                return 0
            }
        } else if secondGoalIsCompleted == false {
            return 0
        } else {
            return 1
        }
    }
    var fourthGoalProgress: Double {
        if fourthGoalIsCompleted != true && thirdGoalIsCompleted == true {
            switch currentLevelSelected {
            case "elementary":
                if storedNewWordItemsDataLayer.elementaryBeingLearned.count != 0 {
                    return Double(storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
                        item.timesReviewed >= 2
                    }.count) / Double(storedNewWordItemsDataLayer.elementaryBeingLearned.count)
                } else {
                    return 0
                }
            case "beginner":
                if storedNewWordItemsDataLayer.beginnerBeingLearned.count != 0 {
                    return Double(storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
                        item.timesReviewed >= 2
                    }.count) / Double(storedNewWordItemsDataLayer.beginnerBeingLearned.count)
                } else {
                    return 0
                }
            case "intermediate":
                if storedNewWordItemsDataLayer.intermediateBeingLearned.count != 0 {
                    return Double(storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
                        item.timesReviewed >= 2
                    }.count) / Double(storedNewWordItemsDataLayer.intermediateBeingLearned.count)
                } else {
                    return 0
                }
            default:
                return 0
            }
        } else if thirdGoalIsCompleted == false {
            return 0
        }
        else {
            return 1
        }
    }
    var fifthGoalProgress: Double {
        if fifthGoalIsCompleted != true && fourthGoalIsCompleted == true {
            switch currentLevelSelected {
            case "elementary":
                if storedNewWordItemsDataLayer.elementaryBeingLearned.count != 0 {
                    return Double(storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
                        item.timesReviewed >= 10
                    }.count) / Double(storedNewWordItemsDataLayer.elementaryBeingLearned.count)
                } else {
                    return 0
                }
            case "beginner":
                if storedNewWordItemsDataLayer.beginnerBeingLearned.count != 0 {
                    return Double(storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
                        item.timesReviewed >= 10
                    }.count) / Double(storedNewWordItemsDataLayer.beginnerBeingLearned.count)
                } else {
                    return 0
                }
            case "intermediate":
                if storedNewWordItemsDataLayer.intermediateBeingLearned.count != 0 {
                    return Double(storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
                        item.timesReviewed >= 10
                    }.count) / Double(storedNewWordItemsDataLayer.intermediateBeingLearned.count)
                } else {
                    return 0
                }
            default:
                return 0
            }
        } else if fourthGoalIsCompleted == false {
            return 0
        } else {
            return 1
        }
    }
    func onboardingGoalsUpdater() {
        switch currentLevelSelected {
        case "elementary":
            // 1st goal completer
            if storedNewWordItemsDataLayer.elementaryKnewAlready.count + storedNewWordItemsDataLayer.elementaryBeingLearned.count >= wordsPerDiscovery {
                firstGoalIsCompleted = true
            } else {
                firstGoalIsCompleted = false
            }
            // 2nd goal completer
            if storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
                item.timesReviewed >= 2
            }.count >= wordsPerQuiz {
                secondGoalIsCompleted = true
            } else {
                secondGoalIsCompleted = false
            }
            // 3rd goal completer
            if storedNewWordItemsDataLayer.elementaryKnewAlready.count + storedNewWordItemsDataLayer.elementaryBeingLearned.count >= elementaryWordsStorageSource.count && secondGoalIsCompleted == true {
                thirdGoalIsCompleted = true
            } else {
                thirdGoalIsCompleted = false
            }
            // 4th goal completer
            if storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
                item.timesReviewed >= 2
            }.count >= storedNewWordItemsDataLayer.elementaryBeingLearned.count {
                if storedNewWordItemsDataLayer.elementaryBeingLearned.count != 0 && thirdGoalIsCompleted == true {
                    fourthGoalIsCompleted = true
                } else {
                    fourthGoalIsCompleted = false
                }
            } else {
                fourthGoalIsCompleted = false
            }
            // 5th goal completer
            if storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
                item.timesReviewed >= 10
            }.count == storedNewWordItemsDataLayer.elementaryBeingLearned.count {
                if storedNewWordItemsDataLayer.elementaryBeingLearned.count != 0 && fourthGoalIsCompleted == true {
                    fifthGoalIsCompleted = true
                } else {
                    fifthGoalIsCompleted = false
                }
            } else {
                fifthGoalIsCompleted = false
            }
        case "beginner":
            // 1st goal completer
            if storedNewWordItemsDataLayer.beginnerKnewAlready.count + storedNewWordItemsDataLayer.beginnerBeingLearned.count >= wordsPerDiscovery {
                firstGoalIsCompleted = true
            } else {
                firstGoalIsCompleted = false
            }
            // 2nd goal completer
            if storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
                item.timesReviewed >= 2
            }.count >= wordsPerQuiz {
                secondGoalIsCompleted = true
            } else {
                secondGoalIsCompleted = false
            }
            // 3rd goal completer
            if storedNewWordItemsDataLayer.beginnerKnewAlready.count + storedNewWordItemsDataLayer.beginnerBeingLearned.count >= beginnerWordsStorageSource.count && secondGoalIsCompleted == true {
                thirdGoalIsCompleted = true
            } else {
                thirdGoalIsCompleted = false
            }
            // 4th goal completer
            if storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
                item.timesReviewed >= 2
            }.count >= storedNewWordItemsDataLayer.beginnerBeingLearned.count {
                if storedNewWordItemsDataLayer.beginnerBeingLearned.count != 0 && thirdGoalIsCompleted == true {
                    fourthGoalIsCompleted = true
                } else {
                    fourthGoalIsCompleted = false
                }
            } else {
                fourthGoalIsCompleted = false
            }
            // 5th goal completer
            if storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
                item.timesReviewed >= 10
            }.count == storedNewWordItemsDataLayer.beginnerBeingLearned.count {
                if storedNewWordItemsDataLayer.beginnerBeingLearned.count != 0 && fourthGoalIsCompleted == true {
                    fifthGoalIsCompleted = true
                } else {
                    fifthGoalIsCompleted = false
                }
            } else {
                fifthGoalIsCompleted = false
            }
        case "intermediate":
            // 1st goal completer
            if storedNewWordItemsDataLayer.intermediateKnewAlready.count + storedNewWordItemsDataLayer.intermediateBeingLearned.count >= wordsPerDiscovery {
                firstGoalIsCompleted = true
            } else {
                firstGoalIsCompleted = false
            }
            // 2nd goal completer
            if storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
                item.timesReviewed >= 2
            }.count >= wordsPerQuiz {
                secondGoalIsCompleted = true
            } else {
                secondGoalIsCompleted = false
            }
            // 3rd goal completer
            if storedNewWordItemsDataLayer.intermediateKnewAlready.count + storedNewWordItemsDataLayer.intermediateBeingLearned.count >= intermediateWordsStorageSource.count && secondGoalIsCompleted == true {
                thirdGoalIsCompleted = true
            } else {
                thirdGoalIsCompleted = false
            }
            // 4th goal completer
            if storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
                item.timesReviewed >= 2
            }.count >= storedNewWordItemsDataLayer.intermediateBeingLearned.count {
                if storedNewWordItemsDataLayer.intermediateBeingLearned.count != 0 && thirdGoalIsCompleted == true {
                    fourthGoalIsCompleted = true
                } else {
                    fourthGoalIsCompleted = false
                }
            } else {
                fourthGoalIsCompleted = false
            }
            // 5th goal completer
            if storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
                item.timesReviewed >= 10
            }.count == storedNewWordItemsDataLayer.intermediateBeingLearned.count {
                if storedNewWordItemsDataLayer.intermediateBeingLearned.count != 0 && fourthGoalIsCompleted == true {
                    fifthGoalIsCompleted = true
                } else {
                    fifthGoalIsCompleted = false
                }
            } else {
                fifthGoalIsCompleted = false
            }
        default:
            print("onboarding goals updated")
        }
        // Определение актуальной цели (универсально для всех уровней)
        if firstGoalIsCompleted == false && secondGoalIsCompleted == false && thirdGoalIsCompleted == false && fourthGoalIsCompleted == false && fifthGoalIsCompleted == false {
            firstGoalIsCurrent = true
            secondGoalIsCurrent = false
            thirdGoalIsCurrent = false
            fourthGoalIsCurrent = false
            fifthGoalIsCurrent = false
        } else if firstGoalIsCompleted == true && secondGoalIsCompleted == false && thirdGoalIsCompleted == false && fourthGoalIsCompleted == false && fifthGoalIsCompleted == false {
            firstGoalIsCurrent = false
            secondGoalIsCurrent = true
            thirdGoalIsCurrent = false
            fourthGoalIsCurrent = false
            fifthGoalIsCurrent = false
        } else if firstGoalIsCompleted == true && secondGoalIsCompleted == true && thirdGoalIsCompleted == false && fourthGoalIsCompleted == false && fifthGoalIsCompleted == false {
            firstGoalIsCurrent = false
            secondGoalIsCurrent = false
            thirdGoalIsCurrent = true
            fourthGoalIsCurrent = false
            fifthGoalIsCurrent = false
        } else if firstGoalIsCompleted == true && secondGoalIsCompleted == true && thirdGoalIsCompleted == true && fourthGoalIsCompleted == false && fifthGoalIsCompleted == false {
            firstGoalIsCurrent = false
            secondGoalIsCurrent = false
            thirdGoalIsCurrent = false
            fourthGoalIsCurrent = true
            fifthGoalIsCurrent = false
        } else if firstGoalIsCompleted == true && secondGoalIsCompleted == true && thirdGoalIsCompleted == true && fourthGoalIsCompleted == true && fifthGoalIsCompleted == false {
            firstGoalIsCurrent = false
            secondGoalIsCurrent = false
            thirdGoalIsCurrent = false
            fourthGoalIsCurrent = false
            fifthGoalIsCurrent = true
        }
    }
    var body: some View {
        VStack{
            HStack {
                VStack {
                    // 1st onboarding goal
                    OnboardingGoalCircle(progress: firstGoalProgress, progressText: Double(firstGoalProgress), isCurrentGoal: firstGoalIsCurrent)
                    Text("\(firstGoalIsCompleted)")
                }
                VStack {
                    // 2nd onboarding goal
                    OnboardingGoalCircle(progress: secondGoalProgress, progressText: Double(secondGoalProgress), isCurrentGoal: secondGoalIsCurrent)
                    Text("\(secondGoalIsCompleted)")
                }
                VStack {
                    // 3rd onboarding goal
                    OnboardingGoalCircle(progress: thirdGoalProgress, progressText: Double(thirdGoalProgress), isCurrentGoal: thirdGoalIsCurrent)
                    Text("\(thirdGoalIsCompleted)")
                }
                VStack {
                    // 4th onboarding goal
                    OnboardingGoalCircle(progress: fourthGoalProgress, progressText: Double(fourthGoalProgress), isCurrentGoal: fourthGoalIsCurrent)
                    Text("\(fourthGoalIsCompleted)")
                }
                VStack {
                    // 5th onboarding goal
                    OnboardingGoalCircle(progress: fifthGoalProgress, progressText: Double(fifthGoalProgress), isCurrentGoal: fifthGoalIsCurrent)
                    Text("\(fifthGoalIsCompleted)")
                }
            }
        }
        .onAppear{
            storedNewWordItemsDataLayer.initialWordDataLoader()
            onboardingGoalsUpdater()
        }
    }
}
#Preview {
    OnboardingGoals()
        .environmentObject(storedNewWordItems())
}
