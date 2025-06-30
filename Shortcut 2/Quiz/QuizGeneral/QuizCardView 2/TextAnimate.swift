//
//  TextAnimate.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 6/26/25.
//

import SwiftUI

struct CustomAnimatedText: View {
    let text: String
    let animationType: AnimationType
    @State private var animatedText: String = ""
    @State private var currentIndex: Int = 0
    @Binding var animationTrigger: Bool
    
    enum AnimationType {
        case typewriter
        case fadeIn
        case scaleByLetter
    }
    
    var body: some View {
        switch animationType {
        case .scaleByLetter:
            ScaleByLetterAnimatedText(text: text, animationTrigger: $animationTrigger)
        default:
            Text(animatedText)
                .font(.system(size: 30, weight: .semibold))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .onAppear {
                    startAnimation()
                }
        }
    }
    
    private func startAnimation() {
        switch animationType {
        case .typewriter:
            startTypewriterAnimation()
        case .fadeIn:
            startFadeInAnimation()
        case .scaleByLetter:
            break // Handled in ScaleByLetterAnimatedText
        }
    }
    
    private func startTypewriterAnimation() {
        animatedText = ""
        currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                animatedText = String(text[..<text.index(after: index)])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func startFadeInAnimation() {
        withAnimation(.easeInOut(duration: 1.0)) {
            animatedText = text
        }
    }
}

struct ScaleByLetterAnimatedText: View {
    let text: String
    @Binding var animationTrigger: Bool

    
    private var letters: [String] {
        text.map { String($0) }
    }
    
    var body: some View {
            FlowLayout {
                ForEach(0..<letters.count, id: \.self) { index in
                    Text(letters[index])
                        .font(.system(size: 16, weight: .semibold, design: .serif))
                        .opacity(animationTrigger ? 1.0 : 0.0)
                        .scaleEffect(animationTrigger ? 1.0 : 0.0)
                        .animation(
                            .easeInOut(duration: 0.2)
                            .delay(Double(index) * 0.015),
                            value: animationTrigger
                        )
                }
            }
            

    }
}

struct WordByWordAnimatedText: View {
    let text: String
    @State private var visibleWords: Int = 0
    
    private var words: [String] {
        text.components(separatedBy: " ")
    }
    
    var body: some View {
        let columns = [GridItem(.flexible(), alignment: .leading)]
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(0..<words.count, id: \.self) { index in
                if index < visibleWords {
                    Text(words[index])
                        .font(.system(size: 30, weight: .semibold))
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text(words[index])
                        .font(.system(size: 30, weight: .semibold))
                        .opacity(0)
                }
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: visibleWords)
        .onAppear {
            startWordAnimation()
        }
    }
    
    private func startWordAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if visibleWords < words.count {
                visibleWords += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct FlowLayoutAnimatedText: View {
    let text: String
    @State private var visibleWords: Int = 0
    
    private var words: [String] {
        text.components(separatedBy: " ")
    }
    
    var body: some View {
        FlowLayout {
            ForEach(0..<words.count, id: \.self) { index in
                if index < visibleWords {
                    Text(words[index])
                        .font(.system(size: 30, weight: .semibold))
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text("")
                        .font(.system(size: 30, weight: .semibold))
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: visibleWords)
        .onAppear {
            startWordAnimation()
        }
    }
    
    private func startWordAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if visibleWords < words.count {
                visibleWords += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

// Custom Flow Layout for proper text wrapping
struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions(),
            subviews: subviews
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions(),
            subviews: subviews
        )
        for (index, subview) in subviews.enumerated() {
            if index < result.frames.count {
                subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                        y: bounds.minY + result.frames[index].minY),
                            proposal: ProposedViewSize(result.frames[index].size))
            }
        }
    }
}

struct FlowResult {
    let size: CGSize
    let frames: [CGRect]
    
    init(in bounds: CGSize, subviews: LayoutSubviews) {
        var frames: [CGRect] = []
        var currentPoint = CGPoint.zero
        var lineHeight: CGFloat = 0
        let spacing: CGFloat = 0
        
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            
            if currentPoint.x + subviewSize.width > bounds.width && currentPoint.x > 0 {
                // Move to next line
                currentPoint.x = 0
                currentPoint.y += lineHeight + 4
                lineHeight = 0
            }
            
            frames.append(CGRect(origin: currentPoint, size: subviewSize))
            
            currentPoint.x += subviewSize.width + spacing
            lineHeight = max(lineHeight, subviewSize.height)
        }
        
        self.frames = frames
        self.size = CGSize(
            width: bounds.width,
            height: currentPoint.y + lineHeight
        )
    }
}
