//
//  PuckModel.swift
//  AirHockey
//
//  Created by Альбек Халапов on 27.10.2025.
//
import SwiftUI
import Combine

class PuckModel: ObservableObject {
    @Published var x: CGFloat
    @Published var y: CGFloat
    @Published var vx: CGFloat
    @Published var vy: CGFloat
    @Published var rotation: Double = 0
    let radius: CGFloat = 20
    let friction: CGFloat = 0.99 // замедление с течением времени
    
    init(x: CGFloat, y: CGFloat, vx: CGFloat, vy: CGFloat) {
        self.x = x
        self.y = y
        self.vx = vx
        self.vy = vy
    }
    
    func update(dt: CGFloat, fieldWidth: CGFloat, fieldHeight: CGFloat) {
        // обновляем позицию
        x += vx * dt
        y += vy * dt
        rotation += 5
        
        // трение
        vx *= 0.99
        vy *= 0.99
        
        // проверяем столкновения со стенами
        if x - radius < 0 { x = radius; vx = abs(vx) }
        if x + radius > fieldWidth { x = fieldWidth - radius; vx = -abs(vx) }
        if y - radius < 0 { y = radius; vy = abs(vy) }
        if y + radius > fieldHeight { y = fieldHeight - radius; vy = -abs(vy) }

    }
    
    func checkCollision(with striker: StrikerModel) {
        let dx = x - striker.x
        let dy = y - striker.y
        let distance = sqrt(dx*dx + dy*dy)
        let minDist = radius + striker.radius

        // если есть пересечение
        if distance < minDist {
            let nx = dx / distance
            let ny = dy / distance

            // отталкиваем шайбу наружу
            let overlap = minDist - distance
            x += nx * overlap / 2
            y += ny * overlap / 2

            // отскок по нормали
            let dot = vx * nx + vy * ny
            vx -= 2 * dot * nx
            vy -= 2 * dot * ny

            // добавляем импульс страйкера
            vx += striker.vx * 0.5
            vy += striker.vy * 0.5
        }
    }

}
