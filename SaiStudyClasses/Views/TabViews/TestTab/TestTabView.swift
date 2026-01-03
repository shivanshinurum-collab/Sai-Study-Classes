import SwiftUI

struct TestTabView : View {
    @Binding var path : NavigationPath
    @State var search:String = ""
    
    
    let course : [CourseModel] = [
        CourseModel(title: "Focus 3.0", category: .GovtBedExam, price: 2499, originalPrice: 5999, discountText: "42.0", startDate: "01 Jul 2026", imageName: "img1", isNew: true)
    ]
    
    
    
    
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
        }
    }
}

