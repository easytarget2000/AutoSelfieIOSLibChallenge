extension UIImage {
    
    func scaleCrop(to targetRect: Rect) -> UIImage {
        guard let cgimage = self.cgImage else {
            return self
        }
        
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        
        guard let newCgImage = contextImage.cgImage else {
            return self
        }
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect = CGFloat(targetRect.width / targetRect.height)
        
        var cropWidth = CGFloat(targetRect.width)
        var cropHeight = CGFloat(targetRect.height)
        
        if targetRect.width > targetRect.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if targetRect.width < targetRect.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }
        
        let rect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else {
            return self
        }
        
        let cropped: UIImage = UIImage(
            cgImage: imageRef,
            scale: scale,
            orientation: imageOrientation
        )
        
        UIGraphicsBeginImageContextWithOptions(
            targetRect.toCG().size,
            false,
            scale
        )
        cropped.draw(
            in: CGRect(
                x: 0,
                y: 0,
                width: targetRect.width,
                height: targetRect.height
            )
        )
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized ?? self
    }
    
}
