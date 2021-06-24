import UIKit.UIImage

protocol FaceFeedbackGenerator {
    
    func handle(image: UIImage) -> Result<Rect?, Error>
    
}
