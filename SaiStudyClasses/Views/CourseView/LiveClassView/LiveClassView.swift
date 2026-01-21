import SwiftUI
struct LiveClassView : View {
    var body: some View {
        VStack{
            HStack{
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80 , height: 80)
                VStack(alignment: .leading){
                    Text("Chemical bonding 6 (Streaming Live)")
                        .font(.subheadline)
                    Text("Live Now")
                        .font(.subheadline)
                        .foregroundColor(uiColor.DarkGrayText)
                }
                Spacer()
                
                Text("LIVE")
                    .padding(5)
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(15)
            }
        }
    }
}
#Preview {
    LiveClassView()
}
