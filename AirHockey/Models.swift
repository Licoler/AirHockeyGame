import SwiftUI

protocol Positionable {
    var position: CGPoint { get set }
    var radius: CGFloat { get }
}

struct Puck: Positionable {
    var position: CGPoint
    var velocity: CGVector
    let radius: CGFloat = 15
}

protocol PaddleProtocol: Positionable {
    var color: Color { get }
}

struct Paddle: PaddleProtocol {
    var position: CGPoint
    let radius: CGFloat = 30
    let color: Color
}

struct Goal {
    var position: CGPoint
    let width: CGFloat = 100
    let height: CGFloat = 20
}
