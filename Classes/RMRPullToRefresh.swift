//
//  RMRPullToRefresh.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 03.04.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public class RMRPullToRefresh: NSObject {

    private var сontroller: RMRPullToRefreshController?
    
    public var height : CGFloat = RMRPullToRefreshConstants.DefaultHeight {
        didSet {
            сontroller?.configureHeight(height)
        }
    }
    
    public var backgroundColor : UIColor = RMRPullToRefreshConstants.DefaultBackgroundColor {
        didSet {
            сontroller?.configureBackgroundColor(backgroundColor)
        }
    }
    
    public init(scrollView: UIScrollView, position:RMRPullToRefreshPosition, actionHandler: () -> Void) {
        super.init()
        
        let controller = RMRPullToRefreshController(scrollView: scrollView,
                                                    position: position,
                                                    actionHandler: actionHandler)
        
        scrollView.addSubview(controller.containerView)
        self.сontroller = controller
    }
    
    public func remove() {
        сontroller?.unsubscribeFromScrollViewEvents()
        сontroller?.containerView.removeFromSuperview()
    }
    
    public func configureView(view :RMRPullToRefreshView, state:RMRPullToRefreshState, result:RMRPullToRefreshResult) {        
        сontroller?.configureView(view, state: state, result: result)
    }
    
    public func stopLoading() {
        stopLoading(.Success)
    }
    
    public func stopLoading(result:RMRPullToRefreshResult) {
        сontroller?.stopLoading(result)
    }
}
