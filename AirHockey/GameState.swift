import SwiftUI
import Combine

class GameState: ObservableObject {
    @Published var puck = Puck(position: CGPoint(x: 200, y: 300), velocity: CGVector(dx: 0, dy: 0))
    @Published var playerPaddle = Paddle(position: CGPoint(x: 200, y: 500), color: .red)
    @Published var aiPaddle = Paddle(position: CGPoint(x: 200, y: 100), color: .blue)
    @Published var playerScore = 0
    @Published var aiScore = 0
    @Published var winner: String? = nil

    let tableWidth: CGFloat = 400
    let tableHeight: CGFloat = 600
    let goalHeight: CGFloat = 20
    let gameLogic: GameLogicProtocol = GameLogic()
    private var gameTimer: Timer?

    func startGame() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateGame()
        }
    }

    func stopGame() {
        gameTimer?.invalidate()
    }

    func resetGame() {
        playerScore = 0
        aiScore = 0
        winner = nil
        resetPositions()
    }

    private func resetPositions() {
        playerPaddle.position = CGPoint(x: 200, y: 500)
        aiPaddle.position = CGPoint(x: 200, y: 100)
        gameLogic.resetPuck(puck: &puck, tableWidth: tableWidth, tableHeight: tableHeight)
    }

    private func updateGame() {
        guard winner == nil else { return }
        gameLogic.updateGame(puck: &puck, playerPaddle: playerPaddle, aiPaddle: &aiPaddle, tableWidth: tableWidth, tableHeight: tableHeight, goalHeight: goalHeight)
        let goals = gameLogic.checkGoals(puck: puck, tableWidth: tableWidth, tableHeight: tableHeight, goalHeight: goalHeight)
        if goals.playerScored {
            playerScore += 1
            gameLogic.resetPuck(puck: &puck, tableWidth: tableWidth, tableHeight: tableHeight)
        } else if goals.aiScored {
            aiScore += 1
            gameLogic.resetPuck(puck: &puck, tableWidth: tableWidth, tableHeight: tableHeight)
        }
        if playerScore >= 5 {
            winner = "Игрок"
        } else if aiScore >= 5 {
            winner = "AI"
        }
    }
}
