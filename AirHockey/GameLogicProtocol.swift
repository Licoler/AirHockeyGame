import SwiftUI

protocol CollisionLogicProtocol {
    func checkCollision(puck: inout Puck, with paddle: PaddleProtocol)
    func handleWallCollisions(puck: inout Puck, tableWidth: CGFloat, tableHeight: CGFloat, goalHeight: CGFloat)
}

protocol AIProtocol {
    func updateAI(paddle: inout Paddle, puck: Puck, tableWidth: CGFloat, tableHeight: CGFloat)
}

protocol GameLogicProtocol {
    var collisionLogic: CollisionLogicProtocol { get }
    var aiLogic: AIProtocol { get }
    func updateGame(puck: inout Puck, playerPaddle: Paddle, aiPaddle: inout Paddle, tableWidth: CGFloat, tableHeight: CGFloat, goalHeight: CGFloat)
    func resetPuck(puck: inout Puck, tableWidth: CGFloat, tableHeight: CGFloat)
    func checkGoals(puck: Puck, tableWidth: CGFloat, tableHeight: CGFloat, goalHeight: CGFloat) -> (playerScored: Bool, aiScored: Bool)
}
