//
//  ContentView.swift
//  skyFighter
//
//  Created by Альбек Халапов on 25.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack {
            CenterLineView()
                .ignoresSafeArea()
            
            
            
            PuckView()
                .frame(width: 70, height: 70)
            StrikerView()
            
            StrikerView()

            VStack(spacing: 0) {
                GoalView()
                    .rotationEffect(.degrees(180))
                    .frame(maxWidth: .infinity)
                Spacer(minLength: 0)
                GoalView()
                    .frame(maxWidth: .infinity)
            }
            .ignoresSafeArea(
                edges: .all
            )
            
        }
        
    }
}

#Preview {
    ContentView()
}
