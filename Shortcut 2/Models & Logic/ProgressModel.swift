import Foundation
import SwiftUI

struct ActivityLogDataPoint: Identifiable, Equatable {
    
    var id = UUID()
    var dateOfAction: String = ""
    var typeOfAction: String = ""
    
}

class ActivityCalendar: ObservableObject {
    
    // Генерируем текущую дату, которая будет доступна по запросу из переменной currentDate:
    
    let dateFormatter = DateFormatter()

    var currentDate: String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    var currentDayAndMonth: String {
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: Date())
    }
    
    var currentDayOfTheMonth: String {
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: Date())
    }
    
    // Создаём массив ActivityLog, в который данные будут добавляться по структуре ActivityLogDataPoint:
    
    @Published var activityLog = [ActivityLogDataPoint]()
    
    // Создаём словарь, где будут собираться количество любых действий, сделанных за каждый день:
    
    @Published var numberOfActionsPerDay: [String: Int] = [:]
    
    // Функция добавления записи в словарь, где ключ – это дата действия, а значение – количество действий за день. Если сегодняшней даты в словаре нет, то добавляем новую запись, где ключ – сегодняшняя дата, а значение – 0. Если же такая запись уже есть, то тогда наращиваем значение на +1 при каждом новом действии
    
    func logEachAction() {
        if numberOfActionsPerDay[currentDate] == nil {
            numberOfActionsPerDay[currentDate] = 1
        } else {
            numberOfActionsPerDay[currentDate]! += 1
        }
    }
        
    struct DayInfo: Identifiable {
        var id = UUID()
        var date: Date
        var dayName: String
    }
    
    // Function to get dates and day names for the current week
    func getDatesWithDayNames() -> [DayInfo] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        
        let daysToFirstDayOfWeek = -((weekday - calendar.firstWeekday + 7) % 7)
       // let daysToMonday = -((weekday + 5) % 7)
     //   let daysToMonday = (calendar.firstWeekday - weekday) % 7
        let firstDayOfWeek = calendar.date(byAdding: .day, value: daysToFirstDayOfWeek, to: today)!
        
        var datesWithDayNames: [DayInfo] = []
        let daySymbols = calendar.weekdaySymbols
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i, to: firstDayOfWeek)!
            let dayIndex = calendar.component(.weekday, from: date) - 1
          //  let fullDayName = daySymbols[(calendar.component(.weekday, from: date) + 6) % 7]
            let dayName = String(daySymbols[dayIndex].prefix(1))
            let dayInfo = DayInfo(date: date, dayName: dayName)
           
            datesWithDayNames.append(dayInfo)
        }
        print (" Dates with Day Names \(datesWithDayNames)")
        return datesWithDayNames
    }
    
    // Function to convert Date to String
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // Находим день, в который было максимальное количество действий, чтобы использовать её как "рекорд", от которого потом будем отталкиваться, чтобы раскрашивать клетки в календаре:
    
    var highestNumberOfActions: Int {
        numberOfActionsPerDay.values.max() ?? 0
    }
    
    private var documentDirectory: URL {
      try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    private var activityLogFile: URL {
        documentDirectory
            .appendingPathComponent("activityLogFile")
            .appendingPathExtension(for: .json)
    }

    func saveDataToJSON() throws {
        let data = try JSONEncoder().encode(numberOfActionsPerDay)
        try data.write(to: activityLogFile)
    }

    func loadDataFromJSON() throws {
      guard FileManager.default.isReadableFile(atPath: activityLogFile.path) else { return }
      let data = try Data(contentsOf: activityLogFile)
        numberOfActionsPerDay = try JSONDecoder().decode([String: Int].self, from: data)
    }
    
}

extension ActivityCalendar {
    func stringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" 
        return dateFormatter.date(from: dateString)
    }
}
