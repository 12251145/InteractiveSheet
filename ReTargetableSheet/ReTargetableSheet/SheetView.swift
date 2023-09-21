//
//  SheetView.swift
//  ReTargetableSheet
//
//  Created by 김종헌 on 2023/09/21.
//

import UIKit

protocol SheetViewDelegate: AnyObject {
    func sheetViewDidEndDragging(_ sheetView: SheetView, with velocity: CGPoint)
    func sheetViewBeganDragging(_ sheetView: SheetView)
}

final class SheetView: UIView {
    
    weak var delegate: SheetViewDelegate?
    
    init() {
        super.init(frame: .zero)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(recognizer)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didPan(_ recognizer: UIPanGestureRecognizer) {
        let point = recognizer.translation(in: self.superview)
        center = .init(x: center.x, y: center.y + point.y)
        recognizer.setTranslation(.zero, in: self.superview)
        
        if recognizer.state == .ended {
            var velocity = recognizer.velocity(in: self.superview)
            velocity.x = 0
            delegate?.sheetViewDidEndDragging(self, with: velocity)
        } else if recognizer.state == .began {
            delegate?.sheetViewBeganDragging(self)
        }
    }
}
