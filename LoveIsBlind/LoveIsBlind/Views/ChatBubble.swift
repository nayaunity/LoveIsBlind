//
//  ChatBubble.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/17/24.
//

import Foundation
import SwiftUI

struct ChatBubble: Shape {
    var isSender: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius: CGFloat = 16
        let tailWidth: CGFloat = 10
        let tailHeight: CGFloat = 20
        
        if isSender {
            // Bubble tail on the right
            path.move(to: CGPoint(x: rect.width - tailWidth, y: rect.height - tailHeight))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width - tailWidth, y: rect.height))
        } else {
            // Bubble tail on the left
            path.move(to: CGPoint(x: tailWidth, y: rect.height - tailHeight))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: tailWidth, y: rect.height))
        }
        
        path.addLine(to: CGPoint(x: rect.width - tailWidth, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width - tailWidth, y: cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius - tailWidth, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.width - tailWidth - cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: cornerRadius + tailWidth, y: 0))
        path.addArc(center: CGPoint(x: cornerRadius + tailWidth, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: -180),
                    endAngle: Angle(degrees: -270),
                    clockwise: false)
        path.addLine(to: CGPoint(x: tailWidth, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius + tailWidth, y: rect.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    ChatBubble(isSender: true)
}
