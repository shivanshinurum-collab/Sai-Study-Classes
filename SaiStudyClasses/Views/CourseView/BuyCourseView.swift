import SwiftUI

struct BuyCourseView : View {
    
    @Binding var path : NavigationPath
    
    //let course : batchData
    let course_id : String
    let course_name : String
    
    
    @State var selectedTab : CourseAboutTabModel = .overview
    @State var coupon : String = ""
    
    var body: some View {
        HStack{
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .font(.title2.bold())
            }
            Spacer()
            Text(course_name)
                .font(.title3.bold())
            
            Spacer()
        }
        .foregroundColor(uiColor.ButtonBlue)
        .padding(.horizontal)
        Divider()
        HStack{
            ForEach(CourseAboutTabModel.allCases , id: \.self) { tab in
                Button{
                    selectedTab = tab
                }label: {
                    Text(tab.rawValue)
                        .padding(.vertical , 7)
                        .padding(.horizontal)
                        .foregroundColor(
                            selectedTab == tab ? .white : .black
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(
                                    selectedTab == tab
                                    ? uiColor.ButtonBlue
                                    : Color.clear
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    selectedTab == tab
                                    ? Color.clear
                                    : uiColor.DarkGrayText ,
                                    lineWidth: 1
                                )
                        )
                }.frame(maxWidth: .infinity)
            }
           
        }.padding()
        .navigationBarBackButtonHidden(true)
        
        switch selectedTab {
        case .overview:
            CourseOverview(course_id: course_id)
        case .content:
            CourseContent(path: $path ,batch_id: course_id)
        case .liveClass:
            LiveClassView()
        }
        
        Spacer()
    }
    
}
