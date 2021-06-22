typealias Session = AutoSelfieSession

public class AutoSelfieSession {
    
    // MARK: - Values
    
    public var eventHandler: ((AutoSelfieEvent) -> ())?
    
    private let imageSource: ImageSource
    
    // MARK: - Init
    
    public convenience init() {
        self.init(
            imageSource: CameraImageSource()
        )
    }
    
    init(imageSource: ImageSource) {
        self.imageSource = imageSource
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
        imageSource.startFeed { image in
            
        }
    }
    
    private func stopImageSource() {
        imageSource.stopFeed()
    }
    
}
