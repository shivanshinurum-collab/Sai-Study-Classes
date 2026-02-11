import SwiftUI

struct YoutubePlayerView: View {
    
    // State must be INSIDE the struct
    @State private var isFullscreen = false
    @State private var playerController: YouTubePlayerViewController?
    @State private var showSettings = false
    @State private var settingsState = PlayerSettingsState()
    
    @State private var progress: Double = 0
    @State private var duration: Double = 1

    private let videoHeight: CGFloat = 260
    private let controlBarHeight: CGFloat = 44
    
    let videoId: String

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Video Section
            ZStack(alignment: .bottom) {

                YouTubePlayerWrapper(
                    videoID: videoId,
                    controller: $playerController
                )
                .frame(height: videoHeight)
                .clipped()
                .onChange(of: playerController) {
                    guard let controller = playerController else { return }

                    controller.onProgressUpdate = { current, total in
                        DispatchQueue.main.async {
                            progress = current
                            duration = max(total, 1)
                        }
                    }
                }

                PlayerControlsBar(
                    controller: playerController,
                    progress: $progress,
                    duration: $duration,
                    onFullscreen: { enterFullscreen() },
                    onSettings: { showSettings = true }
                )
            }
            .frame(height: videoHeight + controlBarHeight)
            .background(Color.black)
            .fullScreenCover(isPresented: $isFullscreen) {
                FullscreenPlayerView(
                    controller: playerController,
                    isPresented: $isFullscreen,
                    progress: $progress,
                    duration: $duration
                )
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.white)
        .sheet(isPresented: $showSettings) {
            PlayerSettingsSheet(
                isPresented: $showSettings,
                state: $settingsState,
                controller: playerController
            )
        }
    }

    // MARK: - Fullscreen helper

    private func enterFullscreen() {
        isFullscreen = true
    }
}

