@testable import AutoSelfieLibChallenge
import XCTest

class RectTests: XCTestCase {
    
    func testIsInside_GivenLargerOther_ReturnsFalse() {
        let sut = Rect(x1: 0, y1: 0, x2: 200, y2: 200)
        let other = Rect(x1: -1, y1: -1, x2: 300, y2: 300)
        let result = sut.isInside(other)
        XCTAssertFalse(result)
    }
    
    func testIsInside_GivenSameOther_ReturnsTrue() {
        let sut = Rect(x1: 1, y1: 1, x2: 10, y2: 10)
        let other = Rect(x1: 1, y1: 1, x2: 10, y2: 10)
        let result = sut.isInside(other)
        XCTAssertTrue(result)
    }
    
    func testIsInside_GivenSmallerInnerOther_ReturnsTrue() {
        let sut = Rect(x1: -10, y1: -5, x2: 30, y2: 35)
        let other = Rect(x1: 0, y1: -1, x2: 29, y2: 34)
        let result = sut.isInside(other)
        XCTAssertTrue(result)
    }
    
    func testIsInside_GivenIntersectingOther_ReturnsFalse() {
        let sut = Rect(x1: -10, y1: -5, x2: 30, y2: 35)
        let other = Rect(x1: 0, y1: -5, x2: 35, y2: 35)
        let result = sut.isInside(other)
        XCTAssertFalse(result)
    }
    
}
