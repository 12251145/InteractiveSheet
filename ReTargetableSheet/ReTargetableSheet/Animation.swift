//
//  Animation.swift
//  ReTargetableSheet
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

final class Animation {
    let id: String = UUID().uuidString
    private var view: UIView
    private var targetPoint: CGPoint
    private var velocity: CGPoint
    
    init(view: UIView, targetPoint: CGPoint, velocity: CGPoint) {
        self.view = view
        self.targetPoint = targetPoint
        self.velocity = velocity
    }
    
    func animationTick(_ dt: CFTimeInterval, finished: inout Bool) {
        let frictionConstant: CGFloat = 35
        let springConstant: CGFloat = 300
        
        let frictionForce = velocity
            .multipliedBy(frictionConstant)
        let springForce = targetPoint
            .substractedBy(view.center)
            .multipliedBy(springConstant)
        let force = springForce.substractedBy(frictionForce)
        
        velocity = velocity.addedBy(force.multipliedBy(dt))
        view.center = view.center.addedBy(velocity.multipliedBy(dt))
        
        let speed = velocity.length
        let distanceToGoal = targetPoint.substractedBy(view.center).length
        
        if speed < 0.05 && distanceToGoal < 1 {
            view.center = targetPoint
            finished = true
        }
    }
}
