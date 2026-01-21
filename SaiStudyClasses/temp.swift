
import SwiftUI
//import AVKit
//import Combine


// MARK: - Shorts Tab View
struct temp: View {
    
    var body: some View {
    }
}
        /*GeometryReader { geo in
            TabView(selection: $manager.currentIndex) {
                ForEach(Array(reels.enumerated()), id: \.offset) { index, reel in
                    ReelVideoView(
                        reel: reel,
                        index: index,
                        manager: manager
                    )
                    .rotationEffect(.degrees(-90))
                    .ignoresSafeArea()
                    .tag(index)
                }
            }
            .rotationEffect(.degrees(90))
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onAppear {
                fetchShorts()
            }
            .onChange(of: manager.currentIndex) { newIndex in
                // Play video when scrolling to new reel
                if newIndex < reels.count {
                    manager.play(url: URL(string: reels[newIndex].videoPath)!)
                }
            }
        }
    }
    
    func fetchShorts() {
        let components = URLComponents(
            string: "https://app2.lmh-ai.in/api/HomeNew/getTestimonial"
        )

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
                let decodedResponse = try JSONDecoder().decode(ShortsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.reels = decodedResponse.testimonialList
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
}

// MARK: - Player Manager
class ReelPlayerManager: ObservableObject {
    let player = AVPlayer()
    @Published var currentIndex: Int = 0
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    
    private var timeObserver: Any?
    
    init() {
        // Loop video when it ends
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.player.seek(to: .zero)
            self?.player.play()
        }
        
        // Observe playback time
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
    
    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }

    func play(url: URL) {
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        
        // Get duration when item is ready
        item.publisher(for: \.status)
            .filter { $0 == .readyToPlay }
            .sink { [weak self] _ in
                if let duration = self?.player.currentItem?.duration.seconds,
                   !duration.isNaN && !duration.isInfinite {
                    self?.duration = duration
                }
            }
            .store(in: &cancellables)
        
        player.play()
    }

    func pause() {
        player.pause()
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime)
    }
    
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Single Reel View
struct ReelVideoView: View {

    let reel: Shorts
    let index: Int

    @ObservedObject var manager: ReelPlayerManager
    @State private var isPlaying = true
    @State private var showPlayButton = false

    var body: some View {
        ZStack {
            // Video Player
            Color.black
                .ignoresSafeArea()
            
            VideoPlayer(player: manager.player)
                .disabled(true) // Disable default controls
                //.aspectRatio(9/16, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.clipped()
            
            // Tap gesture overlay
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if isPlaying {
                            manager.pause()
                            showPlayButton = true
                        } else {
                            manager.player.play()
                            showPlayButton = false
                        }
                        isPlaying.toggle()
                    }
                }
            
            // Video Timeline
            VStack {
                Spacer()
                
                VideoTimeline(
                    currentTime: manager.currentTime,
                    duration: manager.duration,
                    onSeek: { time in
                        manager.seek(to: time)
                    }
                )
                .padding(.horizontal, 56)
                .padding(.bottom, 40)
            }
            
            // Center Play/Pause Button
            if showPlayButton {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10)
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        // Auto-hide play button after 0.5 seconds
                        if !isPlaying {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    showPlayButton = false
                                }
                            }
                        }
                    }
            }
        }
        .onAppear {
            if manager.currentIndex == index {
                manager.play(url: URL(string: reel.videoPath)!)
                isPlaying = true
            }
        }
        .onDisappear {
            manager.pause()
            isPlaying = false
        }
    }
}

// MARK: - Video Timeline Component
struct VideoTimeline: View {
    let currentTime: Double
    let duration: Double
    let onSeek: (Double) -> Void
    
    @State private var isDragging = false
    @State private var dragValue: Double = 0
    
    var body: some View {
        VStack(spacing: 4) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 3)
                    
                    // Progress track
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: progressWidth(in: geometry.size.width), height: 3)
                }
                .cornerRadius(1.5)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let progress = min(max(0, value.location.x / geometry.size.width), 1)
                            dragValue = progress * duration
                        }
                        .onEnded { value in
                            isDragging = false
                            let progress = min(max(0, value.location.x / geometry.size.width), 1)
                            let seekTime = progress * duration
                            onSeek(seekTime)
                        }
                )
            }
            .frame(height: 3)
            
            // Time labels
            HStack {
                Text(timeString(from: isDragging ? dragValue : currentTime))
                    .font(.caption2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(timeString(from: duration))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
    
    private func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        guard duration > 0 else { return 0 }
        let progress = isDragging ? (dragValue / duration) : (currentTime / duration)
        return totalWidth * CGFloat(progress)
    }
    
    private func timeString(from seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "0:00" }
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}
*/
