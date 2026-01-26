//
//  PlayerControllerContainer.swift
//  yt-player
//
//  Created by Vaibhav Vishwakarma on 25/01/26.
//

import SwiftUI

struct PlayerControllerContainer: UIViewControllerRepresentable {

    let controller: YouTubePlayerViewController

    func makeUIViewController(context: Context) -> YouTubePlayerViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: YouTubePlayerViewController, context: Context) {}
}
