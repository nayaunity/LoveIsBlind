//
//  Hexagon.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/17/24.
//

import Foundation
import SwiftUI

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        // Height is calculated to maintain the hexagon ratio, ensuring it's not distorted
        let height = rect.height
        let hexagonHeight = sqrt(3.0) / 2 * width
        
        let xOffset = (width - hexagonHeight) / 2
        let yOffset = (height - hexagonHeight) / 2
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + yOffset))
        path.addLine(to: CGPoint(x: rect.maxX - xOffset, y: rect.minY + height / 4 + yOffset))
        path.addLine(to: CGPoint(x: rect.maxX - xOffset, y: rect.maxY - height / 4 + yOffset))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY + yOffset))
        path.addLine(to: CGPoint(x: rect.minX + xOffset, y: rect.maxY - height / 4 + yOffset))
        path.addLine(to: CGPoint(x: rect.minX + xOffset, y: rect.minY + height / 4 + yOffset))
        path.closeSubpath()
        
        return path
    }
}


#Preview {
    Hexagon()
}
