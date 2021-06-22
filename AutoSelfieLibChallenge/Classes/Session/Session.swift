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
    public var eventHandler: ((AutoSelfieEvent) -> ())?
    
    /**
     See `eventHandler`. The queue on which the callback closure will be called synchronously.
     Default: main queue.
     */
    public var eventHandlerQueue = DispatchQueue.main
    
    public var cameraCaptureSession: AVCaptureSession?
    
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
        imageSource.startFeed { _ in
            
        } frameHandler: { [weak self] frameResult in
            guard let self = self else { return }
            
            switch frameResult {
            case .success(let sampleBuffer):
                self.faceFeedbackGenerator.handle(sampleBuffer: sampleBuffer)
            default:
                break
            }
        }
    }
    
    private func stopImageSource() {
        imageSource.stopFeed()
    }
    
}
