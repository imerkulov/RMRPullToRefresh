//
//  RMRPullToRefreshCircleView.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 20.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public class RMRPullToRefreshCircleView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var currentProgress = CGFloat(0.0)
    public var color = UIColor.blackColor() {
        didSet {
            circleLayer.strokeColor = color.CGColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleLayer.lineWidth = 2
        circleLayer.strokeColor = UIColor.blackColor().CGColor
        circleLayer.fillColor = UIColor.clearColor().CGColor
        
        layer.addSublayer(circleLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.circleLayer.frame = self.bounds
        updateProgress(currentProgress)
    }
    
    func updateProgress(progress: CGFloat) {
        
        let radius = min(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        var progressModifier = CGFloat(0.0)
        
        if progress == 1.0 {
            progressModifier = 1.0
        } else if progress == 0.0 {
            progressModifier = 1.0
        } else if progress < 0.65 {
            progressModifier = 0.0
        } else {
            progressModifier = (progress - 0.65)/(1.0 - 0.65);
        }
        
        let startAngle = CGFloat(0.0 / 180.0 * M_PI)
        let endAngle = (360.0 * progressModifier) / 180.0 * CGFloat(M_PI)
        
        circleLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
        
        currentProgress = progress
    }
}
