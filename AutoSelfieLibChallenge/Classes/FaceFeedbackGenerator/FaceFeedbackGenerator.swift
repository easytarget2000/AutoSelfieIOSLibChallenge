import CoreMedia.CMSampleBuffer

protocol FaceFeedbackGenerator {
    
    func handle(sampleBuffer: CMSampleBuffer) -> Result<Rect?, Error>
    
}
