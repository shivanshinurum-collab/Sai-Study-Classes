
import SwiftUI

struct ChatsTabView4:View{
    @State var search : String = ""
    var body: some View{
        ScrollView{
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    TextField("Search by name or number",text: $search)
                    
                }.padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                    )
            }.padding()
            
            Rectangle()
                .frame(maxWidth: .infinity , maxHeight: 8)
                .foregroundColor(uiColor.system)
            
            VStack(alignment: .leading){
                Text("Messages")
                    .font(.headline)
                
                ChatTabCard4()
                
            }
            
        }.refreshable {
            print("Refresh")
        }
    }
}
#Preview{
    ChatsTabView4()
}
