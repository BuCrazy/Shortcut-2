import FirebaseAuth
import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import Firebase
import FirebaseAuthCombineSwift

// Эта структура, по которой для каждого уровня будет считываться читаться JSON-файл с базой слов и по которой слова для Discovery будут записываться в промежуточные массивы каждого соответствующего уровня:

struct WordItemStruct: Hashable, Identifiable, Codable, Equatable {
    
    var id: Int
    var position_now: Int
    var pos: String
    var word: String
    var phonetics: String
    var definition: String
    var collocations: String
    var sentence: String
    var video: String
    var movie: String
    var movie_quote: String
    var ukranian: String
    var russian: String
    var bulgarian: String
    var chinese: String
    var czech: String
    var danish: String
    var dutch: String
    var estonian: String
    var finnish: String
    var french: String
    var german: String
    var greek: String
    var hungarian: String
    var indonesian: String
    var italian: String
    var japanese: String
    var korean: String
    var latvian: String
    var lithuanian: String
    var norwegian: String
    var polish: String
    var portuguese: String
    var romanian: String
    var slovak: String
    var slovenian: String
    var spanish: String
    var swedish: String
    var turkish: String
    
}

extension WordItemStruct {
    func translationForLanguage(_ language: String) -> String {
        switch language.lowercased() {
        case "ukrainian":
            return self.ukranian
        case "russian":
            return self.russian
        case "bulgarian":
            return self.bulgarian
        case "chinese":
            return self.chinese
        case "czech":
            return self.czech
        case "danish":
            return self.danish
        case "dutch":
            return self.dutch
        case "estonian":
            return self.estonian
        case "finnish":
            return self.finnish
        case "french":
            return self.french
        case "german":
            return self.german
        case "greek":
            return self.greek
        case "hungarian":
            return self.hungarian
        case "indonesian":
            return self.indonesian
        case "italian":
            return self.italian
        case "japanese":
            return self.japanese
        case "korean":
            return self.korean
        case "latvian":
            return self.latvian
        case "lithuanian":
            return self.lithuanian
        case "norwegian":
            return self.norwegian
        case "polish":
            return self.polish
        case "portuguese":
            return self.portuguese
        case "romanian":
            return self.romanian
        case "slovak":
            return self.slovak
        case "slovenian":
            return self.slovenian
        case "spanish":
            return self.spanish
        case "swedish":
            return self.swedish
        case "turkish":
            return self.turkish
        default:
            return self.ukranian
        }
    }
}

// Эта структура – для сохранения по ней любых слов в новые массивы слов Знаю и Не знаю для каждого уровня после манипуляций со словами из массивов для Discovery:

struct wordItemNew: Hashable, Identifiable, Codable, Equatable {
    
    var id: Int
    var position_now: Int
    var word: String = ""
    var dateAdded: String = ""
    var timesReviewed: Int = 0
    var consecutiveCorrectRecalls: Int = 0
    var progress: Double = 0

}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
}

// --- Code for saving Quiz historical data ---

struct QuizHistory: Codable {
    var quizHistoricalData: [String: Double]
    
    var totalAverage: Double {
        let totalScore = quizHistoricalData.values.reduce(0, +)
        return totalScore / Double(quizHistoricalData.count)
    }
    init() {
            // Try to load existing data when initializing
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("quizHistory.json")
            do {
                let data = try Data(contentsOf: fileURL)
                self = try JSONDecoder().decode(QuizHistory.self, from: data)
            } catch {
                self.quizHistoricalData = [:]  // Initialize with empty data if loading fails
                print("Failed to load quiz history: \(error)")
            }
        }
    
    mutating func saveQuizData(date: Date, score: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateKey = dateFormatter.string(from: date)
        
        quizHistoricalData[dateKey] = score
    }
    
    func encodeToJson() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    static func decodeFromJson(data: Data) throws -> QuizHistory {
        return try JSONDecoder().decode(QuizHistory.self, from: data)
    }
}
extension QuizHistory {
    mutating func loadFromPersistentStorage() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("quizHistory.json")
        do {
            let data = try Data(contentsOf: fileURL)
            self = try JSONDecoder().decode(QuizHistory.self, from: data)
        } catch {
            print("Failed to load quiz history: \(error)")
        }
    }

    func saveToPersistentStorage() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("quizHistory.json")
        do {
            let data = try JSONEncoder().encode(self)
            try data.write(to: fileURL, options: [.atomicWrite])
        } catch {
            print("Failed to save quiz history: \(error)")
        }
    }
}

