protocol ImageSource {
        
    func startFeed(handler: ((UIImage) -> ())?)
    
    func stopFeed()
    
}
