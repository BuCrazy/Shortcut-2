import SwiftUI

struct RevisionScreen: View {
    
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    
    var body: some View {
        
        VStack{
            Text("Revision Mode Started")
            Button {
                currentLearningMode = "discovery"
            } label: {
                Text("Continue to Discovery")
            }
        }
    }
}

#Preview {
    RevisionScreen()
}
