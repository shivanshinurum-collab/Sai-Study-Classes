import SwiftUI


struct TabTestSeries2Model : Codable {
    let courseName : String
    let exam : String
}

struct TabTestSeries2: View {
    
    @Binding var path: NavigationPath
    
    let test: [TabTestSeries2Model] = [
        TabTestSeries2Model(courseName: "UPSC CMS MOCK TEST JANUARY 2026", exam: "20"),
        TabTestSeries2Model(courseName: "UPSC CMS FREE MOCK TESTS", exam: "16"),
        TabTestSeries2Model(courseName: "UPSC CMS MOCK 2", exam: "32"),
        TabTestSeries2Model(courseName: "UPSC CMS MOCK 3", exam: "5"),
        TabTestSeries2Model(courseName: "UPSC CMS MOCK 4", exam: "6"),
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                
                ForEach(test.indices, id: \.self) { index in
                    
                    Button{
                        path.append(Route.TestListView2)
                    }label: {
                        TestSeriesCard2(
                            courseName: test[index].courseName,
                            exams: test[index].exam
                        )
                    }.buttonStyle(.plain)
                    
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
    }
}

