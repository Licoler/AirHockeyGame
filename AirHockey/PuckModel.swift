//
//  PuckModel.swift
//  AirHockey
//
//  Created by Альбек Халапов on 27.10.2025.
//

import Foundation
import Combine

class PuckModel: ObservableObject {
    @Published var x: CGFloat
    @Published var y: CGFloat
    @Published var vx: CGFloat
    @Published var vy: CGFloat
    @Published var rotation: Double
    
    init(x: CGFloat, y: CGFloat, vx: CGFloat, vy: CGFloat) {
        self.x = x
        self.y = y
        self.vx = vx
        self.vy = vy
        self.rotation = 0
    }
    
    func update(dt: CGFloat, fieldWidth: CGFloat, fieldHeight: CGFloat, puckRadius: CGFloat) {
        x += vx * dt
        y += vy * dt
        rotation += 5 // вращение
        
        // Отскок от стен
        if x < puckRadius || x > fieldWidth - puckRadius { vx *= -1 }
        if y < puckRadius || y > fieldHeight - puckRadius { vy *= -1 }
    }
}

