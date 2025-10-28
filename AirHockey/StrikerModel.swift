//
//  StrikerModel.swift
//  AirHockey
//
//  Created by Альбек Халапов on 27.10.2025.
//

import SwiftUI
import Combine

class StrikerModel: ObservableObject {
    @Published var x: CGFloat
    @Published var y: CGFloat
    var vx: CGFloat = 0
    var vy: CGFloat = 0
    let radius: CGFloat = 40
    
    private var lastX: CGFloat = 0
    private var lastY: CGFloat = 0
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        lastX = x
        lastY = y
    }
    
    func updateVelocity() {
        vx = x - lastX
        vy = y - lastY
        lastX = x
        lastY = y
    }
    
    func moveAI(toward puck: PuckModel, dt: CGFloat, fieldWidth: CGFloat, fieldHeight: CGFloat) {
        let defenseLineY = fieldHeight * 0.25      // зона, где AI “пасётся”
        let attackDistance: CGFloat = 220          // зона агрессии
        let returnSpeed: CGFloat = 250             // скорость возврата на позицию
        let chaseSpeed: CGFloat = 320              // скорость атаки
        
        var targetX = fieldWidth / 2
        var targetY = defenseLineY
        
        // если шайба в его зоне — едет к ней
        if puck.y < fieldHeight / 2 && abs(puck.y - defenseLineY) < attackDistance {
            targetX = puck.x
            targetY = puck.y
        }
        
        // направление движения
        let dx = targetX - x
        let dy = targetY - y
        let distance = sqrt(dx*dx + dy*dy)
        if distance > 1 {
            let directionX = dx / distance
            let directionY = dy / distance
            
            // если шайба близко — атакует быстрее
            let speed = (abs(puck.y - y) < 100) ? chaseSpeed : returnSpeed
            
            x += directionX * speed * dt
            y += directionY * speed * dt
        }
        
        // не вылезает за свою половину
        x = min(max(radius, x), fieldWidth - radius)
        y = min(max(radius, y), fieldHeight / 2 - radius)
        
        updateVelocity()
    }

}
