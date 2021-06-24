public struct Rect {
    
    public let x1: Double
    
    public let y1: Double
    
    public let x2: Double
    
    public let y2: Double
    
    static let zero = Rect(x1: 0, y1: 0, x2: 0, y2: 0)
    
    public func toCG() -> CGRect {
        return CGRect(
            x: CGFloat(x1),
            y: CGFloat(y1),
            width: CGFloat(x2 - x1),
            height: CGFloat(y2 - y1)
        )
    }
    
    public static func fromCG(_ cgRect: CGRect) -> Self {
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
