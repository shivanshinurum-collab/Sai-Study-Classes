import SwiftUI

struct RegisterView : View {
    @State var name : String = ""
    @State var number : String = ""
    @State var referal : String = ""
    
    var body: some View {
        VStack(alignment: .leading , spacing: 25){
            HStack{
                Button{
                    
                }label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.title3.bold())
                }
                Spacer()
            }
            Text("Please enter your details before \ncontinue")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            VStack{
                TextField("Enter Name" , text: $name)
                    .padding()
                    .cornerRadius(10)
                    .background(
                        Rectangle()
                            .stroke(uiColor.DarkGrayText.opacity(0.6) , lineWidth: 1)
                    )
                HStack{
                    Image("flag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30 , height: 30)
                    Image(systemName: "chevron.down")
                    Text("+91 ")
                    TextField("Mobile Number" , text: $number)
                    
                }
                .padding()
                .cornerRadius(10)
                .background(
                    Rectangle()
                        .stroke(uiColor.DarkGrayText.opacity(0.6)  , lineWidth: 1)
                )
                TextField("Referral Code" , text: $referal)
                    .padding()
                    .cornerRadius(10)
                    .background(
                        Rectangle()
                            .stroke(uiColor.DarkGrayText.opacity(0.6)  , lineWidth: 1)
                    )
            }
            Spacer()
            Button{
                
            }label: {
                Text("Cotinue")
            }
            .padding()
            .font(.title2.bold())
            .frame(maxWidth: .infinity, minHeight: 35)
            .foregroundColor(.white)
            .background(uiColor.ButtonBlue)
            .cornerRadius(25)
            .padding(.bottom)
        }.padding(.horizontal , 22)
    }
}
#Preview {
    RegisterView()
}
