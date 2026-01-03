import SwiftUI
struct CourseContent : View {
    
    
    var body: some View {
        ScrollView{
            VStack(spacing: 15){
                Button{
                    
                }label: {
                    FileView(image: "pdf", name: "New Time Table of Live Classes")
                }.buttonStyle(.plain)
                
                Button{
                    
                }label: {
                    FileView(image: "courseimage", name: "How To Crack B.ED Exam 2026 ! Full Plan")
                }
                
                
                ForEach(0..<8){ i in
                    
                    Button{
                        
                    }label: {
                        FolderView(image: "folder", name: "English", folderNo: "1", fileNo: "2")
                    }
                    
                }
            }
        }
    }
}
