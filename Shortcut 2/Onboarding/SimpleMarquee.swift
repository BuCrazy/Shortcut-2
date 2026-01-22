//
//  SimpleMarquee.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/11/25.
//

import SwiftUI
import Marquee
struct MarqueeItem: Identifiable {
    let id = UUID()
    let word: String
}

struct SimpleMarquee: View {
    @State private var offset: CGFloat = 0
    @State private var animate: Bool = false

    let words: [String]
    let speed: Double
    let movementDirection: String
    
    var body: some View {
            GeometryReader { geometry in
                let wordWidth = geometry.size.width / CGFloat(words.count)
                let totalWidth = wordWidth * CGFloat(words.count) + CGFloat(words.count - 1) * 60
                var firstAnimationArgument: CGFloat {
                    switch movementDirection {
                    case "left":
                        return -totalWidth
                    case "right":
                        return 0
                    default:
                        return -totalWidth
                    }
                }
                var secondAnimationArgument: CGFloat {
                    switch movementDirection {
                    case "left":
                        return 0
                    case "right":
                        return -totalWidth
                    default:
                        return 0
                    }
                }
                HStack(spacing: 17) {
                    ForEach(0..<2, id: \.self) { _ in
                        ForEach(words, id: \.self) { word in
                            ZStack {
                                RoundedRectangle(cornerRadius: 40)
                                    .foregroundColor(Color("surface"))
                                    .frame(height: 37)
                                Text(word)
                                    .fixedSize()
                                    .foregroundColor(Color("secondaryFontColor"))
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(top: 1, leading: 16, bottom: 1, trailing: 16))
                            }
                        }
                    }
                }
                .offset(
                    x: animate ? firstAnimationArgument : secondAnimationArgument
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: true)) {
                        animate.toggle()
                    }
                }
            }
            .frame(height: 40)
            .clipped()
    }
}

//#Preview {
//    SimpleMarquee()
//}

// Mark – Word Arrays
struct LevelWords {
    static let elementaryExamples = [
        "society", "heart", "send", "early", "watch",
        "father", "like", "place", "something", "very",
        "people", "thing", "call", "student", "move",
        "happen", "next", "book", "important", "air"
    ]
    
    static let elementaryExamples2 = [
        "air", "important", "book", "next", "happen",
        "move", "student", "call", "thing", "people",
        "very", "something", "place", "like", "father",
        "watch", "early", "send", "heart", "society"
    ]
    
    static let beginnerExamples = [
        "mention", "fight", "peace", "imagine", "avoid",
        "trip", "owner", "victim", "responsibility", "suffer",
        "successful", "achieve", "improve", "future", "drive",
        "justice", "damage", "disappear", "fruit"
    ]
    
    static let beginnerExamples2 = [
        "society", "fruit", "disappear", "damage", "justice",
        "drive", "future", "improve", "achieve", "successful",
        "suffer", "responsibility", "victim", "owner", "trip",
        "avoid", "imagine", "peace", "fight", "mention"
    ]
    
    static let intermediateExamples = [
        "depart", "twin", "tolerance", "flood", "hike",
        "habit", "flash", "desire", "genuine", "consist",
        "violation", "possess", "craft", "innocent", "blind",
        "flat", "award", "whisper", "agenda", "launch"
    ]
    
    static let intermediateExamples2 = [
        "launch", "agenda", "whisper", "award", "flat",
        "blind", "innocent", "craft", "possess", "violation",
        "consist", "genuine", "desire", "flash", "habit",
        "hike", "flood", "tolerance", "twin", "depart"
    ]
    
    static let advancedExamples = [
        "spine", "pea", "roar", "erupt", "lean",
        "precede", "fulfil", "thrill", "jerk", "decisive",
        "sleek", "obesity", "dusk", "contaminate", "sewer",
        "bypass", "damp", "lizard", "fasten", "slate"
    ]
    
    static let advancedExamples2 = [
        "slate", "fasten", "lizard", "damp", "bypass",
        "sewer", "contaminate", "dusk", "obesity", "sleek",
        "decisive", "jerk", "thrill", "fulfil", "precede",
        "lean", "erupt", "roar", "pea", "spine"
    ]
    
    static let nativelikeExamples = [
        "anticipated", "bunk", "misconduct", "fern", "dread",
        "redeem", "extinct", "ascend", "traverse", "devoid",
        "straddle", "vineyard", "thump", "whim", "sluggish",
        "zeal", "slug", "cradle", "hideous", "shrewd"
    ]
    
    static let nativelikeExamples2 = [
        "shrewd", "hideous", "cradle", "slug", "zeal",
        "sluggish", "whim", "thump", "vineyard", "straddle",
        "devoid", "traverse", "ascend", "extinct", "redeem",
        "dread", "fern", "misconduct", "bunk", "anticipated"
    ]
    
    static let shakespeareExamples = [
        "skid", "spatula", "spooky", "intractable", "maize",
        "privy", "flask", "peck", "courteous", "crackle",
        "lopsided", "twinge", "vagaries", "trifle", "grub",
        "strut", "gawk", "cog", "belch", "dowry"
    ]
    
    static let shakespeareExamples2 = [
        "dowry", "belch", "cog", "gawk", "strut",
        "grub", "trifle", "vagaries", "twinge", "lopsided",
        "crackle", "courteous", "peck", "flask", "privy",
        "maize", "intractable", "spooky", "spatula", "skid"
    ]
}

#Preview {
    SimpleMarquee(words: ["air", "important", "book", "next", "happen",
                          "move", "student", "call", "thing", "people",
                          "very", "something", "place", "like", "father",
                          "watch", "early", "send", "heart", "society"],
                  speed: 70,
                  movementDirection: "left" )
}
