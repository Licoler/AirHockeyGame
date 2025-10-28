//
//  strikerView.swift
//  skyFighter
//
//  Created by Альбек Халапов on 25.10.2025.
//

import SwiftUI

struct StrikerView: View {
    let radius: CGFloat
        let color: Color
        
        var body: some View {
            Circle()
                .fill(color)
                .frame(width: radius*2, height: radius*2)
        }
    }

#Preview {
    StrikerView(radius: 6, color: .green)
}
