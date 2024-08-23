import SwiftUI

struct TopEmptyView: View {
    var body: some View {
        HStack {
            HStack{
                Text("Swipe here the words you know")
                    .foregroundColor(Color("secondaryFontColor")).opacity(0.5)
                    .font(Font.custom("Avenir", size: 16))
                    .fontWeight(.regular)
            }
            .padding(.vertical, 12)
            .cornerRadius(48)
        }
        .padding(.leading, 20)
        .padding(.vertical,16)
    }
}

struct TopEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        TopEmptyView()
    }
}
