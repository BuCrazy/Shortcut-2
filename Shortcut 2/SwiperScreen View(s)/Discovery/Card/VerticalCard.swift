import SwiftUI

enum Direction {
    case up
    case down
}

struct VerticalCard: View {
    
    var word: String
    var flippedWord: String
    var phonetics: String
        
    var cardColor: Color
    var onRemove: () -> Void
    var onSwipe: (Direction) -> Void

    @State private var isDragging: Bool = false
    @State private var degrees: Double = 0.0
    @State private var opacity: Int = 100
    @State private var offset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var color: Color = Color("mainCardBorderColor")
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color("mainCardBG"))
                .frame(minHeight: 173, maxHeight: 235)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 2)
                )
                .cornerRadius(8)
            if degrees.truncatingRemainder(dividingBy: 360) < 180 {
                HStack {
                    Text(word)
                        .font(.system(size: 34))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                .padding(.leading, 20)
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Text(word)
                            .font(.system(size: 34))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 8)
                    
                    HStack {
                        Spacer()
                        Text("[\(phonetics)]")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Spacer()
                            VStack{
                                Text(flippedWord)
                            }
                            .font(.body)
                            .foregroundColor(.white)
                            .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
                            .multilineTextAlignment(.leading)
                            .lineLimit(4)
                            .truncationMode(.tail)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
        .drawingGroup()
        .scaleEffect(scale)
        .offset(y: offset.height)
        .offset(offset)
        .opacity(Double(opacity) / 100.0)
        .padding(.horizontal, 20)
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: -1, z: 0))
        .gesture(
            DragGesture()

                .onEnded { value in
                            let predictedEndOffset = value.predictedEndTranslation
                            let _ = sqrt(pow(predictedEndOffset.width, 2) + pow(predictedEndOffset.height, 2))
                            withAnimation(.linear(duration: 0.4)) {
                                offset = CGSize(width: 0, height: value.translation.height) // Calculate offset based on actual translation
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                swipeCard(height: offset.height)
                                changeColor(height: offset.height)
                                changeOpacity(height: offset.height)
                                
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    changeScale(height: offset.height)
                                }

                            }
                        }
        )
        .onTapGesture {
            withAnimation(.spring()) {
                self.degrees += 180
            }
        }
    }
    
    
    // Function that enables swiping and detecting direction
    func swipeCard(height: CGFloat) {
        switch height {
        case -500...(-80):
            
            // adjusting swipe direction based on rotation
            if degrees.truncatingRemainder(dividingBy: 360) < 180 {
                offset = CGSize(width: 0, height: -300)
            } else {
                offset = CGSize(width: 0, height: -300)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onRemove()
                onSwipe(.up)
            }
        case 80...500:
            if degrees.truncatingRemainder(dividingBy: 360) < 180 {
                offset = CGSize(width: 0, height: 300)
            } else {
                offset = CGSize(width: 0, height: 300)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onRemove()
                onSwipe(.down)
            }
        default:
            offset = .zero
            scale = 1.0
        }
    }
    
    // Function that alows border color chnaging dependin on swipe direction
    func changeColor(height: CGFloat) {
        switch height {
        case -900...(-20):
            color = .green
        case 20...900:
            color = .red
        default:
            color = color
        }
    }
    
    func changeOpacity(height: CGFloat) {
        switch  height {
        case -900...(-20):
            opacity = 0
        case 20...900:
            opacity = 0
        default:
            opacity = 100
        }
    }
    
    // Scale function
    func changeScale(height: CGFloat) {
        let scaleFactor = abs(height) / 200
        scale = max(0.2, 1 - scaleFactor)
    }
    
}

struct VerticalCard_Previews: PreviewProvider {
    static var previews: some View {
        VerticalCard(
            word: "Ukraine",
            flippedWord: "Ukraine",
            phonetics: "/juːˈkreɪn/",
            cardColor: .black,
            onRemove: {},
            onSwipe: { _ in}
        )
    }
}
