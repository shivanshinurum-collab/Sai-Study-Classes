import SwiftUI
struct myCourse4 : View {
    
    @Binding var path : NavigationPath
    
    var body: some View {
        VStack{
            Text("My Courses")
                .font(.title3)
                .bold()
                .foregroundColor(.black)
                .padding(.top )
            
            ScrollView{
                courseCard4(path: $path)
                courseCard4(path: $path)
            }
        }.background(uiColor.lightSystem)
            
    }
}

