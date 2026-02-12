import SwiftUI
struct NotesModel2 : Codable , Hashable {
    let name :String
    let question : String
    let date : String
}
struct NotesListView2 : View {
    @Binding var path : NavigationPath
    
    let name : String = "UPSC Test Series"
    let test : [NotesModel2] = [
        NotesModel2(name: "UPSC TESET 1", question: "120" , date: "2026-06-01 12:15:20"),
        NotesModel2(name: "UPSC TESET 2", question: "150" , date: "2026-03-02 10:45:20"),
        NotesModel2(name: "UPSC TESET 3", question: "160" , date: "2026-05-04 14:15:20"),
        NotesModel2(name: "UPSC TESET 4", question: "110" , date: "2026-07-07 15:45:20"),
        NotesModel2(name: "UPSC TESET 5", question: "122" , date: "2026-05-08 13:05:20"),
        NotesModel2(name: "UPSC TESET 6", question: "121" , date: "2026-04-09 12:25:20"),
        NotesModel2(name: "UPSC TESET 7", question: "110" , date: "2026-02-07 11:35:20"),
    ]
    var body : some View {
        VStack{
            HStack{
                Button{
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                }
                
                Spacer()
                
                Text(name)
                
                Spacer()
                
            }
            .padding(12)
            .font(.title2)
            .foregroundColor(uiColor.white)
            .background(uiColor.ButtonBlue)
            
            ScrollView{
                ForEach(test , id: \.self){item in
                    TestListItem2(name: item.name, date: item.date, question: item.question)
                    
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}
struct NotesListItem2 : View {
    let name :String
    let date : String
    let question : String
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("\(name)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text("\(question) Questions • \(date)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                
                Image(systemName: "newspaper")
                    .font(.system(size: 18))
                
                Image(systemName: "trophy")
                    .font(.system(size: 18))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.28), radius: 4, x: 0, y: 2)
        .padding(.horizontal,6)
    }
}




