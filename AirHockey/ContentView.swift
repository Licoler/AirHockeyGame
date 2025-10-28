//
//  ContentView.swift
//  skyFighter
//
//  Created by Альбек Халапов on 25.10.2025.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var puck = PuckModel(x: 200, y: 300, vx: 150, vy: 120)
    @StateObject var player = StrikerModel(x: 200, y: 550)
    @StateObject var ai = StrikerModel(x: 200, y: 100)
    
    @State private var playerScore = 0
    @State private var aiScore = 0
    @State private var showGoalAlert = false
    @State private var goalMessage = ""
    
    let maxScore = 5
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            let fieldWidth = geo.size.width
            let fieldHeight = geo.size.height
            
            ZStack {
                CenterLineView().ignoresSafeArea()
                VStack(spacing: 0) {
                    GoalView()
                        .rotationEffect(.degrees(180))
                    Spacer(minLength: 0)
                    GoalView()
                }
                .ignoresSafeArea()
                
                // центральная линия
                Path { path in
                    path.move(to: CGPoint(x: 0, y: fieldHeight / 2))
                    path.addLine(to: CGPoint(x: fieldWidth, y: fieldHeight / 2))
                }
                .stroke(Color.white, lineWidth: 3)
                
                // счёт
                VStack {
                    Text("AI: \(aiScore)")
                        .foregroundColor(.red)
                        .font(.title.bold())
                    Spacer()
                    Text("Player: \(playerScore)")
                        .foregroundColor(.blue)
                        .font(.title.bold())
                }
                .padding()
                
                // шайба
                PuckView(size: puck.radius * 2, rotation: puck.rotation)
                    .position(x: puck.x, y: puck.y)
                
                // AI
                StrikerView(radius: ai.radius, color: .red)
                    .position(x: ai.x, y: ai.y)
                
                // игрок
                StrikerView(radius: player.radius, color: .blue)
                    .position(x: player.x, y: player.y)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                player.x = min(max(value.location.x, player.radius), fieldWidth - player.radius)
                                player.y = min(max(value.location.y, fieldHeight / 2 + player.radius), fieldHeight - player.radius)
                            }
                    )
            }
            .onReceive(timer) { _ in
                let dt: CGFloat = 0.016
                
                // 1️⃣ Обновляем позицию шайбы
                puck.update(dt: dt, fieldWidth: fieldWidth, fieldHeight: fieldHeight)
                
                // 2️⃣ Двигаем AI
                ai.moveAI(toward: puck, dt: dt, fieldWidth: fieldWidth, fieldHeight: fieldHeight)
                
                // 3️⃣ Обновляем скорость страйкеров перед столкновением
                player.updateVelocity()
                ai.updateVelocity()
                
                // 4️⃣ Проверяем столкновения шайбы с игроками
                puck.checkCollision(with: player)
                puck.checkCollision(with: ai)
                
                // 5️⃣ Проверяем голы
                let goal = checkGoal(for: puck, in: geo.size)
                if goal != .none {
                    if goal == .player {
                        playerScore += 1
                        goalMessage = "GOAL!!!\nPlayer \(playerScore)/\(maxScore)"
                    } else if goal == .ai {
                        aiScore += 1
                        goalMessage = "GOAL!!!\nAI \(aiScore)/\(maxScore)"
                    }
                    showGoalAlert = true
                    resetPuck(in: geo.size)
                }
            }
            .alert(isPresented: $showGoalAlert) {
                if playerScore >= maxScore {
                    return Alert(
                        title: Text("🏆 Победа!"),
                        message: Text("Ты выиграл матч!"),
                        dismissButton: .default(Text("Сыграть снова")) {
                            resetGame(in: geo.size)
                        }
                    )
                } else if aiScore >= maxScore {
                    return Alert(
                        title: Text("💀 Поражение"),
                        message: Text("AI оказался сильнее."),
                        dismissButton: .default(Text("Попробовать ещё")) {
                            resetGame(in: geo.size)
                        }
                    )
                } else {
                    return Alert(
                        title: Text(goalMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    private func resetPuck(in size: CGSize) {
        puck.x = size.width / 2
        puck.y = size.height / 2
        puck.vx = CGFloat.random(in: -150...150)
        puck.vy = CGFloat.random(in: 100...150) * (Bool.random() ? 1 : -1)
    }

    
    private func resetGame(in size: CGSize) {
        playerScore = 0
        aiScore = 0
        resetPuck(in: size)
    }
    enum GoalSide {
        case player, ai, none
    }

    func checkGoal(for puck: PuckModel, in size: CGSize) -> GoalSide {
        let notchWidth: CGFloat = 100
        let midX = size.width / 2
        let notchStartX = midX - notchWidth / 2
        let notchEndX = midX + notchWidth / 2
        
        // Верхние ворота (AI)
        if puck.y - puck.radius <= 0 &&
            puck.x >= notchStartX && puck.x <= notchEndX {
            return .player
        }
        // Нижние ворота (игрок)
        if puck.y + puck.radius >= size.height &&
            puck.x >= notchStartX && puck.x <= notchEndX {
            return .ai
        }
        return .none
    }

}



#Preview {
    ContentView()
}
