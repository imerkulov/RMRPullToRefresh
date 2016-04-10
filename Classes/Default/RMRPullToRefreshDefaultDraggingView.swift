//
//  RMRPullToRefreshDefaultDraggingView.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 19.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public class RMRPullToRefreshDefaultDraggingView: RMRPullToRefreshView {

    var textLabel: UILabel?
    
    var circleView: RMRPullToRefreshCircleView?
    
    var pullDownText: String?
    var dropDownText: String?
    
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

        self.circleView = circleView
        
        let textLabel = UILabel(frame: CGRectZero)
        textLabel.textAlignment = .Center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFontOfSize(10.0)
        
        switch (result) {
            case .Success:
                textLabel.textColor = UIColor.lightGrayColor()
                circleView.color = UIColor.lightGrayColor()
                pullDownText = "Потяните чтобы обновить..."
        }
        
        dropDownText = "Отпустите чтобы обновить..."
        
        addSubview(textLabel)
        
        textLabel.addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 12.0))
        
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0.0))
        
        self.textLabel = textLabel
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - RMRPullToRefreshViewProtocol
    
    public override func didChangeDraggingProgress(progress: CGFloat) {
        circleView?.updateProgress(progress)
        if progress > 1.0 {
            textLabel?.text = dropDownText
        } else {
            textLabel?.text = pullDownText
        }
    }
}
