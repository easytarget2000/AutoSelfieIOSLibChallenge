import AVFoundation.AVCaptureDevice
import SwiftUI

struct ContentView: View {
    
    let wrapperView: AutoSelfieWrapperView
    
    var body: some View {
        VStack {
            selfieView
            startButton
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(wrapperView: AutoSelfieWrapperView())
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
        wrapperView.wrappedView.startDetection()
    }
}
