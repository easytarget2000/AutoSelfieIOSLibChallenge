final class TargetRectDrawer {
    
    var color = UIColor.blue.cgColor
    
    var opacity: Float = 0.5
    
    private final class TargetRectLayer: CALayer { }
    
    func draw(rect: Rect, in layer: CALayer) {
        clear(layer)
        layer.contentsGravity = .top
        
        let skeletonLayer = TargetRectLayer()
        skeletonLayer.frame = CGRect(origin: .zero, size: layer.frame.size)

        let solidPath = UIBezierPath(rect: layer.frame)
        let ovalPath = UIBezierPath(ovalIn: rect.toCG())
        solidPath.append(ovalPath)
        solidPath.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = solidPath.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = color
        fillLayer.opacity = opacity

        skeletonLayer.addSublayer(fillLayer)
        layer.addSublayer(skeletonLayer)
    }
    
    func clear(_ layer: CALayer) {
        layer.sublayers?.forEach{
            if ($0 is TargetRectLayer) {
                $0.removeFromSuperlayer()
            }
        }
    }
}
