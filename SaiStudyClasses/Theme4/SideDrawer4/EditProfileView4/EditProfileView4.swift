import SwiftUI

struct EditProfileView4 : View {
    @Binding var path :  NavigationPath
    @State var selectTab : Int = 0
    
    var body : some View {
        VStack(alignment: .leading){
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: uiString.backSize))
                    .foregroundColor(.white)
            }
            HStack(spacing:20){
                Button{
                    
                }label: {
                    Image("boy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                }.padding(10)
                    .background(uiColor.lightSystem)
                    .clipShape(.circle)
                    .padding(10)
                
                Text("Test")
                    .foregroundColor(.white)
                    .font(.system(size: uiString.titleSize))
                    .bold()
                
                Spacer()
            }
        }.padding(.horizontal)
        .background(uiColor.ButtonBlue)
            
        
        ScrollView(.horizontal){
            HStack{
                
                Button{
                    selectTab = 0
                }label: {
                    TabButton(head: "INFO", n: 0)
                        .frame(maxWidth: 100)
                }
                
                Button{
                    selectTab = 1
                }label: {
                    TabButton(head: "BATCHES", n: 1)
                        .frame(maxWidth: 100)
                }
                
                Button{
                    selectTab = 2
                }label: {
                    TabButton(head: "COURSES", n: 2)
                        .frame(maxWidth: 100)
                }
                
                Button{
                    selectTab = 3
                }label: {
                    TabButton(head: "PERFORMANCE", n: 3)
                        .frame(maxWidth: 100)
                }
                
                Button{
                    selectTab = 4
                }label: {
                    TabButton(head: "PAYMENTS", n: 4)
                        .frame(maxWidth: 100)
                }
                
                Button{
                    selectTab = 5
                }label: {
                    TabButton(head: "ASSIGNMENTS", n: 5)
                        .frame(maxWidth: 100)
                }
            }
        }.scrollIndicators(.hidden)
        
        ScrollView{
            switch selectTab {
            case 0:
                InfoTab4()
            case 1:
                BatchesTab4()
            case 2:
                CoursesTab4()
            case 3:
                PerformanceTab4()
            case 4:
                PaymentsTab4()
            case 5:
                AssignmentsTab4()
            default:
                EmptyView()
            }
        }.scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
    }
    
    func TabButton(head : String , n : Int) -> some View {
        VStack{
            if selectTab == n {
                Text(head)
                    .foregroundColor(.black)
                    .font(.caption)
                Rectangle()
                    .frame(width: 100 , height: 1)
                    .foregroundColor(uiColor.ButtonBlue)
            }else{
                Text(head)
                    .foregroundColor(.black)
                    .font(.caption)
                Rectangle()
                    .frame(width: 100 , height: 1)
                    .foregroundColor(.white)
            }
        }
    }
    
}
