import SwiftUI

struct PaymentHistory : View{
    @Binding var path : NavigationPath
    
    
    var body: some View {
        
        ZStack(alignment: .top){
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                Spacer()
                Text(uiString.PaymentTitle)
                    .font(.system(size: 25).bold())
                    .foregroundColor(.white)
                Spacer()
            }.padding(.horizontal , 15)
            ZStack{
                RoundedRectangle(cornerRadius: 45)
                    .foregroundColor(.white)
                    .ignoresSafeArea()
                    .padding(.top , 70)
                VStack(spacing: 10){
                   
                    Image("noResults")
                    
                }.padding(.top , 100)
            }
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(uiColor.ButtonBlue)
        .navigationBarBackButtonHidden(true)
    }
}



