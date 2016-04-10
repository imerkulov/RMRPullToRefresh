//
//  RMRPullToRefreshDefaultView.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 19.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public class RMRPullToRefreshDefaultLoadingView: RMRPullToRefreshView {
    
    var circleView: RMRPullToRefreshCircleView?
    
    init(result: RMRPullToRefreshResult) {
        super.init(frame: CGRectZero)
        
        let circleView = RMRPullToRefreshCircleView(frame: CGRectZero)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circleView)
        
        let height = CGFloat(30)
        
        let horizontalConstraint = NSLayoutConstraint(item: circleView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: circleView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: height)
        circleView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: height)
        circleView.addConstraint(heightConstraint)
        
        circleView.updateProgress(0.98)
        
        switch (result) {
            case .Success:
                circleView.color = UIColor.lightGrayColor()
        }
        
        self.circleView = circleView
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - RMRPullToRefreshViewProtocol
    
    override public func didStartLoadingAnimation(startProgress: CGFloat) {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2*M_PI
        rotationAnimation.duration = 0.9
        rotationAnimation.repeatCount = HUGE
        
        self.circleView?.alpha = 1.0
        circleView?.layer.addAnimation(rotationAnimation, forKey: "circleViewAnimation")
    }
    
    override public func didFinishLoadingAnimation() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.circleView?.alpha = 0.0
            }) { (finished) -> Void in
                self.circleView?.layer.removeAnimationForKey("circleViewAnimation")
        }
    }
}
