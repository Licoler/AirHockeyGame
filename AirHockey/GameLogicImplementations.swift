import SwiftUI

struct CollisionLogic: CollisionLogicProtocol {
    func checkCollision(puck: inout Puck, with paddle: PaddleProtocol) {
        let distance = hypot(puck.position.x - paddle.position.x, puck.position.y - paddle.position.y)
        if distance < puck.radius + paddle.radius {
            let angle = atan2(puck.position.y - paddle.position.y, puck.position.x - paddle.position.x)
            let speed = hypot(puck.velocity.dx, puck.velocity.dy) + 2
            puck.velocity.dx = cos(angle) * speed
            puck.velocity.dy = sin(angle) * speed
            let overlap = puck.radius + paddle.radius - distance
            puck.position.x += cos(angle) * overlap
            puck.position.y += sin(angle) * overlap
        }
    }

    func handleWallCollisions(puck: inout Puck, tableWidth: CGFloat, tableHeight: CGFloat, goalHeight: CGFloat) {
        if puck.position.x - puck.radius <= 0 || puck.position.x + puck.radius >= tableWidth {
            puck.velocity.dx = -puck.velocity.dx
            puck.position.x = max(puck.radius, min(tableWidth - puck.radius, puck.position.x))
        }
        if puck.position.y - puck.radius <= goalHeight || puck.position.y + puck.radius >= tableHeight - goalHeight {
            puck.velocity.dy = -puck.velocity.dy
            puck.position.y = max(goalHeight + puck.radius, min(tableHeight - goalHeight - puck.radius, puck.position.y))
        }
    }
}

struct SimpleAI: AIProtocol {
    func updateAI(paddle: inout Paddle, puck: Puck, tableWidth: CGFloat, tableHeight: CGFloat) {
        let targetX = puck.position.x + puck.velocity.dx * 10
        let targetY = puck.position.y + puck.velocity.dy * 10
        let clampedX = min(max(targetX, paddle.radius), tableWidth - paddle.radius)
        let clampedY = min(max(targetY, paddle.radius), tableHeight / 2)
        let dx = clampedX - paddle.position.x
        let dy = clampedY - paddle.position.y
        let distance = hypot(dx, dy)
        if distance > 1 {
            paddle.position.x += dx / distance * 3
            paddle.position.y += dy / distance * 3
        }
    }
}

struct GameLogic: GameLogicProtocol {
    let collisionLogic: CollisionLogicProtocol = CollisionLogic()
    let aiLogic: AIProtocol = SimpleAI()
    let friction: CGFloat = 0.98

    func updateGame(puck: inout Puck, playerPaddle: Paddle, aiPaddle: inout Paddle, tableWidth: CGFloat, tableHeight: CGFloat, goalHeight: CGFloat) {
        puck.position.x += puck.velocity.dx
        puck.position.y += puck.velocity.dy
        puck.velocity.dx *= friction
        puck.velocity.dy *= friction
        collisionLogic.handleWallCollisions(puck: &puck, tableWidth: tableWidth, tableHeight: tableHeight, goalHeight: goalHeight)
        collisionLogic.checkCollision(puck: &puck, with: playerPaddle)
        collisionLogic.checkCollision(puck: &puck, with: aiPaddle)
        aiLogic.updateAI(paddle: &aiPaddle, puck: puck, tableWidth: tableWidth, tableHeight: tableHeight)
    }

    func resetPuck(puck: inout Puck, tableWidth: CGFloat, tableHeight: CGFloat) {
        puck.position = CGPoint(x: tableWidth / 2, y: tableHeight / 2)
        puck.velocity = CGVector(dx: Double.random(in: -5...5), dy: Double.random(in: -5...5))
    }

    func checkGoals(puck: Puck, tableWidth: CGFloat, tableHeight: CGFloat, goalHeight: CGFloat) -> (playerScored: Bool, aiScored: Bool) {
        let playerScored = puck.position.y - puck.radius <= goalHeight && abs(puck.position.x - tableWidth / 2) < 50
        let aiScored = puck.position.y + puck.radius >= tableHeight - goalHeight && abs(puck.position.x - tableWidth / 2) < 50
        return (playerScored, aiScored)
    }
}