// --- Code for saving Quiz historical data ends ---

class AuthManager: ObservableObject {
    @Published var user: User? = nil
    
    private var auth = Auth.auth()
    
    init() {
        self.user = auth.currentUser
        auth.addStateDidChangeListener { (auth, user) in
            self.user = user
        }
    }
    
//    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
//        auth.createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                completion(error)
//            } else {
//                self.user = authResult?.user
//                completion(nil)
//            }
//        }
//    }
//    
//    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
//        auth.signIn(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                completion(error)
//            } else {
//                self.user = authResult?.user
//                completion(nil)
//            }
//        }
//    }
//    
//    func signOut(completion: @escaping (Error?) -> Void) {
//        do {
//            try auth.signOut()
//            self.user = nil
//            completion(nil)
//        } catch let signOutError as NSError {
//            completion(signOutError)
//        }
//    }
}

// Тут будем хранить два массива слов, "Знаю" и "Не знаю", теперь для всех уровней. Слова в них будут сохраняться по структуре wordItemNew:

class storedNewWordItems: ObservableObject {
    
    static let shared = storedNewWordItems()
        
    // Code for quiz History persistence //
    var quizHistory = QuizHistory()

    // Code for quiz History persistence ends //
    
    func arrayForLevel(_ level: String) -> [wordItemNew] {
            switch level {
            case "elementary":
                return elementaryBeingLearned
            case "beginner":
                return beginnerBeingLearned
            case "intermediate":
                return intermediateBeingLearned
//            case "advanced":
//                return advancedBeingLearned
//            case "nativelike":
//                return nativelikeBeingLearned
//            case "borninengland":
//                return borninenglandBeingLearned
            default:
                return []
            }
        }
    
    func storageForLevel(_ level: String) -> [WordItemStruct] {
            switch level {
            case "elementary":
                return elementaryWordsStorageSource
            case "beginner":
                return beginnerWordsStorageSource
            case "intermediate":
                return intermediateWordsStorageSource
//            case "advanced":
//                return advancedWordsStorage
//            case "nativelike":
//                return nativelikeWordsStorage
//            case "borninengland":
//                return borninenglandWordsStorage
            default:
                return []
            }
        
        }
    
    private var db = Firestore.firestore()

