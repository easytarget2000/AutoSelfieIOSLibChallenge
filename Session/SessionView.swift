/*
 Based on Apple AVCam and Google Samples MLKit Vision Example.
 
 See LICENSE folder for licensing information.
 */

import AVFoundation
import UIKit

typealias SessionView = AutoSelfieSessionView

public class AutoSelfieSessionView: UIView {
    
    // MARK: - Sessions
    
    public let session = AutoSelfieSession()
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError(
                "Expected `AVCaptureVideoPreviewLayer` type for layer.Check " +
                    "PreviewView.layerClass implementation."
            )
        }
        return layer
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
        removeOrientationObserver()
    }
    
    private func setup() {
        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.session = session.cameraCaptureSession
        addOrientationObserver()
    }
    
    // MARK: -
    
    public override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // MARK: Device Orientation
    
    private func addOrientationObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleDeviceRotation),
            name: .UIDeviceOrientationDidChange,
            object: nil
        )
    }
    
    private func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: .UIDeviceOrientationDidChange,
            object: nil
        )
    }
    
    @objc func handleDeviceRotation() {
        setPreviewLayerVideoOrientation()
    }
    
    private func setPreviewLayerVideoOrientation() {
        guard let videoPreviewLayerConnection = previewLayer.connection else {
            return
        }
        
        // Abridged...
    }
    
}
