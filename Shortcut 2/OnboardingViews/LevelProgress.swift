import SwiftUI
struct ProgressSegment {
    var startValue: CGFloat
    var endValue: CGFloat
    var color: Color
}
struct ProgressBar: View {
    var segments: [ProgressSegment]
    @State private var animationCompleted: Bool = false
    private var totalEndValue: CGFloat {
        let total = segments.reduce(0) { $0 + $1.endValue }
        return max(total, 1) // Prevent division by zero
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                HStack(spacing: 0) {
                    ForEach(segments.indices) { index in
                        let segment = segments[index]
                        let fullWidth = geometry.size.width
                        let segmentWidth = fullWidth * (segment.endValue / totalEndValue)
                        let startWidth = fullWidth * (segment.startValue / totalEndValue)
                        let animatedWidth = animationCompleted ? segmentWidth : startWidth
                        Rectangle()
                            .foregroundColor(segment.color)
                            .frame(width: animatedWidth, height: geometry.size.height)
                            .animation(.linear(duration: 1.0), value: animationCompleted)
                    }
                }
            }
            .cornerRadius(45.0)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    animationCompleted = true
                }
            }
        }
    }
}
struct LevelProgressView: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    // Отдельные переменные для хранения предыдущих значений шкалы прогресса каждого уровня
    /// Elementary
    @AppStorage("elementaryKnewAlreadyBefore") var elementaryKnewAlreadyBeforeCount: Int = 0
    @AppStorage("elementaryInProgressBefore") var elementaryInProgressBeforeCount: Int = 0
    @AppStorage("elementaryBeingLearnedBefore") var elementaryBeingLearnedBeforeCount: Int = 0
    @AppStorage("elementaryUndiscoveredBefore") var elementaryUndiscoveredBeforeCount: Int = 0
    /// Beginner
    @AppStorage("beginnerKnewAlreadyBefore") var beginnerKnewAlreadyBeforeCount: Int = 0
    @AppStorage("beginnerInProgressBefore") var beginnerInProgressBeforeCount: Int = 0
    @AppStorage("beginnerBeingLearnedBefore") var beginnerBeingLearnedBeforeCount: Int = 0
    @AppStorage("beginnerUndiscoveredBefore") var beginnerUndiscoveredBeforeCount: Int = 0
    /// Intermediate
    @AppStorage("intermediateKnewAlreadyBefore") var intermediateKnewAlreadyBeforeCount: Int = 0
    @AppStorage("intermediateInProgressBefore") var intermediateInProgressBeforeCount: Int = 0
    @AppStorage("intermediateBeingLearnedBefore") var intermediateBeingLearnedBeforeCount: Int = 0
    @AppStorage("intermediateUndiscoveredBefore") var intermediateUndiscoveredBeforeCount: Int = 0
    // Значения суммы слов уровня для каждого уровня
    /// Для Elementary
    var elementaryWordTotalCount: Int = 500
    var elementaryKnewAlreadyCount: Int {
        return storedNewWordItemsDataLayer.elementaryKnewAlready.count + storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
            item.timesReviewed >= 10
        }.count
    }
    var elementaryInProgressCount: Int {
        storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
            item.timesReviewed >= 2 && item.timesReviewed < 10
        }.count
    }
    var elementaryBeingLearnedCount: Int {
        storedNewWordItemsDataLayer.elementaryBeingLearned.filter { item in
            item.timesReviewed == 1
        }.count
    }
    var elementaryUndiscoveredCount: Int {
        return elementaryWordTotalCount - elementaryKnewAlreadyCount - elementaryInProgressCount - elementaryBeingLearnedCount
    }
    /// Для Beginner
    var beginnerWordTotalCount: Int = 1500
    var beginnerKnewAlreadyCount: Int {
        return storedNewWordItemsDataLayer.beginnerKnewAlready.count + storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
            item.timesReviewed >= 10
        }.count
    }
    var beginnerInProgressCount: Int {
        storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
            item.timesReviewed >= 2 && item.timesReviewed < 10
        }.count
    }
    var beginnerBeingLearnedCount: Int {
        storedNewWordItemsDataLayer.beginnerBeingLearned.filter { item in
            item.timesReviewed == 1
        }.count
    }
    var beginnerUndiscoveredCount: Int {
        return beginnerWordTotalCount - beginnerKnewAlreadyCount - beginnerInProgressCount - beginnerBeingLearnedCount
    }
    /// Для Intermediate
    var intermediateWordTotalCount: Int = 3000
    var intermediateKnewAlreadyCount: Int {
        return storedNewWordItemsDataLayer.intermediateKnewAlready.count + storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
            item.timesReviewed >= 10
        }.count
    }
    var intermediateInProgressCount: Int {
        storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
            item.timesReviewed >= 2 && item.timesReviewed < 10
        }.count
    }
    var intermediateBeingLearnedCount: Int {
        storedNewWordItemsDataLayer.intermediateBeingLearned.filter { item in
            item.timesReviewed == 1
        }.count
    }
    var intermediateUndiscoveredCount: Int {
        return intermediateWordTotalCount - intermediateKnewAlreadyCount - intermediateInProgressCount - intermediateBeingLearnedCount
    }
    @State var knewChange: Int = 0
    @State var inProgressChange: Int = 0
    @State var toLearnChange: Int = 0
    @State var undiscoveredChange: Int = 0
    var body: some View {
        VStack{
            switch currentLevelSelected {
            case "elementary":
                ProgressBar(segments: [
                    ProgressSegment(startValue: CGFloat(elementaryKnewAlreadyBeforeCount), endValue: CGFloat(elementaryKnewAlreadyCount), color: .green),
                    ProgressSegment(startValue: CGFloat(elementaryInProgressBeforeCount), endValue: CGFloat(elementaryInProgressCount), color: .orange),
                    ProgressSegment(startValue: CGFloat(elementaryBeingLearnedBeforeCount), endValue: CGFloat(elementaryBeingLearnedCount), color: .red),
                    ProgressSegment(startValue: CGFloat(elementaryUndiscoveredBeforeCount), endValue: CGFloat(elementaryUndiscoveredCount), color: .gray),
                ])
                .frame(height: 20)
            case "beginner":
                ProgressBar(segments: [
                    ProgressSegment(startValue: CGFloat(beginnerKnewAlreadyBeforeCount), endValue: CGFloat(beginnerKnewAlreadyCount), color: .green),
                    ProgressSegment(startValue: CGFloat(beginnerInProgressBeforeCount), endValue: CGFloat(beginnerInProgressCount), color: .orange),
                    ProgressSegment(startValue: CGFloat(beginnerBeingLearnedBeforeCount), endValue: CGFloat(beginnerBeingLearnedCount), color: .red),
                    ProgressSegment(startValue: CGFloat(beginnerUndiscoveredBeforeCount), endValue: CGFloat(beginnerUndiscoveredCount), color: .gray),
                ])
                .frame(height: 20)
            case "intermediate":
                ProgressBar(segments: [
                    ProgressSegment(startValue: CGFloat(intermediateKnewAlreadyBeforeCount), endValue: CGFloat(intermediateKnewAlreadyCount), color: .green),
                    ProgressSegment(startValue: CGFloat(intermediateInProgressBeforeCount), endValue: CGFloat(intermediateInProgressCount), color: .orange),
                    ProgressSegment(startValue: CGFloat(intermediateBeingLearnedBeforeCount), endValue: CGFloat(intermediateBeingLearnedCount), color: .red),
                    ProgressSegment(startValue: CGFloat(intermediateUndiscoveredBeforeCount), endValue: CGFloat(intermediateUndiscoveredCount), color: .gray),
                ])
                .frame(height: 20)
            default:
                ProgressBar(segments: [
                    ProgressSegment(startValue: CGFloat(elementaryKnewAlreadyBeforeCount), endValue: CGFloat(elementaryKnewAlreadyCount), color: .green),
                    ProgressSegment(startValue: CGFloat(elementaryInProgressBeforeCount), endValue: CGFloat(elementaryInProgressCount), color: .orange),
                    ProgressSegment(startValue: CGFloat(elementaryBeingLearnedBeforeCount), endValue: CGFloat(elementaryBeingLearnedCount), color: .red),
                    ProgressSegment(startValue: CGFloat(elementaryUndiscoveredBeforeCount), endValue: CGFloat(elementaryUndiscoveredCount), color: .gray),
                ])
                .frame(height: 20)
            }
            HStack {
                LegendView(label: "Knew", color: .green, change: knewChange)
                LegendView(label: "In progress", color: .orange, change: inProgressChange)
                LegendView(label: "To learn", color: .red, change: toLearnChange)
                LegendView(label: "Undiscovered", color: .gray, change: undiscoveredChange)
            }
        }
        .onAppear{
            storedNewWordItemsDataLayer.initialWordDataLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                switch currentLevelSelected {
                case "elementary":
                    knewChange = elementaryKnewAlreadyCount - elementaryKnewAlreadyBeforeCount
                    inProgressChange = elementaryInProgressCount - elementaryInProgressBeforeCount
                    toLearnChange = elementaryBeingLearnedCount - elementaryBeingLearnedBeforeCount
                    undiscoveredChange = elementaryUndiscoveredCount - elementaryUndiscoveredBeforeCount
                case "beginner":
                    knewChange = beginnerKnewAlreadyCount - beginnerKnewAlreadyBeforeCount
                    inProgressChange = beginnerInProgressCount - beginnerInProgressBeforeCount
                    toLearnChange = beginnerBeingLearnedCount - beginnerBeingLearnedBeforeCount
                    undiscoveredChange = beginnerUndiscoveredCount - beginnerUndiscoveredBeforeCount
                case "intermediate":
                    knewChange = intermediateKnewAlreadyCount - intermediateKnewAlreadyBeforeCount
                    inProgressChange = intermediateInProgressCount - intermediateInProgressBeforeCount
                    toLearnChange = intermediateBeingLearnedCount - intermediateBeingLearnedBeforeCount
                    undiscoveredChange = intermediateUndiscoveredCount - intermediateUndiscoveredBeforeCount
                default:
                    knewChange = elementaryKnewAlreadyCount - elementaryKnewAlreadyBeforeCount
                    inProgressChange = elementaryInProgressCount - elementaryInProgressBeforeCount
                    toLearnChange = elementaryBeingLearnedCount - elementaryBeingLearnedBeforeCount
                    undiscoveredChange = elementaryUndiscoveredCount - elementaryUndiscoveredBeforeCount
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                elementaryKnewAlreadyBeforeCount = elementaryKnewAlreadyCount
                elementaryInProgressBeforeCount = elementaryInProgressCount
                elementaryBeingLearnedBeforeCount = elementaryBeingLearnedCount
                elementaryUndiscoveredBeforeCount = elementaryUndiscoveredCount
                beginnerKnewAlreadyBeforeCount = beginnerKnewAlreadyCount
                beginnerInProgressBeforeCount = beginnerInProgressCount
                beginnerBeingLearnedBeforeCount = beginnerBeingLearnedCount
                beginnerUndiscoveredBeforeCount = beginnerUndiscoveredCount
                intermediateKnewAlreadyBeforeCount = intermediateKnewAlreadyCount
                intermediateInProgressBeforeCount = intermediateInProgressCount
                intermediateBeingLearnedBeforeCount = intermediateBeingLearnedCount
                intermediateUndiscoveredBeforeCount = intermediateUndiscoveredCount
            }
        }
    }
}
struct LegendView: View {
    var label: String
    var color: Color
    var change: Int
    var plus: String {
        if change > 0 {
            return "+"
        } else {
            return ""
        }
    }
    var changeSuccess: String {
        if change != 0 {
            return "\(change)"
        } else {
            return ""
        }
    }
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text("\(label) \(plus)\(changeSuccess)")
                .font(.caption)
        }
    }
}
#Preview {
    LevelProgressView()
        .environmentObject(storedNewWordItems())
}
