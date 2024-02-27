import SwiftUI
import WrappingHStack
struct KnowledgeMapView: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    var currentLevelNewItemsMergedSorted: [wordItemNew] {
        switch currentLevelSelected {
            case "elementary":
                return (storedNewWordItemsDataLayer.elementaryKnewAlready + storedNewWordItemsDataLayer.elementaryBeingLearned).sorted { $0.position_now < $1.position_now }
            case "beginner":
                return (storedNewWordItemsDataLayer.beginnerKnewAlready + storedNewWordItemsDataLayer.beginnerBeingLearned).sorted { $0.position_now < $1.position_now }
            case "intermediate":
                return (storedNewWordItemsDataLayer.intermediateKnewAlready + storedNewWordItemsDataLayer.intermediateBeingLearned).sorted { $0.position_now < $1.position_now }
            default:
                return (storedNewWordItemsDataLayer.elementaryKnewAlready + storedNewWordItemsDataLayer.elementaryBeingLearned).sorted { $0.position_now < $1.position_now }
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Knowledge Map")
                            .foregroundColor(Color("MainFontColor"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        HStack{
                            Text("\(currentLevelSelected.capitalized) Level")
                                .foregroundColor(Color("secondaryFontColor"))
                                .font(.system(size: 12))
                            Spacer()
                                .frame(width:0)
                            Text(" • ")
                                .foregroundColor(Color("secondaryFontColor"))
                                .font(.system(size: 12))
                            Spacer()
                                .frame(width:0)
                            Text("All Words")
                                .foregroundColor(Color("secondaryFontColor"))
                                .font(.system(size: 12))
                        }
                    }
                    Spacer()
                    Image("ProgressIcons_KnowledgeMap")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                VStack{
                    VStack {
                        WrappingHStack(alignment: .topLeading, horizontalSpacing: 2, verticalSpacing: 2) {
                            ForEach(currentLevelNewItemsMergedSorted) { index in
                                if index.timesReviewed == 1 && index.consecutiveCorrectRecalls == 0 {
                                    Circle()
                                        .fill(Color("KnowledgeMapCircleRed"))
                                        .frame(width:4, height: 4)
                                } else if index.timesReviewed >= 1 && index.consecutiveCorrectRecalls < 10 {
                                    Circle()
                                        .fill(Color("KnowledgeMapCircleYellow"))
                                        .frame(width:4, height: 4)
                                } else if index.timesReviewed >= 1 && index.consecutiveCorrectRecalls >= 10 {
                                    Circle()
                                        .fill(Color("KnowledgeMapCircleGreen"))
                                        .frame(width:4, height: 4)
                                }
                            }
                            switch currentLevelSelected {
                                case "elementary":
                                    ForEach(storedNewWordItemsDataLayer.elementaryWordsStorage) { index in
                                        Circle()
                                            .fill(Color("KnowledgeMapCircleGrey"))
                                            .frame(width:4, height: 4)
                                    }
                                case "beginner":
                                    ForEach(storedNewWordItemsDataLayer.beginnerWordsStorage) { index in
                                        Circle()
                                            .fill(Color("KnowledgeMapCircleGrey"))
                                            .frame(width:4, height: 4)
                                        }
                                case "intermediate":
                                    ForEach(storedNewWordItemsDataLayer.intermediateWordsStorage) { index in
                                        Circle()
                                            .fill(Color("KnowledgeMapCircleGrey"))
                                            .frame(width:4, height: 4)
                                    }
                                default:
                                    ForEach(storedNewWordItemsDataLayer.elementaryWordsStorage) { index in
                                        Circle()
                                            .fill(Color("KnowledgeMapCircleGrey"))
                                            .frame(width:4, height: 4)
                                }
                            }
                        }
                    }
                    .background(Color("mainCardBG"))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(Color("mainCardBG"))
            .cornerRadius(8)
        }
    }
}
struct KnowledgeMapView_Previews: PreviewProvider {
    static var previews: some View {
        KnowledgeMapView()
            .environmentObject(storedNewWordItems())
    }
}
