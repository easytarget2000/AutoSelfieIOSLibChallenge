import AVFoundation.AVCaptureSession

typealias Session = AutoSelfieSession

/**
 Handles the IO of retrieving the exercise configuration files, captures the camera output, forwards camera
 frame to the internal detection logic and informs the caller of detection results.
 */
public class AutoSelfieSession {
    
    // MARK: - Values
    
    /**
     
     */
    public var targetRect: Rect?
    
    /**
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
            case .success(let sampleBuffer):
                guard let self = self else { return }
                let feedbackResult = self.faceFeedbackGenerator.handle(
                    sampleBuffer: sampleBuffer
                )
                self.handleFeedbackResult(feedbackResult, in: sampleBuffer)
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
        in sampleBuffer: CMSampleBuffer
    ) {
        switch feedbackResult {
        case .success(let faceRect):
            handleFeedbackSuccess(faceRect: faceRect, in: sampleBuffer)
        case .failure(let error):
            Self.logError(error.localizedDescription)
        }
    }
    
    private func handleFeedbackSuccess(
        faceRect: Rect?,
        in sampleBuffer: CMSampleBuffer
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
        
        let image: UIImage
        do {
            image = try UIImage(sampleBuffer: sampleBuffer)
        } catch {
            Self.logError(
                "handleFeedbackResult(): \(error.localizedDescription)"
            )
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
