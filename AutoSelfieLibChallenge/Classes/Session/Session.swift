import AVFoundation.AVCaptureSession

typealias Session = AutoSelfieSession

public class AutoSelfieSession {
    
    // MARK: - Values
    
    public var eventHandler: ((AutoSelfieEvent) -> ())?
    
    public var cameraCaptureSession: AVCaptureSession?
    
    private let imageSource: ImageSource
    
    private let faceFeedbackGenerator: FaceFeedbackGenerator
    
    // MARK: - Init
    
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
    
    public func startDetection() {
        startImageSource()
    }
    
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
