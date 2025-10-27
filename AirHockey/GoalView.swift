//
//  fighterJetView.swift
//  skyFighter
//
//  Created by Альбек Халапов on 25.10.2025.
//

import SwiftUI

struct GoalView: View {
    var body: some View {
        GeometryReader { geo in
                    let width = geo.size.width
                    let height: CGFloat = 80
                    let notchWidth: CGFloat = 100
                    let notchHeight: CGFloat = 20

                    let midX = width / 2
                    let notchStartX = midX - notchWidth / 2
                    let notchEndX = midX + notchWidth / 2

                    Path { path in
                        // Левый верхний угол
                        path.move(to: CGPoint(x: 0, y: 0))
                        // До начала выемки
                        path.addLine(to: CGPoint(x: notchStartX, y: 0))
                        // Вниз — начало выреза
                        path.addLine(to: CGPoint(x: notchStartX, y: notchHeight))
                        // Вправо — дно выреза
                        path.addLine(to: CGPoint(x: notchEndX, y: notchHeight))
                        // Вверх — конец выреза
                        path.addLine(to: CGPoint(x: notchEndX, y: 0))
                        // Остальная часть верхней границы
                        path.addLine(to: CGPoint(x: width, y: 0))
                        // Правая, нижняя и левая стороны
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .blue]),
                            startPoint: UnitPoint(x: 0, y: 1),
                            endPoint: UnitPoint(x: 1, y: 0)
                        )
                    )
                }
                .frame(height: 100)
            }
        }
#Preview {
    GoalView()
}
