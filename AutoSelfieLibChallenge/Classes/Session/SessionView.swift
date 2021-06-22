/*
 Based on Apple AVCam and Google Samples MLKit Vision Example.
 
 See LICENSE folder for licensing information.
 */

import AVFoundation
import UIKit

typealias SessionView = AutoSelfieSessionView

public class AutoSelfieSessionView: UIView {
    
    // MARK: - Values
    
    public let session = AutoSelfieSession()
    
    public override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        // As requested by `layerClass` override.
        layer as! AVCaptureVideoPreviewLayer
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
        previewLayer.session = session.cameraCaptureSession
        addOrientationObserver()
    }
    
    // MARK: - Entry Points
    
    /**
     Starts the camera and continuously feeds the camera frames into a facial recognition system.
     
     Same as calling `session.startDetection()`.
     */
    public func startDetection() {
        session.startDetection()
    }
    
    /**
     Stops the camera and frees its resources. Automatically called when objects of this class are
     deallocated.
     
     Same as calling `session.stopDetection()`.
     */
    public func stopDetection() {
        session.stopDetection()
    }
    
    // MARK: - Lifecycle
    
    // MARK: Device Orientation
    
    private func addOrientationObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleDeviceRotation),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    private func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
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
