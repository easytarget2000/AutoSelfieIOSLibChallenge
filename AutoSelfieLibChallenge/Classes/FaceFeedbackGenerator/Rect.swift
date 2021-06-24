struct Rect {
    
    let x1: Double
    
    let y1: Double
    
    let x2: Double
    
    let y2: Double
    
    func toCG() -> CGRect {
        return CGRect(
            x: CGFloat(x1),
            y: CGFloat(x2),
            width: CGFloat(x2 - x1),
            height: CGFloat(y2 - y2)
        )
    }
    
    static func fromCG(_ cgRect: CGRect) -> Self {
        return Self(
            x1: Double(cgRect.minX),
            y1: Double(cgRect.minY),
            x2: Double(cgRect.maxX),
            y2: Double(cgRect.maxY)
        )
    }
    
    func isInside(_ other: Rect) -> Bool {
        return x1 <= other.x1 && other.x2 <= x2
            && y1 <= other.y1 && other.y2 <= y2
    }
    
}
