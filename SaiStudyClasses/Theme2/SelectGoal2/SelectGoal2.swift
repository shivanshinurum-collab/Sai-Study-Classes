import SwiftUI
struct SelectGoal2 : View {
    
    @Binding var path : NavigationPath
    
    let course = ["Course 1","Course 2", "Course 3", "Course 4"]
    @State var selected = ""
    let head = "INI CET/NEET PG/FMGE"
    
    var body : some View {
            HStack {
                
                Spacer()

                Text("Select Course")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.titleSize).bold())
                    .padding(.bottom)

                Spacer()

            }
            .padding(.horizontal)
            .background(uiColor.ButtonBlue)
        
        VStack(alignment: .leading){
            
            Text(head)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .bold()
            
            ScrollView{
                ForEach(course , id: \.self){ i in
                    VStack{
                        Button{
                            selected = i
                        }label: {
                            HStack{
                                if(selected == i){
                                    Image(systemName: "record.circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(uiColor.ButtonBlue)
                                    Text(i)
                                        .foregroundColor(uiColor.black)
                                        .font(.system(size: 21))
                                }else{
                                    Image(systemName: "circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(uiColor.gray)
                                    Text(i)
                                        .foregroundColor(uiColor.black)
                                        .font(.system(size: 21))
                                }
                            Spacer()
                            }
                            
                            .padding(.vertical,5)
                            
                            
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(uiColor.lightGrayText)
                    }
                }
            }
            
            Button{
                if(selected != ""){
                    UserDefaults.standard.set(selected, forKey: "goal")
                    path.append(Route.HomeTabView2)
                }
            }label: {
                Text("Done")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity , minHeight: 50)
            }.background(uiColor.ButtonBlue)
                .cornerRadius(15)
            
        }.padding(.horizontal)
            .navigationBarBackButtonHidden(true)
    }
}
