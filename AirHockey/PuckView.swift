//
//  PuckView.swift
//  AirHockey
//
//  Created by Альбек Халапов on 27.10.2025.
//

import SwiftUI

struct PuckView: View {
    
    @State private var rotation: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                ForEach(0..<3) { iteration in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .gray]),
                                startPoint: UnitPoint(x: 0, y: 1),
                                endPoint: UnitPoint(x: 1, y: 0)
                            )
                        )
                        .rotationEffect(.degrees(Double(iteration) * 60))
                        .frame(width: width * 0.7, height: height * 0.7)
                }
            }
            .rotationEffect(.degrees(rotation))
        }
    }
}

#Preview {
    PuckView()
        .frame(width: 80, height: 80)
}
