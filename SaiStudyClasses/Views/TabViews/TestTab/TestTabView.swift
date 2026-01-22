import SwiftUI

struct TestTabView : View {
    @Binding var path : NavigationPath
    @State var search:String = ""
    
    
    @State var course : [batchData] = []
    
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading,spacing: 15){
                HStack(spacing:10){
                    HStack(spacing: 10){
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 25))
                        TextField(uiString.TestField,text: $search)
                            .font(.system(size: 20))
                    }.padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(.gray)
                    )
                    
                    Button{
                        
                    } label: {
                        Text(uiString.TestFieldButton)
                            .foregroundColor(.white)
                    }.padding(7)
                        .background(.violet)
                    .cornerRadius(12)
                        
                }
                Text("\(course.count) \(uiString.TestSubHeadline)")
                    .bold()
                
                
                    ForEach(course){ i in
                        CourseCardView(path: $path,course : i)
                    }
                
                
                
            }.padding(15)
        }.onAppear{
            fetchBatches()
        }
    }
    
    func fetchBatches() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(
            string: "https://marinewisdom.com/api/Home/getTestSeriesBatch"
        )

        components?.queryItems = [
            URLQueryItem(name: "student_id", value: student_id)
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
                    self.course = response.batchData
                }
            } catch {
                print("❌ Decode Error:", error)
            }

        }.resume()
    }
}

