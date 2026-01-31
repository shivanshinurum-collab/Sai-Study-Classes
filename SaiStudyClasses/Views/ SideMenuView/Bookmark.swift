import SwiftUI
struct Bookmark : View {
    
    @Binding var path: NavigationPath

    let url: String
    let title: String

    @State private var isLoading = true
    
    var body: some View {

        VStack(spacing: 0) {

            // 🔹 Top Bar
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.title3.bold())
                }

                Spacer()

                Text(title)
                    .foregroundColor(.black)
                    .font(.title3.bold())
                    .lineLimit(1)

                Spacer()
            }
            .padding()

            // 🔹 Document Viewer
            ZStack {
                WebView(url: URL(string: url)!, isLoading: $isLoading)

               
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
