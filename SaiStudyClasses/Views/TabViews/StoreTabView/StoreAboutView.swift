import SwiftUI

struct StoreAboutView : View {
    @Binding var path :NavigationPath
    let id : String
    @State var About : [StoreDetail] = []
    @State var Response : StoreDetailResponse?
    
    var body: some View {
        let Detail = About.first
        HStack{
            Button{
                path.removeLast()
            }label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.title2.bold())
            }
            Spacer()
            Text(Detail!.courseName)
                .lineLimit(1)
                .foregroundColor(.white)
                .font(.title3.bold())
            Spacer()
        }
        .padding()
        .background(uiColor.ButtonBlue)
        ZStack(alignment: .bottom){
            ScrollView{
                VStack(alignment: .leading,spacing: 12){
                    Text(Detail!.courseName)
                        .foregroundColor(.black)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                    
                    AsyncImage(url: URL(string: Detail!.courseImage)){ img in
                        img
                            .resizable()
                            .scaledToFit()
                        //.frame(maxWidth: .infinity,minHeight: 300)
                    } placeholder: {
                        Image("courseimage")
                            .resizable()
                            .scaledToFit()
                        //.frame(maxWidth: .infinity,minHeight: 200)
                    }
                    
                    Text("About Content")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                    Text(html.htmlToAttributedString(Detail!.courseDesc))
                        .font(.body)
                    
                }.padding()
            }.padding(.bottom , 200)
            
            VStack(spacing:10){
                HStack{
                    Text("Digital Course Price")
                    Spacer()
                    Text("₹\(Detail?.coursePrice ?? "0")")
                }.foregroundColor(.white)
                HStack(spacing: 5){
                    Text("You Pay")
                        Spacer()
                    Text("₹\(Detail?.coursePrice ?? "0")")
                    Text("₹\(Detail?.coursePrice ?? "0")")
                }.foregroundColor(.white)
                HStack{
                    Text("GST(18%)")
                    Spacer()
                    Text("Including GST")
                }.foregroundColor(.white)
                HStack{
                    Text("Discount")
                    Spacer()
                    Text("₹-49.00")
                }.foregroundColor(uiColor.Error)
                
                Button{
                    
                }label: {
                    Text("Add Shipping Address")
                }.foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(12)
                
            }.padding(.horizontal)
            .frame(height: 200)
            .background(.black)
        }.navigationBarBackButtonHidden(true)
        .onAppear{
            fetchData()
        }
    }
    
    func fetchData() {
        
        var components = URLComponents(
            string: "https://app2.lmh-ai.in/api/HomeNew/getContentDetail"
        )
        
        components?.queryItems = [
            URLQueryItem(name: "digital_id", value: id),
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
                let decodedResponse = try JSONDecoder().decode(StoreDetailResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.About = decodedResponse.storeDetail
                    self.Response = decodedResponse
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}

