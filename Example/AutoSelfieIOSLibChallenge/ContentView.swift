import AVFoundation.AVCaptureDevice
import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel: ContentViewModel

    private let wrapperView: AutoSelfieWrapperView
    
    init(
        viewModel: ContentViewModel = ContentViewModel(),
        wrapperView: AutoSelfieWrapperView = AutoSelfieWrapperView()
    ) {
        self.viewModel = viewModel
        self.wrapperView = wrapperView
    }
    
    var body: some View {
        ZStack {
            VStack {
                selfieView
                startButton
            }
            resultView
        }
    }
    
}

// MARK: - Views

extension ContentView {
    
    private var selfieView: some View {
        wrapperView.padding()
    }
    
    private var startButton: some View {
        Button("Start") {
            requestCameraAccessAndStartDetection()
        }.padding()
    }
    
    private var resultView: some View {
        Image(uiImage: viewModel.capturedImage)
            .opacity(viewModel.showCapturedImage ? 1 : 0)
    }
    
}

// MARK: - Behaviour

extension ContentView {
    
    // Raised issue #9.
    private func requestCameraAccessAndStartDetection() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else {
                self.startDetection()
                return
            }
            
            DispatchQueue.main.async {
                self.startDetection()
            }
        }
    }
    
    private func startDetection() {
        wrapperView.wrappedView.eventHandler = { event in
            switch event {
            case .imageCapture(let image):
                self.handleImageCapture(image)
            }
        }
        wrapperView.wrappedView.startDetection()
    }
    
    private func handleImageCapture(_ image: UIImage) {
        wrapperView.wrappedView.stopDetection()

        viewModel.capturedImage = image
        viewModel.showCapturedImage = true
    }
    
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
