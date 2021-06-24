/*
 Based on Apple AVCam and Google Samples MLKit Vision Example.
 
 See LICENSE folder for licensing information.
 */

import AVFoundation
import UIKit

typealias SessionView = AutoSelfieSessionView

public class AutoSelfieSessionView: UIView {
    
    // MARK: - Children Types
    
    private enum Constant {
        
        static let backgroundColor = UIColor.black
        
    }
    
    // MARK: - Values
    
    public let session = AutoSelfieSession()
    
    private let targetRectDrawer = TargetRectDrawer()
    
    /**
     Same as accessing `session.eventHandler`.
     */
    public var eventHandler: ((AutoSelfieEvent) -> ())? {
        get { session.eventHandler }
        set { session.eventHandler = newValue }
    }
    
    public override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        // As requested by `layerClass` override.
        layer as! AVCaptureVideoPreviewLayer
    }
    
    var horizontalTargetPadding: Double = 20
    
    var verticalTargetPadding: Double = 80
    
    var targetRect: Rect {
        Rect(
            x1: Double(bounds.minX) + horizontalTargetPadding,
            y1: Double(bounds.minY) + verticalTargetPadding,
            x2: Double(bounds.maxX) - horizontalTargetPadding,
            y2: Double(bounds.maxY) - verticalTargetPadding
        )
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
    
    private func setup() {
        backgroundColor = Constant.backgroundColor
        addOrientationObserver()
    }
    
    // MARK: - Life Cycle
    
    deinit {
        removeOrientationObserver()
    }
    
    // MARK: - Entry Points
    
    /**
     Starts the camera and continuously feeds the camera frames into a facial recognition system.
     Calls `session.startDetection()` and configures this UIView's CALayer for the camera feed.
     */
    public func startDetection() {
        session.viewFinderRect = Rect.fromCG(bounds)
        session.targetRect = targetRect
        session.startDetection()
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = session.cameraCaptureSession
        
        targetRectDrawer.draw(rect: targetRect, in: previewLayer)
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
