//
//  strikerView.swift
//  skyFighter
//
//  Created by Альбек Халапов on 25.10.2025.
//

import SwiftUI

struct StrikerView: View {
    var body: some View {
        ZStack {
            
            Circle()
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
            
            
        }
    }
}

#Preview {
    StrikerView()
}
