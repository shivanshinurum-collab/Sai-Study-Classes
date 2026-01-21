import SwiftUI

struct StoreTabView : View {
    
    @State var search : String = ""
    
    var tabs : [String] = [
        "EMBRYOLOGY",
        "UPPER LIMB NOTES",
        "HEADER"
    ]
    
    //@State var Books = 5
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 15){
            HStack(spacing:8){
                HStack(spacing: 10){
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 25))
                    TextField("Search Keyword",text: $search)
                        .font(.system(size: 20))
                }.padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(uiColor.ButtonBlue, lineWidth: 1.6)
                )
                .padding(7)
                .cornerRadius(12)
                    
            }
            
            Divider()
            
            VStack(alignment: .leading , spacing: 20){
                Text("All Categories")
                    .font(.title3.bold())
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(tabs , id: \.self){ tab in
                            Button{
                                
                            }label: {
                                Text(tab)
                                    .foregroundColor(uiColor.DarkGrayText)
                                    .font(.headline)
                            }
                            .padding(9)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(uiColor.DarkGrayText , lineWidth: 1.2)
                            )
                            .padding(5)
                        }
                    }
                }.scrollIndicators(.hidden)
                
                Divider()
                
                VStack(alignment: .leading){
                    Text("Digital Content")
                        .font(.title3.bold())
                    ScrollView{
                        ForEach(tabs , id: \.self){ tab in
                            Button{
                                
                            }label: {
                                StoreItemView()
                            }.buttonStyle(.plain)
                            Divider()
                        }
                    }
                }
                
            }.padding()
        }.padding(8)
    }
}

struct StoreItemView : View  {
    let image = "https://nbg1.your-objectstorage.com/cdnsecure/app2.lmh-ai.in/uploads/batch_image/34b1fe063b8f37ad62e96be1fb4e8d0e.png"
    let title = "MCQ Lower LIMB E-BOOK"
    let price = "199"
    let Oprice = "399"
    var body: some View {
        HStack(spacing: 10){
            AsyncImage(url: URL(string: image)){ img in
                img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
            } placeholder: {
                Image("courseimage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
            }
            
            VStack(alignment: .leading){
                Text(title)
                    .font(.headline.bold())
                
                HStack{
                    Text("₹\(price)")
                        .font(.headline.bold())
                    
                    Text("₹\(Oprice)")
                        .font(.headline)
                        .foregroundColor(uiColor.DarkGrayText)
                }
                Text("EBOOK")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(2)
                    .padding(.horizontal,4)
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(5)
            }
            Spacer()
        }
    }
}

#Preview {
    StoreTabView()
}
