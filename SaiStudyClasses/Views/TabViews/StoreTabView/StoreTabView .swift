import SwiftUI

struct StoreTabView : View {
    
    @State var search : String = ""
    
    var body: some View {
        VStack{
            HStack(spacing:10){
                HStack(spacing: 10){
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 25))
                    TextField("Search Keyword",text: $search)
                        .font(.system(size: 20))
                }.padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(.gray)
                )
                
                Button{
                    
                } label: {
                    Text(uiString.TestFieldButton)
                        .foregroundColor(.white)
                }.padding(7)
                    .background(.violet)
                .cornerRadius(12)
                    
            }
        }
    }
}

#Preview {
    StoreTabView()
}
