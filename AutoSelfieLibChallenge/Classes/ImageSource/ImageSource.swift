import CoreMedia.CMSampleBuffer

protocol ImageSource {
    
    var feedStarted: Bool { get }
        
    func startFeed(
        completionHandler: ((Result<Bool, Swift.Error>) -> ())?,
        frameHandler: ((Result<UIImage, Swift.Error>) -> ())?
    )
    
    func stopFeed()
    
}
