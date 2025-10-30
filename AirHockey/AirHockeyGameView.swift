import SwiftUI

struct AirHockeyGameView: View {
    @StateObject private var gameState = GameState()
    @State private var showWinnerAlert = false

    var body: some View {
        ZStack {
            Color.green.opacity(0.8)
                .frame(width: gameState.tableWidth, height: gameState.tableHeight)
                .overlay(
                    Rectangle()
                        .stroke(Color.white, lineWidth: 2)
                )
            Path { path in
                path.move(to: CGPoint(x: 0, y: gameState.tableHeight / 2))
                path.addLine(to: CGPoint(x: gameState.tableWidth, y: gameState.tableHeight / 2))
            }
            .stroke(Color.white, lineWidth: 2)
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: gameState.goalHeight)
                .position(x: gameState.tableWidth / 2, y: gameState.tableHeight - gameState.goalHeight / 2)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: gameState.goalHeight)
                .position(x: gameState.tableWidth / 2, y: gameState.goalHeight / 2)
            Circle()
                .fill(Color.black)
                .frame(width: gameState.puck.radius * 2, height: gameState.puck.radius * 2)
                .position(gameState.puck.position)
            Circle()
                .fill(gameState.playerPaddle.color.opacity(0.5))
                .frame(width: gameState.playerPaddle.radius * 2, height: gameState.playerPaddle.radius * 2)
                .position(gameState.playerPaddle.position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newPosition = value.location
                            if newPosition.y > gameState.tableHeight / 2 && newPosition.y < gameState.tableHeight - gameState.playerPaddle.radius {
                                gameState.playerPaddle.position = CGPoint(
                                    x: min(max(newPosition.x, gameState.playerPaddle.radius), gameState.tableWidth - gameState.playerPaddle.radius),
                                    y: newPosition.y
                                )
                            }
                        }
                )
            Circle()
                .fill(gameState.aiPaddle.color.opacity(0.5))
                .frame(width: gameState.aiPaddle.radius * 2, height: gameState.aiPaddle.radius * 2)
                .position(gameState.aiPaddle.position)
            VStack {
                Text("AI: \(gameState.aiScore)")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Spacer()
                Text("Player: \(gameState.playerScore)")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            .padding()
        }
        .frame(width: gameState.tableWidth, height: gameState.tableHeight)
        .onAppear {
            gameState.startGame()
        }
        .onDisappear {
            gameState.stopGame()
        }
        .onChange(of: gameState.winner) { winner in
            showWinnerAlert = winner != nil
        }
        .alert(isPresented: $showWinnerAlert) {
            Alert(
                title: Text("Победитель: \(gameState.winner ?? "")"),
                dismissButton: .default(Text("OK")) {
                    gameState.resetGame()
                }
            )
        }
    }
}
