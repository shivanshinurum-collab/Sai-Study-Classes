import SwiftUI

struct MyBatchesView : View{
    
    @Binding var path : NavigationPath
    
    let courses : [batchData] = []
    /*let courses: [CourseModel] = [
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
    ]*/
    
    var body: some View {
        ZStack{
            Color.blue.opacity(0.8)
                .ignoresSafeArea()
            HStack{
                Button{
                    path.removeLast()
                }label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.title)
                }
                Spacer()
                Text("My Batches")
                    .foregroundColor(.white)
                    .font(.title3.bold())
                Spacer()
            }.padding(10)
        }
        .frame(maxWidth: .infinity , maxHeight: 50)
        
        VStack(){
            ScrollView{
                ForEach( courses, id: \.self){ course in
                    Button{
                        path.append(Route.MyCoursesAbout(course: course))
                    }label: {
                        BatchesCardView(image: course.batchImage, titile: course.batchName , active: true)
                    }.buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                }.scrollIndicators(.hidden)
            }.background(Color(.systemGray6))
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct BatchesCardView : View {
    var image : String
    var titile : String
    var active : Bool
    
    var body : some View {
        
        
        HStack{
            Image(image)
                .resizable()
                .frame(width: 120, height: 100)
                .padding(10)
            VStack(alignment: .leading){
                Text(titile)
                    .font(.title2.bold())
                
                if(active){
                    Text("ACTIVE")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding( .vertical ,2)
                        .padding(.horizontal , 10)
                        .background(.blue.opacity(0.8))
                        .cornerRadius(7)
                }
                
            }
            Spacer()
          
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.12),
                    radius: 10, x: 5, y: 5)
            .padding(5)
    }
}
