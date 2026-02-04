import SwiftUI
import YouTubeiOSPlayerHelper


struct YouTubeVideoView : View {
    let videoId : String
    let title : String
    
    @Binding var path : NavigationPath
    
    var body: some View {
        HStack{
            Button{
                path.removeLast()
            }label:{
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .font(.system(size: uiString.backSize))
            }
            Spacer()
            Text(title)
                .font(.system(size: uiString.titleSize).bold())
                .foregroundColor(.black)
            Spacer()
        }.padding(.horizontal)
        
        
        
        VStack{
            YoutubePlayerView(videoId: videoId)
            //  YouTubePlayerView(videoID: videoId)
            //                        .frame(height: 220)
            //                        .cornerRadius(12)
            //                        .padding()
            Spacer()
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                print("youtube = \(videoId)")
            }
        
    }
}
/*

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
*/

