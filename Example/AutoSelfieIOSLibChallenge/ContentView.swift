import AVFoundation.AVCaptureDevice
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel

    let wrapperView: AutoSelfieWrapperView
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(),
            wrapperView: AutoSelfieWrapperView()
        )
    }
}

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
            default:
                break
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
