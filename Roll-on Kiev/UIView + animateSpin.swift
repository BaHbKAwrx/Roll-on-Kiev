//
//  UIView + animateSpin.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 7/6/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateSpin(for delegate: CAAnimationDelegate, duration: Double, spins: Double) {
        
        var wheelAnimations = [CABasicAnimation]()
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = -(spins * 2) * Double.pi
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        wheelAnimations.append(rotateAnimation)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        wheelAnimations.append(fadeAnimation)
        
        let wheelAnimationGroup = CAAnimationGroup()
        wheelAnimationGroup.delegate = delegate
        wheelAnimationGroup.duration = duration
        wheelAnimationGroup.animations = wheelAnimations
        self.layer.add(wheelAnimationGroup, forKey: nil)
        
    }
    
}
