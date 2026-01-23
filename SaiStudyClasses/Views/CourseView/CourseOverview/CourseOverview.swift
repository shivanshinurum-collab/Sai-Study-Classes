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
           // uiColor.white
              //  .ignoresSafeArea()
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
            
            if(batchResponse?.purchaseCondition != true){
                //VStack {
                    VStack(spacing: 15) {
                        // Base Price
                        // Simplified Base Price section
                        HStack {
                            Text("Base Price")
                            Spacer()
                            
                            /*Text("₹\(batchPrice)")
                                .font(.system(size: 20).bold())*/
                            ZStack{
                                
                                Text("₹\(batchPrice)")
                                    .font(.system(size: 20).bold())
                                    .foregroundColor(uiColor.white)
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear
                                                .onAppear {
                                                    textWidth = geo.size.width
                                                }
                                        }
                                    )
                                Divider()
                                    .frame(width: textWidth ,height: 2)
                                    .background(.white)
                            }
                            
                            
                            
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
                            if(batch?.batchOfferPrice != "0"){
                                let offerPrice = Int(batch?.batchOfferPrice ?? "0")
                            RazorpayManager.shared.startPayment(
                                amount: offerPrice ?? 0,
                                description: "Test Payment"
                            )
                            }
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
                        .cornerRadius(15)
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .ignoresSafeArea()
                    .background(.black)
               /* }.frame(height: 280)
                    .background(uiColor.black)*/
            }
            
            
        }.onAppear {
            fetchBatches()
        }
    }
    
    func fetchBatches() {
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        var components = URLComponents(
            string: "\(uiString.baseURL)api/Home/getBatchDetail"
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

