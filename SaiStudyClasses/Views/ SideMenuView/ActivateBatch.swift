import SwiftUI


struct ActivateBatch : View{
    @Binding var path : NavigationPath
    @State var BatchCode : String = ""
    
    var body: some View {
        
        ZStack(alignment: .top){
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 30))
                        .foregroundColor(uiColor.white)
                }
                Spacer()
                Text(uiString.BatchTitle)
                    .font(.system(size: 25).bold())
                    .foregroundColor(uiColor.white)
                Spacer()
            }.padding(.horizontal , 15)
            ZStack{
                RoundedRectangle(cornerRadius: 45)
                    .foregroundColor(uiColor.white)
                    .ignoresSafeArea()
                    .padding(.top , 70)
                VStack(spacing: 10){
                   
                    VStack(spacing:25){
                        Text(uiString.BatchHead)
                            .multilineTextAlignment(.center)
                            .bold()
                            .foregroundColor(uiColor.DarkGrayText)
                        
                        TextField(uiString.BatchField , text: $BatchCode)
                            .frame(maxHeight:50)
                            .padding(10)
                            .padding(.horizontal,15)
                            .background(
                                RoundedRectangle(cornerRadius: 11)
                                    .stroke(.black.opacity(0.6),lineWidth: 1)
                            )
                            .padding(.bottom , 30)
                        
                        Button{
                            
                        }label: {
                            Text(uiString.BatchApplyButton)
                                .font(.title3.bold())
                                .foregroundColor(uiColor.white)
                                .padding()
                                .padding(.horizontal , 40)
                                .background(
                                    LinearGradient(colors: [.yellow , .orange], startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(25)
                        }
                        
                        Spacer()
                    }.padding(25)
                    .background(.clear)
                    
                }.padding(.top , 100)
            }
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(uiColor.ButtonBlue)
        .navigationBarBackButtonHidden(true)
            
    }
}




