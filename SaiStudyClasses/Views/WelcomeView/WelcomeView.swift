import SwiftUI

struct WelcomeView: View {
    
    @State private var bannerResponse: BannerResponse?

    @State var image : String = ""
    @Binding var path : NavigationPath
    var body: some View {
        
        ZStack (alignment: .bottom){
       
            LinearGradient(
                colors: [
                    
                    Color(red: 0.9, green: 0.9, blue: 0.0),
                    .white,
                    Color(red: 0.9, green: 0.9, blue: 0.0)
                
                ],
                startPoint: .top,
                endPoint: .bottom
            ).padding(.bottom,50)
            .ignoresSafeArea()
            
            //VStack(spacing: 0) {
                
                if let imageName = bannerResponse?.data.first?.first,
                   let url = URL(string: bannerResponse!.filesUrl + imageName) {
                    
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }.padding(.bottom,300)
                    //.frame(height: 420)
                }
                /*Image("welcome")
                 .resizable()
                 .scaledToFit()
                 .frame(height: 420)*/
                
                //Spacer()
           // }
            
            /*VStack {
                
                Spacer()
                VStack(spacing: 6) {
                    Text(uiString.WelcomeTitle)
                        .font(.system(size: 52, weight: .heavy))
                        .foregroundColor(uiColor.white)
                    
                    Text(uiString.WelcomeSubTitle)
                        .font(.system(size: 44, weight: .heavy))
                        .foregroundColor(uiColor.white)
                }.padding()
                .background(
                    LinearGradient(colors: [.black.opacity(0.8),.black,.black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                )
                .padding(.bottom, 330)
                
                
                
            }*/

           
            VStack(alignment:.leading,spacing: 16) {
                
                Text(uiString.WelcomeLoginTitle)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(uiColor.black)
                
                Text(uiString.WelcomeLoginSubTitle)
                    .font(.system(size: 20))
                    .foregroundColor(uiColor.black)
                    .multilineTextAlignment(.leading)
                
                Button {
                    path.append(Route.loginNumView)
                    // Login with mobile
                } label: {
                    Text(uiString.WelcomeMobileButton)
                        .foregroundColor(uiColor.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(uiColor.ButtonBlue)
                        .cornerRadius(12)
                }
                
                Button {
                    path.append(Route.loginEmailView)
                    // Login with email
                } label: {
                    Text(uiString.WelcomeEmailButton)
                        .foregroundColor(uiColor.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(uiColor.ButtonBlue)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .background(uiColor.white)
            .cornerRadius(26)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                fetchData()
            }

        }
    }
   
    func fetchData() {
        
        var components = URLComponents(
            string: "https://marinewisdom.com/ajaxcall/api_login_banners"
        )
        
        components?.queryItems = [
            
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
                let decodedResponse = try JSONDecoder().decode(BannerResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.bannerResponse = decodedResponse
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}

