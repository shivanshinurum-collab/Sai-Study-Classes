import SwiftUI


struct TabNotes2: View {
    
    @Binding var path: NavigationPath
    
    @State var test: [BatchItem2Model] = []
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State var full_url = ""
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                
                ForEach(test ) { index in
                    
                    Button{
                        path.append(Route.TestListView2)
                    }label: {
                        TestSeriesCard2(
                            courseName: index.name ?? "",
                            exams: String(index.totalModule ?? 0),
                            imageURL: "\(full_url)/\(index.image ?? "")",
                            img: "doc"
                        )
                    }.buttonStyle(.plain)
                    
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        .onAppear{
            fetchNotes()
        }
    }
    
    
    func fetchNotes() {
        let course_id = "2" //UserDefaults.standard.string(forKey: "course_id") ?? ""
        
        guard let url = URL(string: "\(apiURL.getNotes2)\(course_id)/3" ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(BatchResponse2Model.self, from: data)
                print("Notes TaB= \(response)")
                DispatchQueue.main.async {
                    self.test = response.allData ?? []
                    self.full_url = response.full_url ?? ""
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}


