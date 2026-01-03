import SwiftUI
internal import Combine

struct BatchesTabView : View {
    
    @Binding var path : NavigationPath
    
    let allCourses: [CourseModel] = [
        CourseModel(
            title: "ସୁଫଳ 3.0",
            category: .GovtBedExam,
            price: 1749,
            originalPrice: 3199,
            discountText: "Discount upto 55.0%",
            startDate: "Now to 30 Jun 2026",
            imageName: "img1",
            isNew: true
        ),

        CourseModel(
            title: "OSSTET Special Batch",
            category: .OSSTET,
            price: 1299,
            originalPrice: 2499,
            discountText: "Discount upto 48%",
            startDate: "Jan to May 2026",
            imageName: "courseimage",
            isNew: false
        )
    ]

    
    @State var showBottomSheet: Bool = false
    @State var search = ""
    @State var NoOfCourses  = 0
    
    let images = ["img1" , "img2" , "img3"]
    @State var index = 0
    
    @State private var selectedTab : CourseCategory = .All
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var filteredCourses : [CourseModel] {
        if(selectedTab == .All){
            return allCourses
        }
        return allCourses.filter { $0.category == selectedTab}
    }
    
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading,spacing: 15){
                HStack(spacing:10){
                    HStack(spacing: 10){
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 22))
                        TextField("Search for 'courses'...",text: $search)
                            .font(.system(size: 17))
                    }.padding(7)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(.gray)
                    )
                    
                    Button{
                        
                    } label: {
                        Text(" Study ")
                            .foregroundColor(.white)
                    }.padding(7)
                        .background(.violet)
                    .cornerRadius(12)
                }
                
                TabView(selection: $index) {
                    ForEach(0..<images.count , id: \.self){ i in
                        Image(images[i])
                            .resizable()
                            .scaledToFit()
                            .tag(i)
                    }
                }.tabViewStyle(.page)
                    .frame(height: 200)
                    .onReceive(timer) { _ in
                        withAnimation{
                            index = (index + 1 ) % images.count
                        }
                        
                    }
                
                ScrollView(.horizontal , showsIndicators: false) {
                    HStack(spacing: 24){
                        
                        Button{
                            showBottomSheet.toggle()
                        }label:{
                            HStack(spacing: 6){
                                Image(systemName: "line.3.horizontal.decrease")
                                    .foregroundColor(uiColor.black)
                                Text("Filter")
                                    .foregroundColor(uiColor.DarkGrayText)
                                    .font(.system(size: 18))
                            }
                        }
                        ForEach(CourseCategory.allCases , id: \.self) { tab in
                            VStack(spacing:6){
                                Text(tab.rawValue)
                                    .font(.system(size: 15 , weight: .medium))
                                    .foregroundColor(
                                        selectedTab == tab ? uiColor.violetButton : .gray
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut){
                                            selectedTab = tab
                                        }
                                    }
                                Capsule()
                                    .frame(height: 2)
                                    .foregroundColor(uiColor.violetButton)
                                    .opacity(selectedTab == tab ? 1 : 0)
                            }
                        }
                       
                    }
                }
                Text("\(filteredCourses.count) Courses Available")
                    .font(.subheadline)
                    .bold()
                    .padding(.horizontal)
                
                ScrollView{
                    VStack(spacing: 16) {
                        ForEach(filteredCourses) { course in
                            CourseCardView(path: $path,course: course)
                        }
                    }
                }
                
            }.sheet(isPresented: $showBottomSheet) {
                FilterBottomSheet()
                    .presentationDetents([.medium , .large])
                    .presentationDragIndicator(.visible)
            }
            .padding(15)
        }
    }
}

