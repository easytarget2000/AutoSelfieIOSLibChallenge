import CoreMedia.CMSampleBuffer
import MLKitFaceDetection
import MLKitVision

final class MLKitFaceFeedbackGenerator: FaceFeedbackGenerator {
    
    private static var options: FaceDetectorOptions {
        let options = FaceDetectorOptions()
        options.classificationMode = .none
        options.contourMode = .none
        options.performanceMode = .fast
        return options
    }
    
    private let faceDetector: FaceDetector
    
    convenience init() {
        self.init(
            faceDetector: FaceDetector.faceDetector(options: Self.options)
        )
    }
    
    init(faceDetector: FaceDetector) {
        self.faceDetector = faceDetector
    }
        
    func handle(image: UIImage) -> Result<Rect?, Error> {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        let faces: [Face]
        do {
            faces = try faceDetector.results(in: visionImage)
        } catch {
            return .failure(error)
        }
        
        guard let firstFace = faces.first else {
            return .success(nil)
        }
        
        let firstFaceFrame = Rect.fromCG(firstFace.frame)
        return .success(firstFaceFrame)
    }
    
}
