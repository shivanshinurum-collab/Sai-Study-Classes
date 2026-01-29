import SwiftUI

struct CourseAbout: View {

    let batch: Batch
    let batchResponse: getBatchDetailResponse

    var goal = UserDefaults.standard.string(forKey: "categoryName") ?? ""

    @State private var coupon: String = ""
    @State private var couponResponse: CouponModel?

    @State private var selectedPlanID: String?

    
    private var multiPrice: [MultiPrice] {
        batchResponse.multiPrice ?? []
    }

    private var material: Int {
        batchResponse.totalItemsAvailable
    }

    private var files: Int {
        (Int(batchResponse.totalPDF) ?? 0) +
        (Int(batchResponse.totalNotes) ?? 0) +
        (Int(batchResponse.totalVideos) ?? 0)
    }

   
    var body: some View {
        
       /* let multiPrice = batchResponse.multiPrice ?? []
        
        let material = batchResponse.totalItemsAvailable
        let files =
            (Int(batchResponse.totalPDF) ?? 0) +
            (Int(batchResponse.totalNotes) ?? 0) +
            (Int(batchResponse.totalVideos) ?? 0)*/

        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                // MARK: - Title
                Text(batch.batchName)
                    .font(.title2.bold())
                    .foregroundColor(uiColor.black)
                
                // MARK: - Category
                HStack {
                    Image(systemName: "circle.fill").font(.system(size: 7))
                    Text(goal).font(.system(size: 15))
                    
                    Image(systemName: "circle.fill").font(.system(size: 7))
                    Text(batch.subCatName).font(.system(size: 15))
                }
                .foregroundColor(uiColor.DarkGrayText)
                
                // MARK: - Content Type
                HStack {
                    Image("pdf")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    Text("PDFs")
                    
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    Text("VIDEOS")
                }
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity,maxHeight: 1)
                // MARK: - About
                Text("About the Course")
                    .font(.title3.bold())
                
                Text(html.htmlToAttributedString(batch.description))
                    .font(.body)
                
                
                
                
                // MARK: - Expiry
                
                
                
                if batch.durationType == "1" {
                    HStack {
                        Image(systemName: "clock").font(.system(size: 22))
                        VStack(alignment: .leading) {
                            Text("Batch Validity")
                                .font(.title2.bold())
                            Text("You will get the course for \(batch.totalValidity) \(batch.validityIn)")
                        }
                    }
                }
                else if batch.durationType == "2" {
                    HStack {
                        Image(systemName: "clock").font(.system(size: 22))
                        VStack(alignment: .leading) {
                            Text("Batch Validity")
                                .font(.title2.bold())
                            Text("Batch will be expired in \(batch.batchExpiry)")
                        }
                    }
                    
                }
                else if batch.durationType == "3" {
                    HStack {
                        Image(systemName: "clock").font(.system(size: 22))
                        VStack(alignment: .leading) {
                            Text("Batch Validity")
                                .font(.title2.bold())
                            Text("You will get the course for lifetime")
                        }
                    }
                    
                    
                }else if batch.durationType == "4" {
                    PricePlanView(multiPrice: multiPrice)
                   /* HStack {
                        Image(systemName: "clock").font(.system(size: 22))
                        VStack(alignment: .leading) {
                            Text("Batch Validity")
                                .font(.title2.bold())
                            Text("You will get the course for lifetime")
                        }
                    }
                    ForEach(multiPrice) { plan in
                        Button{
                            selectedPlanID = plan.id
                            print("PLAIN ID SELCET",selectedPlanID ?? "")
                        }label:{
                            HStack(spacing: 12) {

                                Image(systemName: selectedPlanID == plan.id
                                      ? "largecircle.fill.circle"
                                      : "circle")
                                    .foregroundColor(
                                        selectedPlanID == plan.id ? uiColor.ButtonBlue : .gray
                                    )

                                Text("\(plan.duration_value ?? "") \(plan.duration_type ?? "") validity")
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(maxWidth: 160, alignment: .leading)
                                    .foregroundColor(.black)

                                Rectangle()
                                    .frame(width: 0.5, height: 25)
                                    .foregroundColor(.gray.opacity(0.4))

                                Text("₹\(plan.course_price ?? "")")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.black)

                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedPlanID == plan.id
                                        ? uiColor.ButtonBlue
                                        : Color.gray.opacity(0.3),
                                        lineWidth: 1.4
                                    )
                            )
                        }
                    }
                    */
                }
                
                // MARK: - Materials
                HStack {
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    
                    VStack(alignment: .leading) {
                        Text("\(material) learning material")
                            .font(.title2.bold())
                        Text("\(files) files")
                    }
                }
                
            }.onAppear {
                if selectedPlanID == nil {
                    selectedPlanID = multiPrice.first?.id
                }
            }

            .padding()
        }
    }


    
    // MARK: - API Call
    func checkCoupon() {

        couponResponse = nil

        var components = URLComponents(
            string: "\(uiString.baseURL)api/v2/Home/appliedCoupon"
        )

        components?.queryItems = [
            URLQueryItem(name: "coupon_code", value: coupon),
            URLQueryItem(name: "batch_id", value: batch.id)
        ]

        guard let url = components?.url else {
            print(" Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print(" API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print(" No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CouponModel.self, from: data)
                print("Response = ",decodedResponse)
                DispatchQueue.main.async {
                    self.couponResponse = decodedResponse
                }
            } catch {
                print(" Decode Error:", error)
            }
        }
        .resume()
    }
}
