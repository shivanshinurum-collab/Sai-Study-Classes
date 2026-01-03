import SwiftUI
import YouTubeiOSPlayerHelper


struct YouTubeVideoView : View {
    let videoId : String
    let title : String
    var body: some View {
            Text(title)
            .font(.title2.bold())
                .foregroundColor(uiColor.white)
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                .background(uiColor.ButtonBlue)
                
        VStack{
            YouTubePlayerView(videoID: videoId)
                        .frame(height: 220)
                        .cornerRadius(12)
                        .padding()
            Spacer()
        }
    }
}


struct YouTubePlayerView: UIViewRepresentable {

    let videoID: String

    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.delegate = context.coordinator

        let vars: [String: Any] = [
            "playsinline": 1,
            "controls": 1,
            "modestbranding": 1,
            "autoplay": 1, 
            "rel": 0,
            "fs":1
        ]

        playerView.load(withVideoId: videoID, playerVars: vars)
        return playerView
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, YTPlayerViewDelegate {

        func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
            print("✅ Player Ready")
        }

        func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
            print("Player State:", state.rawValue)
        }
    }
}



/*import SwiftUI
import AVKit
import WebKit

struct VideoView: View {
    let videoURL: String
    let title: String

    var body: some View {
        VStack {
            YouTubePlayerView(videoURL: videoURL)
                .frame(height: 230)
                .cornerRadius(12)

            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NormalVideoPlayer: View {
    let url: String
    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                guard let videoURL = URL(string: url) else { return }
                player = AVPlayer(url: videoURL)
                player?.play()
            }
            .onDisappear {
                player?.pause()
                player = nil
            }
    }
}

struct YouTubePlayerView: UIViewRepresentable {
    let videoURL: String

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        if #available(iOS 14.0, *) {
            config.allowsPictureInPictureMediaPlayback = true
        }

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let videoID = extractVideoID(from: videoURL)

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { 
                    margin: 0; 
                    padding: 0; 
                    box-sizing: border-box;
                }
                html, body { 
                    width: 100%; 
                    height: 100%; 
                    background: black; 
                    overflow: hidden; 
                }
                .container {
                    position: relative;
                    width: 100%;
                    height: 100%;
                }
                iframe { 
                    position: absolute; 
                    top: 0; 
                    left: 0; 
                    width: 100%; 
                    height: 100%; 
                    border: none;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <iframe
                    src="https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=0&controls=1&rel=0&modestbranding=1&enablejsapi=1&origin=https://www.youtube.com"
                    frameborder="0"
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                    allowfullscreen
                    referrerpolicy="strict-origin-when-cross-origin">
                </iframe>
            </div>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube.com"))
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ WebView navigation failed: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("❌ WebView provisional navigation failed: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ WebView finished loading")
        }
    }

    private func extractVideoID(from url: String) -> String {
        // Handle youtu.be format (e.g., https://youtu.be/VIDEO_ID)
        if url.contains("youtu.be") {
            let components = url.components(separatedBy: "/")
            if let last = components.last {
                // Remove query parameters and timestamp if any
                let videoID = last.components(separatedBy: "?").first ?? last
                return videoID.components(separatedBy: "&").first ?? videoID
            }
        }
        
        // Handle youtube.com format (e.g., https://www.youtube.com/watch?v=VIDEO_ID)
        if let urlComponents = URLComponents(string: url) {
            if let videoID = urlComponents.queryItems?.first(where: { $0.name == "v" })?.value {
                return videoID
            }
        }
        
        // Handle youtube.com/embed format
        if url.contains("/embed/") {
            let components = url.components(separatedBy: "/embed/")
            if components.count > 1 {
                return components[1].components(separatedBy: "?").first ?? ""
            }
        }
        
        return ""
    }
}
*/
