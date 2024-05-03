import SwiftUI
import AVKit
import Shiny

struct AnnotationView: View {
    
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = ""
          
    var id: Int
    var position_now: Int
    var pos: String = ""
    var word: String = ""
    var phonetics: String = ""
    var definition: String = ""
    var collocations: String = ""
    var sentence: String = ""
    var video: String = ""
    var movie: String = ""
    var movie_quote: String = ""
    var dateAdded: Date
    var timesReviewed: Int = 1
    var grade: Int = 1
    var ukranian: String = ""
    var russian: String = ""
    var bulgarian: String = ""
    var chinese: String = ""
    var czech: String = ""
    var danish: String = ""
    var dutch: String = ""
    var estonian: String = ""
    var finnish: String = ""
    var french: String = ""
    var german: String = ""
    var greek: String = ""
    var hungarian: String = ""
    var indonesian: String = ""
    var italian: String = ""
    var japanese: String = ""
    var korean: String = ""
    var latvian: String = ""
    var lithuanian: String = ""
    var norwegian: String = ""
    var polish: String = ""
    var portuguese: String = ""
    var romanian: String = ""
    var slovak: String = ""
    var slovenian: String = ""
    var spanish: String = ""
    var swedish: String = ""
    var turkish: String = ""
    
    // var wordImages: [String] = []
    // @State private var imageOpacity = 0.0
    // @State private var imageScale: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                HStack {
                    Text(word)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .shiny()
                }
                
                HStack {
                    Text("[\(phonetics)]")
                        .opacity(0.8)
                        .padding(.bottom, 8)
                }
                
                HStack {
                    VStack{
                        switch languageCodeForUse {
                            case "ukranian": Text(ukranian)
                            case "russian": Text(russian)
                            case "bulgarian": Text(bulgarian)
                            case "chinese": Text(chinese)
                            case "czech": Text(czech)
                            case "danish": Text(danish)
                            case "dutch": Text(dutch)
                            case "estonian": Text(estonian)
                            case "finnish": Text(finnish)
                            case "french": Text(french)
                            case "german": Text(german)
                            case "greek": Text(greek)
                            case "hungarian": Text(hungarian)
                            case "indonesian": Text(indonesian)
                            case "italian": Text(italian)
                            case "japanese": Text(japanese)
                            case "korean": Text(korean)
                            case "latvian": Text(latvian)
                            case "lithuanian": Text(lithuanian)
                            case "norwegian": Text(norwegian)
                            case "polish": Text(polish)
                            case "portuguese": Text(portuguese)
                            case "romanian": Text(romanian)
                            case "slovak": Text(slovak)
                            case "slovenian": Text(slovenian)
                            case "spanish": Text(spanish)
                            case "swedish": Text(swedish)
                            case "turkish": Text(turkish)
                            default: Text(ukranian)
                        }
                    }
                        .padding(.bottom, 16)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                HStack{
                    VStack{
                        Text(definition)
                    }
                    .padding(.bottom, 16)
                }
                
                HStack{
                    VStack{
                        Text(sentence)
                    }
                    .padding(.bottom, 16)
                }
                
                HStack{
                    VStack{
                        Text(collocations)
                    }
                    .padding(.bottom, 16)
                }

                HStack{
                    VStack{
                        Text(movie)
                    }
                    .padding(.bottom, 16)
                }

                HStack{
                    VStack{
                        Text(movie_quote)
                    }
                    .padding(.bottom, 16)
                }
                
                HStack{
                    VStack{
                        VideoPlayer(player: AVPlayer(url:  URL(string: "\(video)")!))
                            .frame(height: 400)
                    }
                    .padding(.bottom, 16)
                }

                HStack {
                        Text("Times Reviewed")
                        .bold()
                    Spacer()
                        Text("\(timesReviewed)")
                            .multilineTextAlignment(.leading)
                    }
                
                // NOTE:
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(carImages, id: \.self) { imageName in
//                            Image(imageName)
//                                .resizable()
//                                .transition(.scale)
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 300, height: 200)
//                                .cornerRadius(8)
//                                .clipped()
//                                .opacity(imageOpacity)
//                                .scaleEffect(imageScale)
//
//                        }
//                        .onAppear{
//                            withAnimation(.spring()) {
//                                imageOpacity = 1
//                                imageScale = 1
//                            }
//                        }
//                    }
//                }
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
        }
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(
            id: 10,
            position_now: 10,
            pos: "pos",
            word: "word",
            phonetics: "phonetics",
            definition: "definition",
            collocations: "collocations",
            sentence: "sentence",
            video: "video",
            movie: "movie",
            movie_quote: "movie_quote",
            dateAdded: Date(),
            timesReviewed: 1,
            grade: 1,
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
    }
}

