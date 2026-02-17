import SwiftUI

struct Notification4 : View {
    @Binding var path : NavigationPath
    
    var body: some View {
        HStack {
            Button {
                path.removeLast()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.backSize))
            }.padding(.trailing)

            Text("Notification")
                .foregroundColor(.white)
                .font(.system(size: uiString.titleSize).bold())

            Spacer()
        }
        .padding()
        .background(uiColor.ButtonBlue)
        ScrollView{
            HStack{
                Text("6 new notification")
                    .font(.caption)
                
                Spacer()
                Button{
                    
                }label: {
                    HStack{
                        Image(systemName: "envelope.open")
                        Text("Mark all as read")
                    }.font(.caption)
                }.buttonStyle(.plain)
                
            }.padding(.horizontal)
            .background(.white)
            
            
            ForEach(1..<10){ _ in
                NotificationCard4()
            }
        }.scrollIndicators(.hidden)
            .navigationBarBackButtonHidden(true)
    }
}
