//
//  ViewController.swift
//  ReTargetableSheet
//
//  Created by 김종헌 on 2023/09/20.
//

import UIKit

class ViewController: UIViewController {
    enum SheetState {
        case open
        case close
    }
    
    private var sheetState: SheetState = .close
    private let sheetView = SheetView()
    private var animation: Animation?
    private var targetPoint: CGPoint {
        let size = view.bounds.size
        if sheetState == .close {
            return .init(x: size.width / 2, y: size.height * 1.25)
        } else {
            return .init(x: size.width / 2, y: size.height / 2 + 50)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        sheetView.delegate = self        
        
        view.addSubview(sheetView)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        let size = view.bounds.size
        sheetView.frame = .init(x: 0, y: size.height * 0.75, width: size.width, height: size.height)
    }
    
    func startAnimation(view: UIView, initialVelocity: CGPoint) {
        cancelAnimation()
        let animation = Animation(view: view, targetPoint: self.targetPoint, velocity: initialVelocity)
        self.animation = animation
        view.animator.addAnimation(animation)
    }

    func cancelAnimation() {
        guard let animation else { return }
        sheetView.animator.removeAnimation(animation)
        self.animation = nil
    }
}

extension ViewController: SheetViewDelegate {
    func sheetViewBeganDragging(_ sheetView: SheetView) {
        cancelAnimation()
    }
    
    func sheetViewDidEndDragging(_ sheetView: SheetView, with velocity: CGPoint) {
        self.sheetState = velocity.y > 0 ? .close : .open
        startAnimation(view: sheetView, initialVelocity: velocity)
    }
}
