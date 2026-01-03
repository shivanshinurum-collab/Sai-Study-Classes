import SwiftUI
struct CourseOverview : View{
    let course : CourseModel

    var convenienceFee = "34.98"
    var gst = "6.30"
    var discount = "1450.0"
    var pay = "1790.28"
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            uiColor.white
                .ignoresSafeArea()
            ScrollView(){
                
                CourseAbout(course: course)
               
                
            }
            .scrollIndicators(.hidden)
            .padding(.bottom , 280)
            VStack{
                VStack(spacing:15){
                    HStack{
                        Text("Base Price")
                        Spacer()
                        Text("₹\(course.originalPrice)")
                        
                    }
                    .font(.headline.bold())
                    .foregroundColor(uiColor.white)
                    
                    
                    HStack{
                        Text("Offer Price")
                        
                        Spacer()
                        Text("₹\(course.price)")
                    }
                    .font(.title3)
                    .bold()
                    .foregroundColor(uiColor.CreamBlueGreen)
                    
                    HStack{
                        Text("Discount")
                        Spacer()
                        Text("₹\(discount)")
                    }.font(.title3)
                        .foregroundColor(.orange.opacity(0.8))
                    
                    HStack{
                        Text("Convenience Fee")
                        Spacer()
                        Text("₹\(convenienceFee)")
                    }.font(.title3)
                        .foregroundColor(uiColor.white)
                    
                    HStack{
                        Text("GST on Convenience (18%)")
                        Spacer()
                        Text("₹\(gst)")
                    }.font(.title3)
                        .foregroundColor(uiColor.white)
                    
                    Button{
                        
                    }label: {
                        Text("Pay ₹ \(pay)")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(uiColor.white)
                    .bold()
                    .font(.title2)
                    .background(uiColor.ButtonBlue)
                    
                }
                .padding()
            }.frame(height: 280)
            .background(uiColor.black)
        }
    }
}
