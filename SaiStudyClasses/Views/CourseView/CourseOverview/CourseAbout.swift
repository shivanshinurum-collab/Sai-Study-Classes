import SwiftUI
struct CourseAbout : View {
    
    @State var batch: Batch
    @State var batchResponse: getBatchDetailResponse
    //let course : batchData
   
    var goal = UserDefaults.standard.string(forKey: "categoryName") ?? ""
   
    
    @State var coupon : String = ""
    
    var body : some View {
        let Material = batchResponse.totalItemsAvailable
        let files = (Int(batchResponse.totalPDF) ?? 0) + (Int(batchResponse.totalNotes) ?? 0) + (Int(batchResponse.totalVideos) ?? 0)
        
        
            VStack(alignment: .leading,spacing:15){
                //Text(course.batchName)
                Text(batch.batchName)
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
                    //Text(course.subcategory)
                    Text(batch.subCatName)
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
                
                /*Image("courseimage")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)*/
                // Image
               /* AsyncImage(url: URL(string: course.batchImage))
                    .fra
               */

                Text("About the Course")
                    .font(.title3.bold())
                Text(html.htmlToAttributedString(batch.description))
                    .font(.body)
                
                HStack{
                    Image(systemName: "clock")
                        .font(.system(size: 22))
                    
                    VStack(alignment: .leading){
                        //Text(course.batchExpiry)
                        Text(batch.batchExpiry)
                            .font(.title2.bold())
                        Text("Batch will be expired in \(batch.batchExpiry)")
                    }
                }
                
                HStack{
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22,height: 22)
                    VStack(alignment: .leading){
                        Text("\(Material) learning material")
                            .font(.title2 . bold())
                        Text("\(files) files")
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
