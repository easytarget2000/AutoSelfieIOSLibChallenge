import UIKit.UIImage

final class ContentViewModel: ObservableObject {
    @Published var capturedImage = UIImage()
    @Published var showCapturedImage = false
}
