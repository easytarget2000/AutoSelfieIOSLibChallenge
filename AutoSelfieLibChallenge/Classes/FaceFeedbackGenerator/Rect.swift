struct Rect {
    
    let minX: Double
    
    let minY: Double
    
    let width: Double
    
    let height: Double
    
    func toCG() -> CGRect {
        return CGRect(
            x: CGFloat(minX),
            y: CGFloat(minY),
            width: CGFloat(width),
            height: CGFloat(height)
        )
    }
    
    static func fromCG(_ cgRect: CGRect) -> Self {
        return Self(
            minX: Double(cgRect.minX),
            minY: Double(cgRect.minY),
            width: Double(cgRect.width),
            height: Double(cgRect.height)
        )
    }
    
}
