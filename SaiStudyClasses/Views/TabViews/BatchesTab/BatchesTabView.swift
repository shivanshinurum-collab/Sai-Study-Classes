import SwiftUI
import Combine

struct BatchesTabView : View {
    
    @Binding var path : NavigationPath
    let catId = UserDefaults.standard.string(forKey: "categoryId") ?? "0"
    @State var allCourses : [batchData] = []
  
    
    @State var showBottomSheet: Bool = false
    @State var search = ""
    @State var NoOfCourses  = 0
    
    
    @State var index = 0
    @State private var banners: [HomeBannerData] = []
    @State private var fileBaseURL = ""

    
    @State private var selectedTab : CourseCategory = .All
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    /*var filteredCourses : [batchData] {
        if(selectedTab == .All){
            return allCourses
        }
        return allCourses.filter { $0.category == selectedTab}
    }*/
    
    
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
                    ForEach(banners.indices, id: \.self) { i in
                        AsyncImage(
                            url: URL(string: fileBaseURL + banners[i].banner)
                        ) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 200)
                .onReceive(timer) { _ in
                    withAnimation {
                        index = banners.isEmpty ? 0 : (index + 1) % banners.count
                    }
                }

                
                /*TabView(selection: $index) {
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
                        
                    }*/
                
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
                Text("\(allCourses.count) Courses Available")
                    .font(.subheadline)
                    .bold()
                    .padding(.horizontal)
                
                ScrollView{
                    VStack(spacing: 16) {
                        ForEach(allCourses) { course in
                            CourseCardView(path: $path,course: course)
                        }
                    }
                }
                
            }.sheet(isPresented: $showBottomSheet) {
                FilterBottomSheet()
                    .presentationDetents([.medium , .large])
                    .presentationDragIndicator(.visible)
            }.onAppear{
                fetchHomeBanners()
                fetchBatches(catId: Int(catId) ?? 0)
            }
            .padding(15)
        }
    }
    
    func fetchBatches(catId: Int) {

        var components = URLComponents(
            string: "https://marinewisdom.com/api/Home/getBatchByCatSubCat"
        )

        components?.queryItems = [
            URLQueryItem(name: "catId", value: "\(catId)")
            // add more parameters here if needed
            // URLQueryItem(name: "subCatId", value: "12")
        ]

        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else { return }

            do {
                let response = try JSONDecoder().decode(BatchCourse.self, from: data)
                DispatchQueue.main.async {
                    self.allCourses = response.batchData
                }
            } catch {
                print("❌ Decode Error:", error)
            }

        }.resume()
    }
    
    func fetchHomeBanners() {
        guard let url = URL(string: "https://marinewisdom.com/api/home/getHomeBanner") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(HomeBannerModel.self, from: data)
                DispatchQueue.main.async {
                    self.banners = response.data
                    self.fileBaseURL = response.filesUrl
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }

}

