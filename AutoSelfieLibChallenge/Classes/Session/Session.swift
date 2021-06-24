import AVFoundation.AVCaptureSession

typealias Session = AutoSelfieSession

/**
 Handles the IO of retrieving the exercise configuration files, captures the camera output, forwards camera
 frame to the internal detection logic and informs the caller of detection results.
 */
public class AutoSelfieSession {
    
    // MARK: - Values
    
    /**
     Defines the size and location within the camera image, in which the recognition is searching for a face to
     decide when to capture an image. The coordinates of this rectangle are in relation to the camera image,
     which in turn may be aligned to `viewFinderRect`. If set to `nil`, no images will be captured.
     */
    public var targetRect: Rect?
    
    /**
     Defines the aspect ratio of the output image, usually set to the _bounds_ of the UIView that is displaying
     the camera feed. The camera often delivers images with an aspect ratio that is different to the display.
     To compensate for this, the image will be cropped to match the aspect ratio of `viewFinderRect`.
     If set to `nil`, the image will not be altered.
     */
    public var viewFinderRect: Rect?
    
    /**
     Callbacks generated after calling `startDetection`.
     */
    public var eventHandler: ((AutoSelfieEvent) -> ())?
    
    /**
     See `eventHandler`. The queue on which the callback closure will be called synchronously.
     Default: main queue.
     */
    public var eventHandlerQueue = DispatchQueue.main
    
    public var cameraCaptureSession: AVCaptureSession? {
        (imageSource as? CameraImageSource)?.captureSession
    }
    
    private let imageSource: ImageSource
    
    private let faceFeedbackGenerator: FaceFeedbackGenerator
    
    // MARK: - Init
    
    /**
     Use this default public initializer as the entry point to the library if you do not wish to use
     `SessionView`.
     */
    public convenience init() {
        self.init(
            imageSource: CameraImageSource(),
            faceFeedbackGenerator: MLKitFaceFeedbackGenerator()
        )
    }
    
    init(
        imageSource: ImageSource,
        faceFeedbackGenerator: FaceFeedbackGenerator
    ) {
        self.imageSource = imageSource
        self.faceFeedbackGenerator = faceFeedbackGenerator
    }
    
    deinit {
        stopImageSource()
    }
    
    // MARK: - Entry Points
    
    /**
     Starts the camera and continuously feeds the camera frames into a facial recognition system.
     */
    public func startDetection() {
        startImageSource()
    }
    
    /**
     Stops the camera and frees its resources. Automatically called when objects of this class are
     deallocated.
     */
    public func stopDetection() {
        stopImageSource()
    }
    
    // MARK: - Implementations
    
    private func startImageSource() {
        imageSource.startFeed { startResult in
            switch startResult {
            case .failure(let error):
                Self.logError("startImageSource(): startResult: \(error)")
            default:
                break
            }
        } frameHandler: { [weak self] frameResult in
            switch frameResult {
            case .success(let image):
                guard let self = self else { return }
                let feedbackResult
                    = self.faceFeedbackGenerator.handle(image: image)
                self.handleFeedbackResult(feedbackResult, in: image)
            case .failure(let error):
                Self.logError("startImageSource(): frameResult: \(error)")
            }
        }
    }
    
    private func stopImageSource() {
        imageSource.stopFeed()
    }
    
    private func handleFeedbackResult(
        _ feedbackResult: Result<Rect?, Error>,
        in image: UIImage
    ) {
        switch feedbackResult {
        case .success(let faceRect):
            handleFeedbackSuccess(faceRect: faceRect, in: image)
        case .failure(let error):
            Self.logError(error.localizedDescription)
        }
    }
    
    private func handleFeedbackSuccess(
        faceRect: Rect?,
        in image: UIImage
    ) {
        guard let targetRect = targetRect else {
            return
        }
        
        guard let faceRect = faceRect else {
            return
        }
        
        guard faceRect.isInside(targetRect) else {
            return
        }
        
        eventHandlerQueue.async {
            self.eventHandler?(.imageCapture(image))
        }
    }
    
    private static func logError(_ message: String) {
        NSLog("ERROR: Session: \(message)")
    }
    
}
