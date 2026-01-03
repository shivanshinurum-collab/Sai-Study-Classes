import SwiftUI

struct RegisterLocationView : View {
    @State var state : String = ""
    @State var city : String = ""
    var body: some View{
        VStack{
            ZStack{
                uiColor.ButtonBlue
                    .ignoresSafeArea(edges: .top)
                
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(uiColor.white)
                    }
                    
                    Spacer()
                    
                    Text("Custom Field")
                        .foregroundColor(uiColor.white)
                    
                    Spacer()
                    
                    //Color.clear.frame(width: 24)
                }.font(.title2.bold())
                .padding(.horizontal)
                .padding(.top, 40)
            }.clipShape(
                RoundedCorner(
                    radius: 25,
                    corners: [.bottomLeft, .bottomRight]
                )
            )
            .ignoresSafeArea()
            .frame(height: 60)
            
            
            VStack(alignment: .leading , spacing: 15){
                Text("State*")
                TextField(
                    text: $state, label:{
                        Text("Please enter text")
                            .foregroundColor(uiColor.DarkGrayText)
                    }
                )
                .font(.title3)
                    .foregroundColor(uiColor.DarkGrayText)
                    .padding()
                    .cornerRadius(10)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(uiColor.ButtonBlue , lineWidth: 2)
                    )
                Text("City*")
                TextField(
                    text: $city, label:{
                        Text("Please enter text")
                            .foregroundColor(uiColor.DarkGrayText)
                    }
                )
                .font(.title3)
                    .padding()
                    .cornerRadius(10)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(uiColor.ButtonBlue , lineWidth: 2)
                    )
                    
            }.padding()
                .padding(.horizontal)
            
            
            Spacer()
            
            Button{
                
            }label: {
                Text("Continue")
            }.foregroundColor(.white)
                .font(.title2.bold())
                .padding()
                .frame(maxWidth: .infinity)
                .background(uiColor.ButtonBlue)
                .cornerRadius(25)
                .padding()
        }
    }
}
  

#Preview {
    RegisterLocationView()
}
