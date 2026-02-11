import SwiftUI
import Combine

struct TabHome2 : View {
    
    @Binding var path : NavigationPath
    
    @State var index = 0
    @State private var banners: [HomeBannerData] = []
    @State private var fileBaseURL = ""
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView{
            VStack(alignment : .leading){
                Text("PLAY STORE TEAM")
                    .font(.title2)
                    .bold()
                    .foregroundColor(uiColor.black)
                    .padding(.horizontal)
                
                TabView(selection: $index) {
                    ForEach(banners.indices, id: \.self) { i in
                        AsyncImage(
                            url: URL(string: fileBaseURL + banners[i].banner)
                        ) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 200)
                .onReceive(timer) { _ in
                    withAnimation {
                        index = banners.isEmpty ? 0 : (index + 1) % banners.count
                    }
                }
                
            }
            
        }.onAppear{
            fetchHomeBanners()
        }
    }
    
    func fetchHomeBanners() {
        guard let url = URL(string: apiURL.getHomeBanner ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(HomeBannerModel.self, from: data)
                DispatchQueue.main.async {
                    self.banners = response.data
                    self.fileBaseURL = response.filesUrl
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
}
