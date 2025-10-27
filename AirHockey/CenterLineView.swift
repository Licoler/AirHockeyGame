//
//  CenterLineView.swift
//  AirHockey
//
//  Created by Альбек Халапов on 27.10.2025.
//

import SwiftUI

struct CenterLineView: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.4)
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let circleRadius: CGFloat = 50
                
                Path { path in
                    // горизонтальная линия по центру
                    path.move(to: CGPoint(x: 0, y: height/2))
                    path.addLine(to: CGPoint(x: width, y: height/2))
                    
                    // окружность в центре
                    path.addEllipse(in: CGRect(
                        x: width/2 - circleRadius,
                        y: height/2 - circleRadius,
                        width: circleRadius*2,
                        height: circleRadius*2
                    ))
                }
                .stroke(Color.black, lineWidth: 3)
        }
        }
    }
}

#Preview {
    CenterLineView()
}
