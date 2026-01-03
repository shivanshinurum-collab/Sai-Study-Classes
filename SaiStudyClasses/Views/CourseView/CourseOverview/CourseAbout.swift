import SwiftUI
struct CourseAbout : View {
    
    let course : CourseModel
    
    //var title = "Titile 3.0"
    var goal = "Teaching Exams"
    //var categoy = "Govt B.ED Exams"
    //var image = "courseimage"
    var about = "1) Course Validity - 6 Months (For Odisha Govt B.Ed Entrance Exam Preparation 2026) 2) Here You Get LIVE Class With Recording 3) PDF Notes & Assignment 4) Proper Plan & Guidance & Doubt Clear Session 5) Mock Test & FLT 6) Experienced Teacher With Unique Teaching Tricks"
    //var date = "30-Jun-2026"
    var noFiles = "540"
    var file = "220"
    //var oldPrice = "3199"
    //var price = "1749"
    var convenienceFee = "34.98"
    var gst = "6.30"
    var discount = "1450.0"
    var pay = "1790.28"
    
    @State var coupon : String = ""
    
    var body : some View {
            
            VStack(alignment: .leading,spacing:15){
                Text(course.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(uiColor.black)
                
                HStack{
                    Image(systemName: "circle.fill")
                        .font(.system(size: 7))
                    Text(goal)
                        .font(.system(size: 15))
                    
                    Image(systemName: "circle.fill")
                        .font(.system(size: 7))
                    Text(course.category.rawValue)
                        .font(.system(size: 15))
                }.foregroundColor(uiColor.DarkGrayText)
                
                HStack{
                    Image("pdf")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22,height: 22)
                    Text("PDFs")
                    
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22,height: 22)
                    Text("VIDEOS")
                }
                
                Image(course.imageName)
                    .resizable()
                    .scaledToFit()
                
                Text("About the Course")
                    .font(.title3.bold())
                Text(about)
                    .font(.body)
                
                HStack{
                    Image(systemName: "clock")
                        .font(.system(size: 22))
                    
                    VStack(alignment: .leading){
                        Text(course.startDate)
                            .font(.title2.bold())
                        Text("Batch will be expired in \(course.startDate)")
                    }
                }
                
                HStack{
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22,height: 22)
                    VStack(alignment: .leading){
                        Text("\(noFiles) learning material")
                            .font(.title2 . bold())
                        Text("\(file) files")
                    }
                }
               
                Text("Apply Coupon")
                    .font(.title2 . bold())
                TextField("Enter Coupon Code" , text: $coupon)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(uiColor.lightGrayText, lineWidth: 1.5)
                    )
                Button{
                    
                }label: {
                    Text("Apply Coupon")
                        .foregroundColor(uiColor.white)
                        .bold()
                }
                
                .frame(maxWidth: .infinity)
                    .padding()
                    .background(uiColor.ButtonBlue)
                
            }.padding()
            
            
        
    }
}
