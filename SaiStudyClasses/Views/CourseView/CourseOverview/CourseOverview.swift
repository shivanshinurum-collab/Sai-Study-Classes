import SwiftUI

struct CourseOverview: View {
    let course_id: String
    //let course: batchData
    
    @State var batch: Batch?
    @State var batchResponse: getBatchDetailResponse?
    
    
    @State private var textWidth: CGFloat = 0
    
    var body: some View {
        let batchPrice = Int(batch?.batchPrice ?? "0") ?? 0
        let offerPrice = Int(batch?.batchOfferPrice ?? "0") ?? 0
        ZStack(alignment: .bottom) {
            uiColor.white
                .ignoresSafeArea()
            ScrollView() {
                if let unwrappedBatch = batch, let unwrappedBatchResponse = batchResponse {
                    CourseAbout(batch: unwrappedBatch, batchResponse: unwrappedBatchResponse)//,course: course)
                } else {
                    // ✅ Show loading state
                    VStack {
                        ProgressView()
                        Text("Loading course details...")
                            .foregroundColor(uiColor.DarkGrayText)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, batchResponse?.purchaseCondition ?? false ? 0 : 280)
            /*ScrollView() {
                    CourseAbout(batch: batch, batchResponse: batchResponse, course: course)
                
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 280)
            */
            if(batchResponse?.purchaseCondition != true){
                VStack {
                    VStack(spacing: 15) {
                        // Base Price
                        // Simplified Base Price section
                        HStack {
                            Text("Base Price")
                            Spacer()
                            Text("₹\(batchPrice + offerPrice)")
                                .font(.system(size: 20).bold())
                            
                        }.padding(.top)
                            .font(.headline.bold())
                            .foregroundColor(uiColor.white)
                        
                        // Offer Price
                        HStack {
                            Text("Offer Price")
                            Spacer()
                            Text("₹\(batch?.batchOfferPrice ?? "--")")
                        }
                        .font(.title3)
                        .bold()
                        .foregroundColor(uiColor.CreamBlueGreen)
                        
                        // Discount
                        HStack {
                            Text("Discount")
                            Spacer()
                            if let batchPrice = batch?.batchPrice,
                               let offerPrice = batch?.batchOfferPrice,
                               let price = Int(batchPrice),
                               let offer = Int(offerPrice) {
                                Text("₹\(price - offer)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.title3)
                        .foregroundColor(.orange.opacity(0.8))
                        
                        // Convenience Fee
                        HStack {
                            Text("Convenience Fee")
                            Spacer()
                            Text("₹\(batchResponse?.convenienceFee ?? "0")")
                        }
                        .font(.title3)
                        .foregroundColor(uiColor.white)
                        
                        // GST
                        HStack {
                            Text("GST on Convenience (18%)")
                            Spacer()
                            if let convFee = batchResponse?.convenienceFee,
                               let fee = Double(convFee) {
                                let gst = fee * 0.18
                                Text("₹\(String(format: "%.2f", gst))")
                            } else {
                                Text("₹0.00")
                            }
                        }
                        .font(.title3)
                        .foregroundColor(uiColor.white)
                        
                        // Buy Button
                        Button {
                            //if(batch?.batchOfferPrice != "0"){
                            RazorpayManager.shared.startPayment(
                                amount: 1,
                                description: "Test Payment"
                            )
                            //}
                        } label: {
                            if(batch?.batchOfferPrice == "0") {
                                Text("Free")
                            }else{
                                if //let batchPrice = batch?.batchPrice,
                                    let offerPrice = batch?.batchOfferPrice,
                                    // let price = Int(batchPrice),
                                    let offer = Int(offerPrice),
                                    let convFee = batchResponse?.convenienceFee,
                                    let fee = Double(convFee) {
                                    let gst = fee * 0.18
                                    let total = Double(offer) + fee + gst
                                    Text("₹\(String(format: "%.2f", total))")
                                } else {
                                    Text("Buy Now")
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(uiColor.white)
                        .bold()
                        .font(.title2)
                        .cornerRadius(15)
                        .background(uiColor.ButtonBlue)
                    }
                    .padding(.horizontal)
                }.frame(height: 280)
                    .background(uiColor.black)
            }
            
            
        }.onAppear {
            fetchBatches()
        }
    }
    
    func fetchBatches() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(
            string: "https://marinewisdom.com/api/Home/getBatchDetail"
        )

        components?.queryItems = [
            URLQueryItem(name: "batch_id", value: course_id),  // ✅ Use course.id
            URLQueryItem(name: "student_id", value: student_id)
        ]

        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print("❌ No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(getBatchDetailResponse.self, from: data)
                
                DispatchQueue.main.async {
                    // ✅ Store the response
                    self.batch = decodedResponse.batch
                    self.batchResponse = decodedResponse
                    
                }
            } catch {
                print("❌ Decode Error:", error)
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Missing key:", key.stringValue)
                        print("Context:", context.debugDescription)
                        print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type:", type)
                        print("Context:", context.debugDescription)
                        print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .valueNotFound(let type, let context):
                        print("Value not found for type:", type)
                        print("Context:", context.debugDescription)
                    case .dataCorrupted(let context):
                        print("Data corrupted:", context.debugDescription)
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
            }
        }.resume()
    }
}

/*import SwiftUI
struct CourseOverview : View{
    let course : batchData
    @State var batch : Batch?
    @State var batchResponse : getBatchDetailResponse?
    
    @State var convenienceFee = ""
    @State var GST = ""
    @State var Material : Int = 0
    @State var Files : Int = 0
    
    
    @State private var textWidth: CGFloat = 0
    
    var body: some View {
        
        //let batchPrice = Int(course.batchPrice) ?? 0
       // let offerPrice = Int(course.batchOfferPrice) ?? 0
        
        ZStack(alignment: .bottom){
            uiColor.white
                .ignoresSafeArea()
            ScrollView(){
                
               // CourseAbout(course: batch , Material: Material ,files: Files )
               
                
            }
            .scrollIndicators(.hidden)
            .padding(.bottom , 280)
            VStack{
                VStack(spacing:15){
                    HStack{
                        Text("Base Price")
                        Spacer()
                        ZStack{
                            /*Text(course.currencyDecimalCode + (course.batchPrice + course.batchOfferPrice))*/
                            Text(" \(batch?.batchPrice ?? "")")
                                .font(.system(size: 20).bold())
                                .foregroundColor(uiColor.DarkGrayText)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .onAppear {
                                                textWidth = geo.size.width
                                            }
                                    }
                                )
                            Divider()
                                .frame(width: textWidth ,height: 1)
                                .background(.black)
                        }
                        
                    }
                    .font(.headline.bold())
                    .foregroundColor(uiColor.white)
                    
                    
                    HStack{
                        Text("Offer Price")
                        
                        Spacer()
                        //Text(course.currencyDecimalCode + course.batchOfferPrice)
                        Text(" \(batch?.batchOfferPrice ?? "")")
                    }
                    .font(.title3)
                    .bold()
                    .foregroundColor(uiColor.CreamBlueGreen)
                    
                    HStack{
                        Text("Discount")
                        Spacer()
                        //Text("\(course.currencyDecimalCode)\(batchPrice - offerPrice)")
                        Text(" \(Int(batch!.batchPrice) ?? 0 - Int(batch!.batchOfferPrice)!)")
                    }.font(.title3)
                        .foregroundColor(.orange.opacity(0.8))
                    
                    HStack{
                        Text("Convenience Fee")
                        Spacer()
                        //Text(course.currencyDecimalCode + convenienceFee)
                        Text(" \(batchResponse?.convenienceFee ?? "")")
                    }.font(.title3)
                        .foregroundColor(uiColor.white)
                    
                    HStack{
                        Text("GST on Convenience (18%)")
                        Spacer()
                        //Text(course.currencyDecimalCode + GST)
                        Text(" \(batchResponse?.isGST ?? "")")
                    }.font(.title3)
                        .foregroundColor(uiColor.white)
                    
                    Button{
                        
                    }label: {
                       // Text(course.currencyDecimalCode + course.batchPrice)
                        Text(" \(batch?.batchPrice ?? "")")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(uiColor.white)
                    .bold()
                    .font(.title2)
                    .background(uiColor.ButtonBlue)
                    
                }
                .padding()
            }.onAppear{
                fetchBatches()
            }
            .ignoresSafeArea()
            .frame(height: 280)
            .background(uiColor.black)
        }
    }
    
    
    func fetchBatches() {
        var components = URLComponents(
            string: "https://app2.lmh-ai.in/api/Home/getBatchDetail"
        )

        components?.queryItems = [
            URLQueryItem(name: "batch_id", value: "95"),
            URLQueryItem(name: "student_id", value: "3")
        ]

        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print("❌ No data received")
                return
            }

            // 🔍 Optional: Print raw JSON to debug
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Raw Response:", jsonString)
            }

            do {
                let response = try JSONDecoder().decode(getBatchDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    print("✅ Success! Decoded response")
                    print("📋 Batch Name:", response.batch.batchName)
                    print("💰 Batch Price:", response.batch.batchPrice)
                    print("💵 Offer Price:", response.batch.batchOfferPrice)
                    print("🎫 Convenience Fee:", response.convenienceFee)
                    print("📊 GST:", response.isGST)
                    print("📚 Total Items:", response.totalItemsAvailable)
                    print("📝 Total Exams:", response.totalExam)
                    print("🎥 Total Videos:", response.totalVideos)
                    
                    self.batch = response.batch
                    self.batchResponse = response
                    // Use the response data here
                    /* self.convenienceFee = response.convenienceFee
                     self.GST = response.isGST
                     self.Material = response.totalItemsAvailable
                    
                     let notes = Int(response.totalNotes) ?? 0
                     let pdf = Int(response.totalPDF) ?? 0
                     self.Files = notes + pdf*/
                }
            } catch {
                print("❌ Decode Error:", error)
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Missing key:", key.stringValue)
                        print("Context:", context.debugDescription)
                        print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type:", type)
                        print("Context:", context.debugDescription)
                        print("Coding Path:", context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
                    case .valueNotFound(let type, let context):
                        print("Value not found for type:", type)
                        print("Context:", context.debugDescription)
                    case .dataCorrupted(let context):
                        print("Data corrupted:", context.debugDescription)
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
            }
        }.resume()
    }
    
}
*/
