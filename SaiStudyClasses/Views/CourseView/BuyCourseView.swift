import SwiftUI

struct BuyCourseView : View {
    
    @Binding var path : NavigationPath
    
    let course : batchData
    
    
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
            Text(course.batchName)
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
            CourseOverview(course: course)
        case .content:
            CourseContent(path: $path ,batch_id: course.id)
        case .liveClass:
            LiveClassView()
        }
        
        Spacer()
    }
    
}
