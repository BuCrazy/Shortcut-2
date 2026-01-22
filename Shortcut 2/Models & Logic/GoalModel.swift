//
//  GoalModel.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/13/25.
//

import Foundation
import SwiftUI

// All possible goal statuses
enum GoalStatus {
    case notStarted
    case inProgress
    case completed
}

//Configuring all possible goal by types types
struct GoalConfiguration {
    let currentLevel: String?
    let wordsPerGoal: Int?
    let quizPassScore: Double?
  
    
    // Different goals need to pay attention to a different parameters, so we init each goals priorities
    static func cardSwipeConfig(level: String, target: Int) -> GoalConfiguration {
        GoalConfiguration(
            currentLevel: level,
            wordsPerGoal: target,
            quizPassScore: nil
        )
    }
    
    static func quizBasedConfig(level: String, passScore: Double) -> GoalConfiguration {
        GoalConfiguration(
            currentLevel: level,
            wordsPerGoal: nil,
            quizPassScore: passScore
        )
    }
}



// Protocol defining requirements for goal calculators
protocol GoalProgress {
    func calculateProgress(
        storedItems: storedNewWordItems,
        config: GoalConfiguration
    ) -> Double
}



//Goal calculator for the first goal
class FirstGoalProgress: GoalProgress {
    func calculateProgress(
        storedItems: storedNewWordItems,
        config: GoalConfiguration
    ) -> Double {
        
        // Safely unwraping required configuration
        guard let level = config.currentLevel,
              let target = config.wordsPerGoal else {
            return 0
        }

        let swipedWords: Int
        switch level {
        case "elementary":
            swipedWords = storedItems.elementaryBeingLearned.count
        case "beginner":
            swipedWords = storedItems.beginnerBeingLearned.count

        case "intermediate":
            swipedWords = storedItems.intermediateBeingLearned.count

        default:
            swipedWords = 0
           // print("⚠️ Unknown level: \(level)")
        }
        
       
        
        // Calculate progress
        let progress = Double(swipedWords) / Double(target)
        
        
        if progress >= 1.0 {
        }
        return min(progress, 1.0)
    }
}


class SecondGoalProgress: GoalProgress {
    func calculateProgress(storedItems: storedNewWordItems, config: GoalConfiguration) -> Double {

        guard let level = config.currentLevel,
              let requiredPassScore = config.quizPassScore
        else {
            return 0
        }
        
        // Get the current quiz state with error handling
        let quizState: storedNewWordItems.QuizState?
        do {
          quizState = try storedItems.loadQuizState()
        } catch {
            print("Error loading quiz state: \(error)")
            return 0
        }
        
        // If no quiz is in progress, return 0
        guard let state = quizState else {
            print("No Quiz is In Progress")
            return 0
        }
        
        // Calculate progress based on:
        let totalAnswered = state.correctAnswerCount + state.incorrectAnswerCount
        if totalAnswered == 0 { return 0 }
        
        // Calculate current score
        let currentScore = (Double(state.correctAnswerCount) / Double(totalAnswered)) * 100
        
        // Calculate progress based on questions answered
        let progressPercentage = Double(totalAnswered) / 30.0
        
        // If all questions are answered, check if score meets requirement
        if totalAnswered >= 30 {
            let passed = currentScore >= Double(requiredPassScore)
           // return currentScore >= Double(requiredPassScore) ? 1.0 : 0.0
            
            print("Quiz Complete - Score: \(currentScore)%, Required: \(requiredPassScore)%, Passed: \(passed)") // Debug logging
            return passed ? 1.0 : 0.0
        }
        
        // Otherwise return progress based on questions answered
        return progressPercentage
    }
}

// Goal class described with all the parameters
class Goal: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var progress: Double
    @Published var status: GoalStatus
    @Published var configuration: GoalConfiguration
    let id: Int
    let progressCalculator: GoalProgress
    // Test April 1 (delete this variable to get back)
    //let isCompletable: Bool = true
    
    init(
        id: Int,
        title: String,
        description: String,
        progress: Double = 0.0,
        status: GoalStatus = .notStarted,
        progressCalculator: GoalProgress,
        configuration: GoalConfiguration
     //   isCompletable: Bool = true
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.progress = progress //0.0 TEST AUG 20
        self.status = status // .notStarted TEST AUG 20
        self.progressCalculator = progressCalculator
        self.configuration = configuration
       // self.isCompletable = isCompletable
    }
}



class GoalsManager: ObservableObject {
    private let instanceId = UUID()
    static let shared = GoalsManager(storedItems: storedNewWordItems.shared)
    @Published private(set) var goals: [Goal]
    @Published private(set) var currentGoalIndex: Int {
        didSet {
            saveState()
        }
    }
    
