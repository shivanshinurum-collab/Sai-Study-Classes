import SwiftUI
struct editBasicInfo4 : View {
    var body: some View{
        HStack(spacing: 25){
            Button{
                
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.backSize))
            }
            
            Text("Edit Basic Information")
                .font(.system(size: uiString.titleSize))
                .foregroundColor(.white)
            
            Spacer()
            
            Button{
                
            }label: {
                Text("Save")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.titleSize))
            }
            
        }.padding()
            .background(uiColor.ButtonBlue)
        
        ScrollView{
            
        }
    }
}
#Preview{
    editBasicInfo4()
}
