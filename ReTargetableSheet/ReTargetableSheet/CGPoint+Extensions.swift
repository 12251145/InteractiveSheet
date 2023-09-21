//
//  CGPoint+Extensions.swift
//  ReTargetableSheet
//
//  Created by 김종헌 on 2023/09/21.
//

import QuartzCore

extension CGPoint {
    func substractedBy(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
    
    func addedBy(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    
    func multipliedBy(_ multiplier: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * multiplier, y: self.y * multiplier)
    }
    
    var length: CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
}
