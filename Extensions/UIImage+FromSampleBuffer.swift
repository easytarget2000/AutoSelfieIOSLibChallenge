import CoreMedia.CMSampleBuffer

extension UIImage {
    
    enum CMInitError: Swift.Error, CustomStringConvertible {
        
        case cmSampleBufferGetImageBufferReturnedNil
        
        case createCGImageReturnedNil
        
        var description: String { String(describing: self) }
    }
    
    convenience init(
        sampleBuffer: CMSampleBuffer,
        ciContext: CIContext = CIContext()
    ) throws {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else {
            throw CMInitError.cmSampleBufferGetImageBufferReturnedNil
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        // Raised issue #10.
        let rotatedCIImage = ciImage.oriented(.up)
        
        guard let cgImage = ciContext.createCGImage(
                rotatedCIImage,
                from: rotatedCIImage.extent
        ) else {
            throw CMInitError.createCGImageReturnedNil
        }
        
        self.init(cgImage: cgImage)
    }
    
}
