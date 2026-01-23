
import SwiftUI

#Preview {
    temp()
}

struct temp: View {
    @State var textWidth: CGFloat = 0
    var body: some View {
        
        VStack(spacing: 0){
            Text("ALL")
                .foregroundColor(uiColor.violet)
                .font(.system(size: 19))
                .bold()
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                textWidth = geo.size.width
                            }
                    }
                )
            Rectangle()
                .frame(width: textWidth ,height: 2)
                .foregroundColor(uiColor.violet)
        }
            
        
    }
}
  
