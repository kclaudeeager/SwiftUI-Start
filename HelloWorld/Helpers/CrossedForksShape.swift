//
//  No symbol named 'crossed.forks' found in system symbol set.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/26/23.
//

import Foundation
import SwiftUI

struct CrossedKnifeAndForkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let size = min(rect.width, rect.height)
        let forkWidth = size / 3
        
        // Draw the fork
        path.move(to: CGPoint(x: rect.midX - forkWidth / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX - forkWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + forkWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + forkWidth / 2, y: rect.minY))
        path.closeSubpath()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        
        // Draw the knife
        path.move(to: CGPoint(x: rect.minX, y: rect.midY - forkWidth / 2))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY - forkWidth / 2))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + forkWidth / 2))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + forkWidth / 2))
        path.closeSubpath()
        
        return path
    }
}
