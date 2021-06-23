import AVFoundation.AVCaptureDevice
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            selfieView
            startButton
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    
    private var selfieView: AutoSelfieWrapperView {
        AutoSelfieWrapperView()
    }
    
    private var startButton: some View {
        Button("Start") {
            requestCameraAccessAndStartDetection()
        }
    }
    
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
        selfieView.wrappedView.startDetection()
    }
}
