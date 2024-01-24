import SwiftUI

enum WordChipLocation {
    case topWords
    case bottomWords
}

struct WordChip: View {
    
    @State var chipWord: String
    var onRemove: () -> Void
    var onSwipe: (Direction) -> Void
    var location: WordChipLocation
    
    @State private var isDragging = false
    @State private var degrees = 0.0
    @State private var opacity = 100
    @State private var offset = CGSize.zero
    
    var body: some View {
        HStack{
            Text(chipWord)
                .foregroundColor(.white)
                .font(Font.custom("Avenir", size: 16))
                .fontWeight(.medium)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color("mainCardBG"))
        .cornerRadius(48)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(Color("mainCardBorderColor"), lineWidth: 1)
        )
        .offset(y: offset.height)
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    switch location {
                    case .topWords:
                        if gesture.translation.height > 0 { // Only allow dragging down for topWords
                                    offset = CGSize(width: 0, height: gesture.translation.height)
                                }
                    case .bottomWords:
                        if gesture.translation.height < 0 { // Only allow dragging up for bottomWords
                                    offset = CGSize(width: 0, height: gesture.translation.height)
                        }
                    }
                    }
                .onEnded { value in
                    let predictedEndOffset = value.predictedEndTranslation
                    let _ = sqrt(pow(predictedEndOffset.width, 2) + pow(predictedEndOffset.height, 2))
                    withAnimation(.linear(duration: 0.2)) {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        swipeWordChip(height: offset.height)
                    }
                }
        )
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            self.offset = CGSize.zero
        }
        
    }
    
    func swipeWordChip(height: CGFloat) {
        switch location {
        case .topWords:
            if height > 80 { // Only allow swipe down for topWords
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    onRemove()
                    onSwipe(.down)
                }
            } else {
                offset = .zero
            }
        case .bottomWords:
            if height < -80 { // Only allow swipe up for bottomWords
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    onRemove()
                    onSwipe(.up)
                }
            } else {
                offset = .zero
            }
        }
    }
}

struct WordChip_Previews: PreviewProvider {
    static var previews: some View {
        WordChip(chipWord: "Stubborn",onRemove: {}, onSwipe: { _ in}, location: WordChipLocation.bottomWords)
    }
}

