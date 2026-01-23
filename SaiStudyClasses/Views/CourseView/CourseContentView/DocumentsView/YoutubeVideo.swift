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


