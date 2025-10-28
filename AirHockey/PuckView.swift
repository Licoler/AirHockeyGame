//
//  PuckView.swift
//  AirHockey
//
//  Created by Альбек Халапов on 27.10.2025.
//

import SwiftUI

struct PuckView: View {
        let size: CGFloat
        let rotation: Double
        
        var body: some View {
            ZStack {
                ForEach(0..<3) { iteration in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .gray]),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                        .rotationEffect(.degrees(Double(iteration) * 60))
                        .frame(width: size * 0.7, height: size * 0.7)
                }
            }
            .rotationEffect(.degrees(rotation))
        }
    }


#Preview {
    PuckView(size: 80, rotation: 1.0)
}
