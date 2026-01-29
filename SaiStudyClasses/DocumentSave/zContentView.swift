import SwiftUI
import WebKit
import Foundation

// MARK: - App Launcher View

struct zContentView: View {

    @State private var showPDF = false
    @State private var showDownloads = false

    var body: some View {
        VStack(spacing: 20) {

            Button("Open PDF") {
                showPDF.toggle()
            }
            .font(.title2.bold())

            Button("Downloaded PDFs") {
                showDownloads.toggle()
            }
            .font(.title2.bold())
        }
        .foregroundColor(.black)
        .fullScreenCover(isPresented: $showPDF) {
            zAllDocView()
        }
        .fullScreenCover(isPresented: $showDownloads) {
            zDownloadedDocsView()
        }
    }
}

// MARK: - Online PDF Viewer (Download + Offline)

struct zAllDocView: View {

    @Environment(\.dismiss) private var dismiss

    //let url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    let url = "https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf"
    let title = "Dummy PDF"

    @State private var isLoading = true
    @State private var localURL: URL?

    var body: some View {
        VStack {

            // Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                }

                Spacer()

                Text(title)
                    .font(.title2.bold())

                Spacer()
            }
            .padding()

            ZStack {
                if let localURL {
                    zWebView(url: localURL, isLoading: $isLoading)
                }

                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
        }
        .onAppear {
            loadDocument()
        }
    }

    private func loadDocument() {

        let downloader = zFileDownloader.shared

        // Already saved
        if downloader.fileExists(remoteURL: url) {
            localURL = downloader.localFileURL(for: url)
            isLoading = false
            return
        }

        // Download
        downloader.downloadFile(remoteURL: url) { savedURL in
            DispatchQueue.main.async {
                self.localURL = savedURL
                self.isLoading = false
            }
        }
    }
}

// MARK: - Downloaded Documents List

struct zDownloadedDocsView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var files: [URL] = []
    @State private var selectedFile: URL?
    @State private var showViewer = false

    var body: some View {
        NavigationView {
            List(files, id: \.self) { file in
                Button {
                    selectedFile = file
                    showViewer = true
                } label: {
                    HStack {
                        Image(systemName: "doc.richtext")
                        Text(file.lastPathComponent)
                            .lineLimit(1)
                    }
                }
            }
            .navigationTitle("Downloaded PDFs")
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
            .onAppear {
                files = zFileDownloader.shared.getAllDownloadedFiles()
            }
            .fullScreenCover(isPresented: $showViewer) {
                if let selectedFile {
                    zOfflineDocView(localURL: selectedFile)
                }
            }
        }
    }
}

// MARK: - Offline PDF Viewer

struct zOfflineDocView: View {

    @Environment(\.dismiss) private var dismiss

    let localURL: URL
    @State private var isLoading = true

    var body: some View {
        VStack {

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                }

                Spacer()

                Text(localURL.lastPathComponent)
                    .font(.headline)
                    .lineLimit(1)

                Spacer()
            }
            .padding()

            ZStack {
                zWebView(url: localURL, isLoading: $isLoading)

                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
        }
        .onAppear {
            isLoading = true
            print("📄 Opening OFFLINE file:", localURL.path)
        }
    }
}


// MARK: - File Downloader + Storage

final class zFileDownloader {

    static let shared = zFileDownloader()
    private init() {}

    func localFileURL(for remoteURL: String) -> URL {
        let fileName = URL(string: remoteURL)?.lastPathComponent ?? "document.pdf"
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(fileName)
    }

    func fileExists(remoteURL: String) -> Bool {
        FileManager.default.fileExists(atPath: localFileURL(for: remoteURL).path)
    }

    func downloadFile(remoteURL: String, completion: @escaping (URL?) -> Void) {

        guard let url = URL(string: remoteURL) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { tempURL, _, error in

            guard let tempURL = tempURL, error == nil else {
                completion(nil)
                return
            }

            let localURL = self.localFileURL(for: remoteURL)

            try? FileManager.default.removeItem(at: localURL)

            do {
                try FileManager.default.moveItem(at: tempURL, to: localURL)
                completion(localURL)
            } catch {
                completion(nil)
            }
        }

        task.resume()
    }

    func getAllDownloadedFiles() -> [URL] {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let files = (try? FileManager.default.contentsOfDirectory(
            at: documents,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )) ?? []

        return files.filter { $0.pathExtension.lowercased() == "pdf" }
    }
}

// MARK: - WebView

struct zWebView: UIViewRepresentable {

    let url: URL
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if url.isFileURL {
            webView.loadFileURL(
                url,
                allowingReadAccessTo: url.deletingLastPathComponent()
            )
        } else {
            webView.load(URLRequest(url: url))
        }
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        let parent: zWebView

        init(_ parent: zWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}



/*

import SwiftUI
import WebKit
import Foundation

// MARK: - ContentView (Launcher)

struct zContentView: View {

    @State private var show = false

    var body: some View {
        Button {
            show.toggle()
        } label: {
            Text("Open PDF")
                .font(.title2.bold())
                .foregroundColor(.black)
        }
        .fullScreenCover(isPresented: $show) {
            zAllDocView()
        }
    }
}

// MARK: - AllDocView (PDF Viewer)

struct zAllDocView: View {

    @Environment(\.dismiss) private var dismiss

    let url: String = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    let title: String = "Dummy PDF"

    @State private var isLoading = true
    @State private var localURL: URL?

    var body: some View {

        VStack {
            // Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.title3.bold())
                }

                Spacer()

                Text(title)
                    .foregroundColor(.black)
                    .font(.title2.bold())

                Spacer()
            }
            .padding()

            ZStack {
                if let localURL {
                    zWebView(url: localURL, isLoading: $isLoading)
                }

                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
        }
        .onAppear {
            loadDocument()
        }
    }

    private func loadDocument() {

        let downloader = zFileDownloader.shared

        // Already downloaded → offline open
        if downloader.fileExists(remoteURL: url) {
            localURL = downloader.localFileURL(for: url)
            isLoading = false
            return
        }

        // Download & save
        downloader.downloadFile(remoteURL: url) { savedURL in
            DispatchQueue.main.async {
                self.localURL = savedURL
                self.isLoading = false
            }
        }
    }
}

// MARK: - FileDownloader

final class zFileDownloader {

    static let shared = zFileDownloader()
    private init() {}

    func localFileURL(for remoteURL: String) -> URL {
        let fileName = URL(string: remoteURL)?.lastPathComponent ?? "document.pdf"
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(fileName)
    }

    func fileExists(remoteURL: String) -> Bool {
        FileManager.default.fileExists(atPath: localFileURL(for: remoteURL).path)
    }

    func downloadFile(remoteURL: String, completion: @escaping (URL?) -> Void) {

        guard let url = URL(string: remoteURL) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { tempURL, _, error in

            guard let tempURL = tempURL, error == nil else {
                completion(nil)
                return
            }

            let localURL = self.localFileURL(for: remoteURL)

            try? FileManager.default.removeItem(at: localURL)

            do {
                try FileManager.default.moveItem(at: tempURL, to: localURL)
                completion(localURL)
            } catch {
                completion(nil)
            }
        }

        task.resume()
    }
}

// MARK: - WebView

struct zWebView: UIViewRepresentable {

    let url: URL
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if url.isFileURL {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            webView.load(URLRequest(url: url))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {

        let parent: zWebView

        init(_ parent: zWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}

*/
