class CameraImageSource: ImageSource {
    
    private var handler: ((UIImage) -> ())?
    
    func startFeed(handler: ((UIImage) -> ())?) {
        self.handler = handler
    }
    
    func stopFeed() {
        handler = nil
    }
    
}
