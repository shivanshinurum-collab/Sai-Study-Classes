import SwiftUI
import WebKit

struct AllDocView: View {

    @Binding var path: NavigationPath
    
    

    let download  = true
    let url: String
    let title: String

    @State private var isLoading = true
    @State private var isDownloading = false
    @State private var showToast = false
    
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

                // ⬇️ Download Button
                if download {
                    Button {
                        downloadAndSave()
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .disabled(isDownloading)
                }
            }
            .padding()

            // 🔹 Document Viewer
            ZStack {
                WebView(url: URL(string: url)!, isLoading: $isLoading)

                if isLoading || isDownloading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text(isDownloading ? "Downloading..." : "Loading...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
            }
        }.overlay(
            VStack {
                Spacer()
                
                if showToast {
                    ToastView(message: "Downloaded and saved to your device")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 40)
                }
            }
            .animation(.easeInOut, value: showToast)
        )

        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Download + Save + Open Offline
    private func downloadAndSave() {
        isDownloading = true
        
        DocumentDownloadManager.shared.downloadAndSave(name: title ,remoteURL: url) { localURL in
            DispatchQueue.main.async {
                isDownloading = false
                
                if let localURL {
                    // ✅ Open offline document
                    //path.append(DocumentRoute.offline(localURL))
                    showToast = true
                } else {
                    print(" Download failed")
                }
            }
        }
    }
}

