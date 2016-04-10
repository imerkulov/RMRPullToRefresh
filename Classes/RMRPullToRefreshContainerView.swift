//
//  RMRPullToRefreshContainerView.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 19.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public class RMRPullToRefreshContainerView: UIView {

    var currentView: RMRPullToRefreshView?
    
    var storage = [String: RMRPullToRefreshView]()

    public func configureView(view:RMRPullToRefreshView, state:RMRPullToRefreshState, result:RMRPullToRefreshResult) {
        let key = storageKey(state, result:result)
        self.storage[key] = view
    }
    
    func updateView(state: RMRPullToRefreshState, result: RMRPullToRefreshResult) {

        clear()
        if let view = obtainView(state, result: result) {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            addConstraint(constraint(self, subview: view, attribute: NSLayoutAttribute.Left))
            addConstraint(constraint(self, subview: view, attribute: NSLayoutAttribute.Top))
            addConstraint(constraint(self, subview: view, attribute: NSLayoutAttribute.Right))
            addConstraint(constraint(self, subview: view, attribute: NSLayoutAttribute.Bottom))
            self.currentView = view
        }
    }
    
    func configure(progress: CGFloat) {
        if let view = self.currentView {
            view.didChangeDraggingProgress(progress)
        }
    }
    
    func startAnimating(startProgress: CGFloat) {
        if let view = self.currentView {
            if !view.isAnimation {
                view.isAnimation = true
                view.didStartLoadingAnimation(startProgress)                
            }
        }
    }
    
    func stopAnimating() {
        if let view = self.currentView {
            if view.isAnimation {
                view.didFinishLoadingAnimation()
                view.isAnimation = false
            }
        }
    }
    
    func stopAllAnimations() {
        for view in storage.values {
            view.didFinishLoadingAnimation()
            view.isAnimation = false
        }
    }
    
    // MARK: - Private
    
    func clear() {
        for view in subviews {
            view.removeFromSuperview()
        }
        self.currentView = nil
    }
    
    func obtainView(state: RMRPullToRefreshState, result: RMRPullToRefreshResult) -> RMRPullToRefreshView? {
        let key = storageKey(state, result:result)
        return self.storage[key]
    }
    
    func storageKey(state: RMRPullToRefreshState, result: RMRPullToRefreshResult) -> String {
        return String(state.rawValue) + "_" + String(result.rawValue)
    }
    
    
    // MARK: - Constraint
    
    func constraint(superview: UIView, subview: UIView, attribute: NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: subview, attribute: attribute, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: attribute, multiplier: 1, constant: 0)
    }
}
