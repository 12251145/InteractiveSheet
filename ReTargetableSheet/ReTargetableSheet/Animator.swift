//
//  Animator.swift
//  ReTargetableSheet
//
//  Created by 김종헌 on 2023/09/21.
//

import Foundation
import UIKit

private var ScreenAnimationDriverKey: UInt8 = 1 << 4

final class Animator {
    private var displayLink: CADisplayLink?
    private var animations: [String: Animation] = [:]
    
    private func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(animationTick))
        displayLink?.add(to: .current, forMode: .common)
        
        if #available(iOS 15.0, *) {
            let maximumFramesPerSecond = Float(UIScreen.main.maximumFramesPerSecond)
            let highFPSEnabled = maximumFramesPerSecond > 60
            let minimumFPS: Float = min(highFPSEnabled ? 80 : 60, maximumFramesPerSecond)
            displayLink?.preferredFrameRateRange = .init(minimum: minimumFPS, maximum: maximumFramesPerSecond, preferred: maximumFramesPerSecond)
        }
    }
    
    private func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
func addAnimation(_ animation: Animation) {
    if animations.isEmpty {
        start()
    }
    
    animations[animation.id] = animation
}

func removeAnimation(_ animation: Animation) {
    animations[animation.id] = nil
    
    if animations.isEmpty {
        stop()
    }
}
    
@objc
private func animationTick(_ displayLink: CADisplayLink) {
    let dt = displayLink.targetTimestamp - displayLink.timestamp
    
    for animation in animations.values {
        var finished = false
        animation.animationTick(dt, finished: &finished)
        
        if finished {
            animations[animation.id] = nil
        }
    }
    
    if animations.isEmpty {
        stop()
    }
}
}

extension UIView {
    var animator: Animator {
        get {
            if let animator = objc_getAssociatedObject(self, &ScreenAnimationDriverKey) as? Animator {
                return animator
            } else {
                let newAnimator = Animator()
                self.animator = newAnimator
                return newAnimator
            }
        }
        
        set {
            objc_setAssociatedObject(self, &ScreenAnimationDriverKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