    @Published var showCompletionMessage: Bool
    @Published var completionMessage: String
    @Published  var hasShownCompletionToast: Bool = false // TEST Jun 29 (delete to go back)
    @AppStorage("currentLevelSelected_key") private var currentLevelSelected: String = "elementary"
    @AppStorage("wordsPerQuiz_key") private var wordsPerQuiz: Int = 30
    private weak var storedItems: storedNewWordItems?
    
    private let defaults = UserDefaults.standard
    private let currentGoalKey = "currentGoalIndex_key"
    private let goalsStatusKey = "goals_status_key"
    private let completionToastShownKey = "completion_toast_shown_key" // TEST Jun 29 (delete to go back)

    
   
    private func ensureStateUpdate() {
        // Force a state update cycle
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.objectWillChange.send()
            // Save state after update
            self.saveState()
        }
    }
    
    
    
    // TEST Jan 3 'Freeze Issue' (Delete this version of the function to get back) || Modified to handle everything the updateProgressAfterSwipe() does
    func updateStoredItems(_ items: storedNewWordItems) {
        print("🔄 Updating stored items in GoalsManager")
        self.storedItems = items
        
        guard let items = self.storedItems else {
            print("⚠\u{fef} No stored items available")
            return
        }
        
        
        // Test March 31 (remove this test code to get back to original code)
        //Skip progress updates if all goals are completed
        if goals.allSatisfy({ $0.status == .completed }) {
            print("🎯 All goals are already completed - skipping progress update")
            saveGoalStatuses() // Ensure statuses are preserved
            return
        }
        
        //Skipping progress updates if the current goal is already completed
        guard currentGoal.status != .completed else {
            print("🎯 Current goal is already completed - preventing progress update")
            return
        }
        // Test March 31 (remove this test code to get back to original code) END
        
        
        
        
        let currentProgress = currentGoal.progressCalculator.calculateProgress(
            storedItems: items,
            config: currentGoal.configuration
        )
        print("🎯 Progress calculated: \(currentProgress)")
        
        objectWillChange.send()
        let currentStatus = currentGoal.status
        
        currentGoal.progress = currentProgress
        
        if currentProgress >= 1.0 && currentStatus != .completed {
            print("🎯 Goal completion detected with index: \(currentGoalIndex)")
            completeCurrentGoal()
        } else if currentProgress > 0 && currentStatus != .completed {
            currentGoal.status = .inProgress
        }
        
        // Ensure UI updates
        objectWillChange.send()
        saveState()
        ensureStateUpdate()
        
    }
    
    init(storedItems: storedNewWordItems) {
        print("🔄 GoalsManager \(instanceId) initialized")
        self.storedItems = storedItems
        
        
        // Load saved goal index from UserDefaults
        self.currentGoalIndex = defaults.integer(forKey: currentGoalKey)
        self.showCompletionMessage = false
        self.completionMessage = ""
        self.hasShownCompletionToast = defaults.bool(forKey: completionToastShownKey) //TEST June 29 (delete to go back)

        
        // Calculate initial progress before creating goals
        let savedLevel = UserDefaults.standard.string(forKey: "currentLevelSelected_key") ?? "elementary"
        let calculator = FirstGoalProgress()
        let initialProgress = calculator.calculateProgress(
            storedItems: storedItems,
            config: .cardSwipeConfig(level: savedLevel, target: 30)
        )
        print("📊 Initial progress calculated: \(initialProgress)")
        
        self.goals = [
            Goal(
                id: 1,
                title: "Discover 30 unknown words",
                description: "Swipe down the cards with unknown words.",
                progress: initialProgress,
              //  status: initialProgress > 0 ? .inProgress : .notStarted,
                status: .inProgress, //Always start first goal in the .inProgress status
                progressCalculator: FirstGoalProgress(),
                configuration: .cardSwipeConfig(
                    level: savedLevel,
                    target: 30
                )
            ),
            
            Goal(
                id: 2,
                title: "Complete Quiz",
                description: "Answer 30 questions with minimum 80% accuracy",
                progressCalculator: SecondGoalProgress(),
                configuration: .quizBasedConfig(
                    level: savedLevel,
                    passScore: 80.0
                )
            )
            
        ]
        
        loadGoalStatuses() // Test March 16 (delete to get back)
        
        //Test April 1 (delete this code to get back)
        // checkin the status of loaded goals and force them to be completed if they are completed
        for goal in goals {
            if goal.status == .completed {
                goal.progress = 1.0
            }
        }
        
        
        
        
        print("✅ GoalsManager initialized with progress: \(initialProgress)")
    }
    
    /*private*/ func saveState() {
        defaults.set(currentGoalIndex, forKey: currentGoalKey) //Test Dec 14
        defaults.set(hasShownCompletionToast, forKey: completionToastShownKey) //TEST June 29 (delete to get back)
        saveGoalStatuses()
    }
    
    
    // Test March 16 (delete func to get back)
    private func saveGoalStatuses() {
        // Createing an array of Int representing goal statuses
        let statusArray = goals.map { goal -> Int in
            switch goal.status {
            case .notStarted: return 0
            case .inProgress: return 1
            case .completed: return 2
            }
            
        }
        
        // Saving to UserDefaults
        defaults.set(statusArray, forKey: goalsStatusKey)
        print("📝 Saved goal statuses: \(statusArray)")
    }
    
    // Amethod to load goal statuses Test March 16 (delete method to get back)
    private func loadGoalStatuses() {
        // Get saved statuses array from UserDefaults
        guard let statusArray = defaults.array(forKey: goalsStatusKey) as? [Int] else {
            print("⚠️ No saved goal statuses found")
            return
        }
        
        // Applying saved statuses to goals, where array indices matchS
        for (index, statusValue) in statusArray.enumerated() {
            if index < goals.count {
                let status: GoalStatus
                switch statusValue {
                case 0: status = .notStarted
                case 1: status = .inProgress
                case 2: status = .completed
                default: status = .notStarted
                }
                // special handling for the first goal Aug 20
                
                if index == 0 {
                    if status == .notStarted {
                        // Never allow the first goal to be .notStarted
                        goals[index].status = .inProgress
                        print("🔄 First goal forced to .inProgress (was .notStarted)")
                    } else {
                        goals[index].status = status
                    }
                } else {
                    // For all other goals, apply the saved status normally
                    goals[index].status = status
                }
                // If completed, ensure progress is 1.0
                if status == .completed {
                    goals[index].progress = 1.0
                }
                
                print("🔄 Loaded status for goal \(index + 1): \(status)")
            }
        }
    }
    
    var currentGoal: Goal {
        goals[currentGoalIndex]
    }
    
    
    
    private func completeCurrentGoal() {
        print("🎊 Starting goal completion")
        
        //TEST April 3 (remove check to get back)
        guard currentGoal.status != .completed else {
            print("⚠️ Goal already completed - skipping completion process")
            return
        }
        
        print("🎯 COMPLETING GOAL \(currentGoalIndex)")
        goals[currentGoalIndex].status = .completed
        goals[currentGoalIndex].progress = 1.0
        let completedGoalTitle = goals[currentGoalIndex].title
        print("🏆 Completed goal: \(completedGoalTitle)")
        
        objectWillChange.send() //Test Dec 28 (delete to return to the original)
        
        if currentGoalIndex < goals.count - 1 {
            let nextGoalTitle = goals[currentGoalIndex + 1].title
            currentGoalIndex += 1
            goals[currentGoalIndex].status = .inProgress
            print("🔄 Index updated to: \(currentGoalIndex)")
            
            //TEST May 12 (Delete code below to get back to the original)
            // ADD: Immediately evaluate the next goal's progress
                        if let items = self.storedItems {
                            let nextGoalProgress = currentGoal.progressCalculator.calculateProgress(
                                storedItems: items,
                                config: currentGoal.configuration
                            )
                            print("🎯 Next goal initial progress: \(nextGoalProgress)")
                            
                            // If the next goal is already complete (like the quiz being passed),
                            // trigger completion immediately
                            if nextGoalProgress >= 1.0 {
                                print("🎯 Next goal already meets completion criteria")
                                // Use DispatchQueue to avoid recursive call
                                DispatchQueue.main.async {
                                    self.completeCurrentGoal()
                                }
                            }
                        }
            //TEST May 12 ends
            
            completionMessage = "Congratulations! You've completed '\(completedGoalTitle)'!\nYour next goal is '\(nextGoalTitle)'"
            print("📣 Set completion message: \(completionMessage)")
        } else {


            completionMessage = "Congratulations! You've completed all goals!"
            print("📣 Set final completion message: \(completionMessage)")
        }
        
        showCompletionMessage = true
        print("🔔 Showing completion message")
        
        // Force UI update
        objectWillChange.send() //Test Dec 14
        saveState() //Test Dec 28 (delete to return to the original)
        ensureStateUpdate() //Test Dec 29 (delete to return to the original code)
        
        DispatchQueue.main.async { // Test March 10 (delete to go back)
            self.objectWillChange.send()
        }
        
    }
}
