import SwiftUI
struct temp : View {
   
    var body : some View {
        ZStack{
            uiColor.white
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundColor(uiColor.empty)
        }
    }
}
#Preview {
    temp()
}