    @Published var authManager = AuthManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
//        authManager.$user
//            .sink { [weak self] user in
//                if let user = user {
//                    self?.loadData(for: user.uid)
//                }
//            }
//            .store(in: &cancellables)
    }
    
    var elementaryWordsStorageWordProgress: Int {
        return elementaryWordsStorageSource.count - elementaryWordsStorage.count
    }
    
    var beginnerWordsStorageWordProgress: Int {
        return beginnerWordsStorageSource.count - beginnerWordsStorage.count
    }
    
    var intermediateWordsStorageWordProgress: Int {
        return intermediateWordsStorageSource.count - intermediateWordsStorage.count
    }
    
    func saveData() {
        guard let user = authManager.user else { return }
        do {
            let elementaryKnewAlreadyData = try JSONEncoder().encode(elementaryKnewAlready)
            let elementaryKnewAlreadyDict = try JSONSerialization.jsonObject(with: elementaryKnewAlreadyData, options: []) as! [[String: Any]]
            let elementaryBeingLearnedData = try JSONEncoder().encode(elementaryBeingLearned)
            let elementaryBeingLearnedDict = try JSONSerialization.jsonObject(with: elementaryBeingLearnedData, options: []) as! [[String: Any]]
            let beginnerKnewAlreadyData = try JSONEncoder().encode(beginnerKnewAlready)
            let beginnerKnewAlreadyDict = try JSONSerialization.jsonObject(with: beginnerKnewAlreadyData, options: []) as! [[String: Any]]
            let beginnerBeingLearnedData = try JSONEncoder().encode(beginnerBeingLearned)
            let beginnerBeingLearnedDict = try JSONSerialization.jsonObject(with: beginnerBeingLearnedData, options: []) as! [[String: Any]]
            let intermediateKnewAlreadyData = try JSONEncoder().encode(intermediateKnewAlready)
            let intermediateKnewAlreadyDict = try JSONSerialization.jsonObject(with: intermediateKnewAlreadyData, options: []) as! [[String: Any]]
            let intermediateBeingLearnedData = try JSONEncoder().encode(intermediateBeingLearned)
            let intermediateBeingLearnedDict = try JSONSerialization.jsonObject(with: intermediateBeingLearnedData, options: []) as! [[String: Any]]
            db.collection("users").document(user.uid).setData([
                "elementaryKnewAlready": elementaryKnewAlreadyDict,
                "elementaryBeingLearned": elementaryBeingLearnedDict,
                "beginnerKnewAlready": beginnerKnewAlreadyDict,
                "beginnerBeingLearned": beginnerBeingLearnedDict,
                "intermediateKnewAlready": intermediateKnewAlreadyDict,
                "intermediateBeingLearned": intermediateBeingLearnedDict,
                "elementaryWordsStorageWordProgress": elementaryWordsStorageWordProgress,
                "beginnerWordsStorageWordProgress": beginnerWordsStorageWordProgress,
                "intermediateWordsStorageWordProgress": intermediateWordsStorageWordProgress
            ]) { error in
                if let error = error {
                    print("Error saving data: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error encoding data: \(error.localizedDescription)")
        }
    }
    
    func loadData(for userID: String) {
        db.collection("users").document(userID).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                do {
                    if let data = document.data() {
                        if let elementaryKnewAlreadyData = data["elementaryKnewAlready"] as? [[String: Any]] {
                            let jsonData = try JSONSerialization.data(withJSONObject: elementaryKnewAlreadyData, options: [])
                            self.elementaryKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: jsonData)
                        }
                        if let elementaryBeingLearnedData = data["elementaryBeingLearned"] as? [[String: Any]] {
                            let jsonData = try JSONSerialization.data(withJSONObject: elementaryBeingLearnedData, options: [])
                            self.elementaryBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: jsonData)
                        }
                        
                        if let beginnerKnewAlreadyData = data["beginnerKnewAlready"] as? [[String: Any]] {
                            let jsonData = try JSONSerialization.data(withJSONObject: beginnerKnewAlreadyData, options: [])
                            self.beginnerKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: jsonData)
                        }
                        if let beginnerBeingLearnedData = data["beginnerBeingLearned"] as? [[String: Any]] {
                            let jsonData = try JSONSerialization.data(withJSONObject: beginnerBeingLearnedData, options: [])
                            self.beginnerBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: jsonData)
                        }
                        
                        if let intermediateKnewAlreadyData = data["intermediateKnewAlready"] as? [[String: Any]] {
                            let jsonData = try JSONSerialization.data(withJSONObject: intermediateKnewAlreadyData, options: [])
                            self.intermediateKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: jsonData)
                        }
                        if let intermediateBeingLearnedData = data["intermediateBeingLearned"] as? [[String: Any]] {
                            let jsonData = try JSONSerialization.data(withJSONObject: intermediateBeingLearnedData, options: [])
                            self.intermediateBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: jsonData)
                        }
                        
                        if !elementaryWordsStorage.isEmpty{
                            if let elementaryWordsStorageWordsToDelete = data["elementaryWordsStorageWordProgress"] as? Int {
                                elementaryWordsStorage.removeFirst(elementaryWordsStorageWordsToDelete)
                            }
                        }
                        if !beginnerWordsStorage.isEmpty{
                            if let beginnerWordsStorageWordsToDelete = data["beginnerWordsStorageWordProgress"] as? Int {
                                beginnerWordsStorage.removeFirst(beginnerWordsStorageWordsToDelete)
                            }
                        }
                        if !intermediateWordsStorage.isEmpty{
                            if let intermediateWordsStorageWordsToDelete = data["intermediateWordsStorageWordProgress"] as? Int {
                                intermediateWordsStorage.removeFirst(intermediateWordsStorageWordsToDelete)
                            }
                        }
                    }
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Объявляем вообще сами массивы слов для начала с соответстующими названиями, пока они пустые и в них ничего не записывается, а также объявляем, что данные в них будут сохраняться по структуре WordItemStruct:
    
    var elementaryWordsStorage = [WordItemStruct]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.elementaryWordsStorageSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    var beginnerWordsStorage = [WordItemStruct]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.beginnerWordsStorageSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    var intermediateWordsStorage = [WordItemStruct](){
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.intermediateWordsStorageSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    var advancedWordsStorage = [WordItemStruct](){
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.advancedWordsStorageSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    var nativelikeWordsStorage = [WordItemStruct](){
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.nativelikeWordsStorageSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    var borninenglandWordsStorage = [WordItemStruct]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.borninenglandWordsStorageSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    // Теперь для каждого уровня создаем отдельные массивы для слов "Знаю" и "Не знаю", и объявляем, что в них слова будут сохраняться по структуре WordItemNew:
    
    @Published var elementaryKnewAlready = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).async {
                do {
                    try self.elementaryKnewAlreadySave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var elementaryBeingLearned = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.elementaryBeingLearnedSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var beginnerKnewAlready = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.beginnerKnewAlreadySave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var beginnerBeingLearned = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.beginnerBeingLearnedSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var intermediateKnewAlready = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.intermediateKnewAlreadySave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var intermediateBeingLearned = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.intermediateBeingLearnedSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var advancedKnewAlready = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.advancedKnewAlreadySave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var advancedBeingLearned = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.advancedBeingLearnedSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var nativelikeKnewAlready = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.nativelikeKnewAlreadySave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var nativelikeBeingLearned = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.nativelikeBeingLearnedSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var borninenglandKnewAlready = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.borninenglandKnewAlreadySave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    @Published var borninenglandBeingLearned = [wordItemNew]() {
        didSet {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
                do {
                    try self?.borninenglandBeingLearnedSave()
                } catch {
                    print("Error saving data: \(error)")
                }
            }
        }
    }
    
    
//    func generateLast7DaysData(for level: String) -> [TotalWords] {
////        print("generateLast7DaysData called for level: \(level)")
//        print("Array address in generateLast7DaysData: \(Unmanaged.passUnretained(intermediateBeingLearned as AnyObject).toOpaque())")
//     //   var dataSource = storedNewWordItems.shared
//        var data: [TotalWords] = []
//        let calendar = Calendar.current
//        
//        // Select the array based on the current level
//        let wordsArray: [wordItemNew]
//            switch level {
//            case "elementary":
//                wordsArray = elementaryBeingLearned
//            case "beginner":
//                wordsArray = beginnerBeingLearned
//            case "intermediate":
//                wordsArray = intermediateBeingLearned
//                print("Checking what's going on 2 \(intermediateBeingLearned)")
//            case "advanced":
//                wordsArray = advancedBeingLearned
//            case "nativelike":
//                wordsArray = nativelikeBeingLearned
//            case "borninengland":
//                wordsArray = borninenglandBeingLearned
//            default:
//                wordsArray = []
//            }
//      //  print("\(level)BeingLearned contents: \(wordsArray)")
//        
//        for i in 0..<7 {
//            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
//                let wordsForDay = wordsArray.filter {
//                    guard let dateAdded = $0.dateAdded.toDate() else { return false }
//                    return calendar.isDate(dateAdded, inSameDayAs: date)
//                }
//                
//                let wordCount = Double(wordsForDay.count)
//              
//                data.append(TotalWords(day: date, wordsAdded: wordCount))
//            }
//        }
//        return data.reversed()
//    }
    
    // Функции для инициации чтения массивов слов "Знаю" и "Не знаю" из локальных файлов и записи их в соответствующие массивы в памяти, а также записи из массивов обратно в локальные файлы:
    
    // Задаём общую директорию для хранения всех файлов всех уровней:
    
    private var documentDirectory: URL {
      try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    func initialWordDataLoader() {
        print("Starting initialWordDataLoader")
        try! elementaryWordsStorageLoad()
        try! beginnerWordsStorageLoad()
        try! intermediateWordsStorageLoad()
        try! advancedWordsStorageLoad()
        try! nativelikeWordsStorageLoad()
        try! borninenglandWordsStorageLoad()
        try! elementaryKnewAlreadyLoad()
        try! elementaryBeingLearnedLoad()
        try! beginnerKnewAlreadyLoad()
        try! beginnerBeingLearnedLoad()
        try! intermediateKnewAlreadyLoad()
        try! intermediateBeingLearnedLoad()
        try! advancedKnewAlreadyLoad()
        try! advancedBeingLearnedLoad()
        try! nativelikeKnewAlreadyLoad()
        try! nativelikeBeingLearnedLoad()
        try! borninenglandKnewAlreadyLoad()
        try! borninenglandBeingLearnedLoad()
        
        if elementaryWordsStorage.isEmpty {
            elementaryWordsStorage = elementaryWordsStorageSource
            
        }
        if beginnerWordsStorage.isEmpty {
            beginnerWordsStorage = beginnerWordsStorageSource
        }
        if intermediateWordsStorage.isEmpty {
            intermediateWordsStorage = intermediateWordsStorageSource
        }
        
        print("Completed initialWordDataLoader")
    }
    
    // Функции для уровня Elementary:
    
    private var elementaryKnewAlreadyFile: URL {
        documentDirectory
            .appendingPathComponent("elementaryKnewAlreadyFile")
            .appendingPathExtension(for: .json)
    }

    func elementaryKnewAlreadySave() throws {
        let data = try JSONEncoder().encode(elementaryKnewAlready)
        try data.write(to: elementaryKnewAlreadyFile)
    }

    func elementaryKnewAlreadyLoad() throws {
      guard FileManager.default.isReadableFile(atPath: elementaryKnewAlreadyFile.path) else { return }
      let data = try Data(contentsOf: elementaryKnewAlreadyFile)
        elementaryKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: data)
    }

    private var elementaryBeingLearnedFile: URL {
        documentDirectory
            .appendingPathComponent("elementaryBeingLearnedFile")
            .appendingPathExtension(for: .json)
    }

    func elementaryBeingLearnedSave() throws {
        let data = try JSONEncoder().encode(elementaryBeingLearned)
        try data.write(to: elementaryBeingLearnedFile)
    }

    func elementaryBeingLearnedLoad() throws {
      guard FileManager.default.isReadableFile(atPath: elementaryBeingLearnedFile.path) else { return }
      let data = try Data(contentsOf: elementaryBeingLearnedFile)
        elementaryBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    // Функции для уровня Beginner:
    
    private var beginnerKnewAlreadyFile: URL {
        documentDirectory
            .appendingPathComponent("beginnerKnewAlreadyFile")
            .appendingPathExtension(for: .json)
    }
  
    func beginnerKnewAlreadySave() throws {
        let data = try JSONEncoder().encode(beginnerKnewAlready)
        try data.write(to: beginnerKnewAlreadyFile)
    }
    
    func beginnerKnewAlreadyLoad() throws {
      guard FileManager.default.isReadableFile(atPath: beginnerKnewAlreadyFile.path) else { return }
      let data = try Data(contentsOf: beginnerKnewAlreadyFile)
        beginnerKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    private var beginnerBeingLearnedFile: URL {
        documentDirectory
            .appendingPathComponent("beginnerBeingLearnedFile")
            .appendingPathExtension(for: .json)
    }
  
    func beginnerBeingLearnedSave() throws {
        let data = try JSONEncoder().encode(beginnerBeingLearned)
        try data.write(to: beginnerBeingLearnedFile)
    }
    
    func beginnerBeingLearnedLoad() throws {
      guard FileManager.default.isReadableFile(atPath: beginnerBeingLearnedFile.path) else { return }
      let data = try Data(contentsOf: beginnerBeingLearnedFile)
        beginnerBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    // Функции для уровня Intermediate:
    
    private var intermediateKnewAlreadyFile: URL {
        documentDirectory
            .appendingPathComponent("intermediateKnewAlreadyFile")
            .appendingPathExtension(for: .json)
    }
  
    func intermediateKnewAlreadySave() throws {
        let data = try JSONEncoder().encode(intermediateKnewAlready)
        try data.write(to: intermediateKnewAlreadyFile)
    }
    
    func intermediateKnewAlreadyLoad() throws {
      guard FileManager.default.isReadableFile(atPath: intermediateKnewAlreadyFile.path) else { return }
      let data = try Data(contentsOf: intermediateKnewAlreadyFile)
        intermediateKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    private var intermediateBeingLearnedFile: URL {
        documentDirectory
            .appendingPathComponent("intermediateBeingLearnedFile")
            .appendingPathExtension(for: .json)
    }
  
    func intermediateBeingLearnedSave() throws {
        let data = try JSONEncoder().encode(intermediateBeingLearned)
        try data.write(to: intermediateBeingLearnedFile)
    }
    
    func intermediateBeingLearnedLoad() throws {
      guard FileManager.default.isReadableFile(atPath: intermediateBeingLearnedFile.path) else { return }
      let data = try Data(contentsOf: intermediateBeingLearnedFile)
        intermediateBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    // Функции для уровня advanced:
    
    private var advancedKnewAlreadyFile: URL {
        documentDirectory
            .appendingPathComponent("advancedKnewAlreadyFile")
            .appendingPathExtension(for: .json)
    }
  
    func advancedKnewAlreadySave() throws {
        let data = try JSONEncoder().encode(advancedKnewAlready)
        try data.write(to: advancedKnewAlreadyFile)
    }
    
    func advancedKnewAlreadyLoad() throws {
      guard FileManager.default.isReadableFile(atPath: advancedKnewAlreadyFile.path) else { return }
      let data = try Data(contentsOf: advancedKnewAlreadyFile)
        advancedKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    private var advancedBeingLearnedFile: URL {
        documentDirectory
            .appendingPathComponent("advancedBeingLearnedFile")
            .appendingPathExtension(for: .json)
    }
  
    func advancedBeingLearnedSave() throws {
        let data = try JSONEncoder().encode(advancedBeingLearned)
        try data.write(to: advancedBeingLearnedFile)
    }
    
    func advancedBeingLearnedLoad() throws {
      guard FileManager.default.isReadableFile(atPath: advancedBeingLearnedFile.path) else { return }
      let data = try Data(contentsOf: advancedBeingLearnedFile)
        advancedBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    // Функции для уровня nativelike:
    
    private var nativelikeKnewAlreadyFile: URL {
        documentDirectory
            .appendingPathComponent("nativelikeKnewAlreadyFile")
            .appendingPathExtension(for: .json)
    }
  
    func nativelikeKnewAlreadySave() throws {
        let data = try JSONEncoder().encode(nativelikeKnewAlready)
        try data.write(to: nativelikeKnewAlreadyFile)
    }
    
    func nativelikeKnewAlreadyLoad() throws {
      guard FileManager.default.isReadableFile(atPath: nativelikeKnewAlreadyFile.path) else { return }
      let data = try Data(contentsOf: nativelikeKnewAlreadyFile)
        nativelikeKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    private var nativelikeBeingLearnedFile: URL {
        documentDirectory
            .appendingPathComponent("nativelikeBeingLearnedFile")
            .appendingPathExtension(for: .json)
    }
  
    func nativelikeBeingLearnedSave() throws {
        let data = try JSONEncoder().encode(nativelikeBeingLearned)
        try data.write(to: nativelikeBeingLearnedFile)
    }
    
    func nativelikeBeingLearnedLoad() throws {
      guard FileManager.default.isReadableFile(atPath: nativelikeBeingLearnedFile.path) else { return }
      let data = try Data(contentsOf: nativelikeBeingLearnedFile)
        nativelikeBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    // Функции для уровня borninengland:
    
    private var borninenglandKnewAlreadyFile: URL {
        documentDirectory
            .appendingPathComponent("borninenglandKnewAlreadyFile")
            .appendingPathExtension(for: .json)
    }
  
    func borninenglandKnewAlreadySave() throws {
        let data = try JSONEncoder().encode(borninenglandKnewAlready)
        try data.write(to: borninenglandKnewAlreadyFile)
    }
    
    func borninenglandKnewAlreadyLoad() throws {
      guard FileManager.default.isReadableFile(atPath: borninenglandKnewAlreadyFile.path) else { return }
      let data = try Data(contentsOf: borninenglandKnewAlreadyFile)
        borninenglandKnewAlready = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    private var borninenglandBeingLearnedFile: URL {
        documentDirectory
            .appendingPathComponent("borninenglandBeingLearnedFile")
            .appendingPathExtension(for: .json)
    }
  
    func borninenglandBeingLearnedSave() throws {
        let data = try JSONEncoder().encode(borninenglandBeingLearned)
        try data.write(to: borninenglandBeingLearnedFile)
    }
    
    func borninenglandBeingLearnedLoad() throws {
      guard FileManager.default.isReadableFile(atPath: borninenglandBeingLearnedFile.path) else { return }
      let data = try Data(contentsOf: borninenglandBeingLearnedFile)
        borninenglandBeingLearned = try JSONDecoder().decode([wordItemNew].self, from: data)
    }
    
    // Сохранение массивов слов и чтение из файла для Discovery
    
    /// Для Elementary
    
    private var elementaryWordsStorageFile: URL {
        documentDirectory
            .appendingPathComponent("elementaryWordsStorageFile")
            .appendingPathExtension(for: .json)
    }
    
    func elementaryWordsStorageSave() throws {
        let data = try JSONEncoder().encode(elementaryWordsStorage)
        try data.write(to: elementaryWordsStorageFile)
    }
    
    func elementaryWordsStorageLoad() throws {
      guard FileManager.default.isReadableFile(atPath: elementaryWordsStorageFile.path) else { return }
      let data = try Data(contentsOf: elementaryWordsStorageFile)
        elementaryWordsStorage = try JSONDecoder().decode([WordItemStruct].self, from: data)
    }
    
    /// Для Beginner
    
    private var beginnerWordsStorageFile: URL {
        documentDirectory
            .appendingPathComponent("beginnerWordsStorageFile")
            .appendingPathExtension(for: .json)
    }
    
    func beginnerWordsStorageSave() throws {
        let data = try JSONEncoder().encode(beginnerWordsStorage)
        try data.write(to: beginnerWordsStorageFile)
    }
    
    func beginnerWordsStorageLoad() throws {
      guard FileManager.default.isReadableFile(atPath: beginnerWordsStorageFile.path) else { return }
      let data = try Data(contentsOf: beginnerWordsStorageFile)
        beginnerWordsStorage = try JSONDecoder().decode([WordItemStruct].self, from: data)
    }
    
    /// Для intermediate
    
    private var intermediateWordsStorageFile: URL {
        documentDirectory
            .appendingPathComponent("intermediateWordsStorageFile")
            .appendingPathExtension(for: .json)
    }
    
    func intermediateWordsStorageSave() throws {
        let data = try JSONEncoder().encode(intermediateWordsStorage)
        try data.write(to: intermediateWordsStorageFile)
    }
    
    func intermediateWordsStorageLoad() throws {
      guard FileManager.default.isReadableFile(atPath: intermediateWordsStorageFile.path) else { return }
      let data = try Data(contentsOf: intermediateWordsStorageFile)
        intermediateWordsStorage = try JSONDecoder().decode([WordItemStruct].self, from: data)
    }
    
    /// Для advanced
    
    private var advancedWordsStorageFile: URL {
        documentDirectory
            .appendingPathComponent("advancedWordsStorageFile")
            .appendingPathExtension(for: .json)
    }
    
    func advancedWordsStorageSave() throws {
        let data = try JSONEncoder().encode(advancedWordsStorage)
        try data.write(to: advancedWordsStorageFile)
    }
    
    func advancedWordsStorageLoad() throws {
      guard FileManager.default.isReadableFile(atPath: advancedWordsStorageFile.path) else { return }
      let data = try Data(contentsOf: advancedWordsStorageFile)
        advancedWordsStorage = try JSONDecoder().decode([WordItemStruct].self, from: data)
    }
    
    /// Для nativelike
    
    private var nativelikeWordsStorageFile: URL {
        documentDirectory
            .appendingPathComponent("nativelikeWordsStorageFile")
            .appendingPathExtension(for: .json)
    }
    
    func nativelikeWordsStorageSave() throws {
        let data = try JSONEncoder().encode(nativelikeWordsStorage)
        try data.write(to: nativelikeWordsStorageFile)
    }
    
    func nativelikeWordsStorageLoad() throws {
      guard FileManager.default.isReadableFile(atPath: nativelikeWordsStorageFile.path) else { return }
      let data = try Data(contentsOf: nativelikeWordsStorageFile)
        nativelikeWordsStorage = try JSONDecoder().decode([WordItemStruct].self, from: data)
    }
    
    /// Для borninengland
    
    private var borninenglandWordsStorageFile: URL {
        documentDirectory
            .appendingPathComponent("borninenglandWordsStorageFile")
            .appendingPathExtension(for: .json)
    }
    
    func borninenglandWordsStorageSave() throws {
        let data = try JSONEncoder().encode(borninenglandWordsStorage)
        try data.write(to: borninenglandWordsStorageFile)
    }
    
    func borninenglandWordsStorageLoad() throws {
      guard FileManager.default.isReadableFile(atPath: borninenglandWordsStorageFile.path) else { return }
      let data = try Data(contentsOf: borninenglandWordsStorageFile)
        borninenglandWordsStorage = try JSONDecoder().decode([WordItemStruct].self, from: data)
    }
    
}

// storedNewWordItems is over

extension storedNewWordItems {
  
    func totalWordCount(for level: String) -> Int {
       
        let count: Int
        
        switch level {
            case "elementary":
                count = elementaryBeingLearned.count
            case "beginner":
                count = beginnerBeingLearned.count
            case "intermediate":
            count = intermediateBeingLearned.count
            print("Checking what's going on \(intermediateBeingLearned)")
            case "advanced":
                count = advancedBeingLearned.count
            case "nativelike":
                count = nativelikeBeingLearned.count
            case "borninengland":
                count = borninenglandBeingLearned.count
            default:
                count =  0
        }
        
            //  print("Level: \(level), Word Count: \(count)")
        return count

    }
    
    // ---Code for saving Quiz progress ---

    private var quizStateFile: URL {
           documentDirectory
               .appendingPathComponent("quizState")
               .appendingPathExtension(for: .json)
       }

    func saveQuizState(_ state: QuizState) throws {
           let data = try JSONEncoder().encode(state)
           try data.write(to: quizStateFile)
    }

    func loadQuizState() throws -> QuizState? {
         guard FileManager.default.isReadableFile(atPath: quizStateFile.path) else { return nil }
         let data = try Data(contentsOf: quizStateFile)
           return try JSONDecoder().decode(QuizState.self, from: data)
       }

    func resetQuizStateForNewSession(completion: @escaping () -> Void) throws {
        let initialState = QuizState(
            currentQuizIndex: 0,
            questionStatuses: [],
            //test
            correctAnswerCount: 0,
            incorrectAnswerCount: 0
        )
        let data = try JSONEncoder().encode(initialState)
        try data.write(to: quizStateFile)
        UserDefaults.standard.set(true, forKey: "justReset")
        completion()
        print("Quiz state has been reset.")
    }

    struct QuizState: Codable {
        var currentQuizIndex: Int
        var questionStatuses: [AnswerStatus]
        //Test
        var correctAnswerCount: Int
        var incorrectAnswerCount: Int
    }

    func isQuizInProgress() -> Bool {
        do {
            if let loadedState = try loadQuizState() {
                return loadedState.currentQuizIndex > 0
            }
        } catch {
            print("Could not determine quiz progress: \(error)")
        }
        return false
    }

    // ---Code for saving Quiz progress ends ---
}




// Отсюда будут браться всякие универсальные вещи типа текущей даты:

class storedStates: ObservableObject {

    let dateFormatter = DateFormatter()
       
       var currentDate: String {
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           return dateFormatter.string(from: Date())
       }
    
}

class cardPositions: ObservableObject, Identifiable {
    
    var x: CGFloat = 0.0
    /// Card y position
    var y: CGFloat = 0.0
    /// Card rotation angle
    var degree: Double = 0.0
    
}

var languageOptionsAsTheySound: [String] = [
    "Ukranian",
    "Russian",
    "Bulgarian",
    "Chinese",
    "Czech",
    "Danish",
    "Dutch",
    "Estonian",
    "Finnish",
    "French",
    "German",
    "Greek",
    "Hungarian",
    "Indonesian",
    "Italian",
    "Japanese",
    "Korean",
    "Latvian",
    "Lithuanian",
    "Norwegian",
    "Polish",
    "Portuguese",
    "Romanian",
    "Slovak",
    "Slovenian",
    "Spanish",
    "Swedish",
    "Turkish"
]

var languageNamesAndTheirIDs = [
    "Ukranian": "ukranian",
    "Russian": "russian",
    "Bulgarian": "bulgarian",
    "Chinese": "chinese",
    "Czech": "czech",
    "Danish": "danish",
    "Dutch": "dutch",
    "Estonian": "estonian",
    "Finnish": "finnish",
    "French": "french",
    "German": "german",
    "Greek": "greek",
    "Hungarian": "hungarian",
    "Indonesian": "indonesian",
    "Italian": "italian",
    "Japanese": "japanese",
    "Korean": "korean",
    "Latvian": "latvian",
    "Lithuanian": "lithuanian",
    "Norwegian": "norwegian",
    "Polish": "polish",
    "Portuguese": "portuguese",
    "Romanian": "romanian",
    "Slovak": "slovak",
    "Slovenian": "slovenian",
    "Spanish": "spanish",
    "Swedish": "swedish",
    "Turkish": "turkish"
]
