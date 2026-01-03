import SwiftUI
struct AboutCourses: View {
    
    @Binding var path : NavigationPath
    let course : CourseModel
    
    @State var selectedTab : MyCourseModel = .overview
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .font(.title2.bold())
                }
                Spacer()
                Text(course.title)
                    .font(.title3.bold())
                
                Spacer()
            }
            .foregroundColor(uiColor.ButtonBlue)
            .padding(.horizontal)
            Divider()
            ScrollView(.horizontal){
            HStack{
                
                    ForEach(MyCourseModel.allCases , id: \.self) { tab in
                        Button{
                            selectedTab = tab
                        }label: {
                            Text(tab.rawValue)
                                .padding(.vertical , 10)
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
                        }
                        .frame(maxWidth: .infinity)
                    }
                }.padding()
            }.scrollIndicators(.hidden)
            
                .navigationBarBackButtonHidden(true)
            
            
            switch selectedTab {
            case .overview:
                CourseAbout(course: course)
            case .content:
                CourseContent()
            case .liveClass:
                LiveClassView()
            case.testSeries:
                FileView(image: "folder", name: "Tests")
            }
            Spacer()
        }
    }
    
}

