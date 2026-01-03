/*import SwiftUI

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

*/


/*import SwiftUI
import AVKit

struct VideoView: View {
    let videoURL: String
    let title: String 
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var showControls = true
    @State private var timeObserver: Any?
    @State private var speaker = true
    
    var body: some View {
        ZStack {
            /*Color.black
                .ignoresSafeArea()*/
            
            if isLoading {
                VStack(spacing: 15) {
                    ProgressView()
                        .tint(uiColor.DarkGrayText)
                        .scaleEffect(1.5)
                    Text("Loading Video...")
                        .foregroundColor(uiColor.DarkGrayText)
                        .font(.headline)
                        .padding(.top)
                }
            } else if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("Failed to Load Video")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(error)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Retry") {
                        loadVideo()
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else if let player = player {
                VStack {
                    // Video Player
                    ZStack(alignment: .bottom){
                        VideoPlayerRepresentable(player: player)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showControls.toggle()
                                }
                            }
                            .frame(height: 230)
                        
                        // Custom Controls Overlay
                        if showControls {
                            HStack(spacing: 12){
                                // Play/Pause Button
                                Button {
                                    togglePlayPause()
                                } label: {
                                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                                
                                //Speaker
                                Button{
                                    speaker.toggle()
                                }label: {
                                    Image(systemName: speaker ? "speaker.wave.2.fill" : "speaker.slash.fill" )
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                                
                                Text(formatTime(currentTime))
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                
                                
                                Slider(value: $currentTime, in: 0...max(duration, 1)) { editing in
                                    if !editing {
                                        player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                                    }
                                }
                                .tint(.gray)
                                
                                Text(formatTime(duration))
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                
                                //Setting
                                Button{
                                    
                                }label:{
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                                
                                
                                //HQ
                                Button{
                                    
                                }label:{
                                    Image(systemName: "video.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                            }
                           /* VStack {
                                Spacer()
                                
                                // Progress Bar
                                VStack() {
                                    // Time Labels
                                    HStack {
                                        Text(formatTime(currentTime))
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        
                                        Spacer()
                                        
                                        Text(formatTime(duration))
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal)
                                    
                                    // Progress Slider
                                    Slider(value: $currentTime, in: 0...max(duration, 1)) { editing in
                                        if !editing {
                                            player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                                        }
                                    }
                                    .tint(.red)
                                    .padding(.horizontal)
                                }
                                
                                // Control Buttons
                                HStack(spacing: 40) {
                                    // Rewind 10 seconds
                                    Button {
                                        seekVideo(by: -10)
                                    } label: {
                                        Image(systemName: "gobackward.10")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                    
                                    // Play/Pause Button
                                    Button {
                                        togglePlayPause()
                                    } label: {
                                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white)
                                            .shadow(radius: 10)
                                    }
                                    
                                    // Forward 10 seconds
                                    Button {
                                        seekVideo(by: 10)
                                    } label: {
                                        Image(systemName: "goforward.10")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                }
                            }.padding(.bottom)
                            .frame(height: 50, alignment: .bottom)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.7)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .transition(.opacity)*/
                        }
                    }.padding(.bottom)
                        .frame(height: 230)
                    Spacer()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadVideo()
        }
        .onDisappear {
            cleanupPlayer()
        }
    }
    
    func loadVideo() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: videoURL) else {
            errorMessage = "Invalid video URL"
            isLoading = false
            return
        }
        
        print("🎥 Loading video from: \(videoURL)")
        
        let playerItem = AVPlayerItem(url: url)
        let videoPlayer = AVPlayer(playerItem: playerItem)
        
        // Add time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = videoPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            currentTime = time.seconds
            
            if let duration = videoPlayer.currentItem?.duration.seconds, !duration.isNaN {
                self.duration = duration
            }
        }
        
        // Observe when video ends
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            isPlaying = false
            videoPlayer.seek(to: .zero)
            showControls = true
        }
        
        // Wait for video to be ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if playerItem.status == .failed {
                errorMessage = "Failed to load video. Please check your connection."
                isLoading = false
                print("❌ Video failed to load")
            } else {
                self.player = videoPlayer
                isLoading = false
                videoPlayer.play()
                isPlaying = true
                print("✅ Video loaded successfully")
                
                // Auto-hide controls after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showControls = false
                    }
                }
            }
        }
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func seekVideo(by seconds: Double) {
        guard let player = player else { return }
        let newTime = max(0, min(currentTime + seconds, duration))
        currentTime = newTime
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
    }
    
    func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func cleanupPlayer() {
        player?.pause()
        
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
}

// Custom Video Player Representable
struct VideoPlayerRepresentable: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false  // Hide default controls
        controller.videoGravity = .resizeAspect
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
*/

