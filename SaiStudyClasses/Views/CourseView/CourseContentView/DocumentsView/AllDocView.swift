import SwiftUI
import WebKit


struct AllDocView: View {
    @Binding var path : NavigationPath
    
    let url: String
    let title : String
    @State private var isLoading = true

    var body: some View {
        HStack{
            Button{
                path.removeLast()
            }label:{
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .font(.title3.bold())
            }
            Spacer()
            Text(title)
                .foregroundColor(.black)
                .lineLimit(0)
                .font(.title2.bold())
            Spacer()
        }.padding()
            //.background(uiColor.ButtonBlue)
        ZStack {
            
            WebView(url: URL(string: url)!, isLoading: $isLoading)

            if isLoading {
                ProgressView("Loading...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
