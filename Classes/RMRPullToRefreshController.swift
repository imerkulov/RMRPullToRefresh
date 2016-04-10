//
//  RMRPullToRefreshController.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 19.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public class RMRPullToRefreshController: NSObject {

    // MARK: - Vars
    
    weak var scrollView: UIScrollView?
    
    let containerView = RMRPullToRefreshContainerView()
    
    let backgroundView = UIView(frame: CGRectZero)
    var backgroundViewHeightConstraint: NSLayoutConstraint?
    var backgroundViewTopConstraint: NSLayoutConstraint?
    
    var subscribing = false
    
    var actionHandler: (() -> Void)!
    
    var previusContentOffset = CGPointZero
    
    var height = CGFloat(0.0)
    var originalTopInset = CGFloat(0.0)
    var originalBottomInset = CGFloat(0.0)
    
    var state = RMRPullToRefreshState.Stopped
    var result = RMRPullToRefreshResult.Success
    var position: RMRPullToRefreshPosition?
    
    // MARK: - Init
    
    init(scrollView: UIScrollView, position:RMRPullToRefreshPosition, actionHandler: () -> Void) {

        super.init()        
        self.scrollView = scrollView
        self.actionHandler = actionHandler
        self.position = position
        
        self.configureBackgroundView(self.backgroundView)
        self.configureDefaultSettings()
        self.configureContainterDefaultViews(position)
        
        self.containerView.backgroundColor = UIColor.clearColor()
        
        self.subscribeOnScrollViewEvents()
    }
    
    deinit {
        self.unsubscribeFromScrollViewEvents()
    }
    
    private func configureBackgroundView(backgroundView: UIView) {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.addSubview(backgroundView)
        addBackgroundViewConstraints(backgroundView)
    }
    
    private func addBackgroundViewConstraints(backgroundView: UIView) {
        // Constraints
        self.backgroundViewHeightConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
        backgroundView.addConstraint(self.backgroundViewHeightConstraint!)
        
        scrollView?.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        
        if position == .Top {
            scrollView?.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        } else if position == .Bottom, let scrollView = self.scrollView {
            let constant = max(scrollView.contentSize.height, CGRectGetHeight(scrollView.bounds))
            self.backgroundViewTopConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: constant)
            scrollView.addConstraint(self.backgroundViewTopConstraint!)
        }
    }
    
    private func configureDefaultSettings() {
        
        if let scrollView = self.scrollView {
            self.originalTopInset = scrollView.contentInset.top
            self.originalBottomInset = scrollView.contentInset.bottom
        }
        configureHeight(RMRPullToRefreshConstants.DefaultHeight)
    }
    
    public func configureView(view:RMRPullToRefreshView, state:RMRPullToRefreshState, result:RMRPullToRefreshResult) {
        containerView.configureView(view, state: state, result: result)
    }
    
    public func configureHeight(height: CGFloat) {
        self.height = height
        updateContainerFrame()
    }
    
    public func configureBackgroundColor(color: UIColor) {
        self.backgroundView.backgroundColor = color
    }
    
    private func configureContainterDefaultViews(position:RMRPullToRefreshPosition) {
        let draggingSuccessView = RMRPullToRefreshViewFactory.defaultView(.Dragging, result: .Success)
        let stoppedSuccessView = RMRPullToRefreshViewFactory.defaultView(.Stopped, result: .Success)
        let loadingSuccessView = RMRPullToRefreshViewFactory.defaultView(.Loading, result: .Success)

        configureView(draggingSuccessView, state: .Dragging, result: .Success)
        configureView(stoppedSuccessView, state: .Stopped, result: .Success)
        configureView(loadingSuccessView, state: .Loading, result: .Success)
        
        updateContainerView(self.state)
    }
    
    // MARK: - Public
    
    public func stopLoading(result:RMRPullToRefreshResult) {
        
        self.result = result
        self.state = .Stopped
        
        resetContentInset()
        
        if let scrollView = self.scrollView, position = self.position {
            switch (position) {
                case .Top:
                    if scrollView.contentOffset.y < -originalTopInset {
                        let offset = CGPointMake(scrollView.contentOffset.x, -self.originalTopInset)
                        scrollView.setContentOffset(offset, animated: true)
                    }
                case .Bottom:
                    let offset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds))
                    scrollView.setContentOffset(offset, animated: true)
            }
        }
        
        performSelector(#selector(stopAllAnimations), withObject: nil, afterDelay: 0.2)
    }
    
    // MARK: - Private
    
    @objc private func stopAllAnimations() {
        containerView.stopAllAnimations()
        backgroundViewHeightConstraint?.constant = 0
    }
    
    private func scrollViewDidChangeContentSize(scrollView: UIScrollView, contentSize: CGSize) {
        updateContainerFrame()
        if position == .Bottom {
            self.backgroundViewTopConstraint?.constant = max(scrollView.contentSize.height, CGRectGetHeight(scrollView.bounds))
        }
    }
    
    private func scrollViewDidScroll(scrollView: UIScrollView, contentOffset: CGPoint) {
        if let position = self.position {
            switch (position) {
                case .Top:
                    scrollViewDidScrollTopPosition(scrollView, contentOffset:contentOffset)
                case .Bottom:
                    scrollViewDidScrollBottomPosition(scrollView, contentOffset:contentOffset)
            }
        }
    }
    
    private func scrollViewDidScrollTopPosition(scrollView: UIScrollView, contentOffset: CGPoint) {
        
        let y = contentOffset.y
        
        if state != .Loading {
            let threshold = originalTopInset;
            if !scrollView.dragging && -previusContentOffset.y >= height && state == .Dragging {
                state = .Loading
                updateContainerView(state)
                actionHandler()
                containerView.setNeedsLayout()
                
                containerView.startAnimating(-previusContentOffset.y/height)
            }
            else if scrollView.dragging && y < threshold && state == .Stopped {
                state = .Dragging
                updateContainerView(state)
                containerView.setNeedsLayout()
            }
            else if y >= threshold && state != .Stopped {
                state = .Stopped
                updateContainerView(state)
                containerView.setNeedsLayout()
            }
            
            if state == .Dragging {
                containerView.configure(-y/height)
                configureBackgroundHeightConstraint(max(fabs(previusContentOffset.y), fabs(contentOffset.y)), contentInset: scrollView.contentInset)
            }
        }
        if state == .Loading {
            let top = originalTopInset+height
            var inset = scrollView.contentInset
            if inset.top != top {
                inset.top = top
                setContentInset(inset, animated: true)
            }
            configureBackgroundHeightConstraint(max(fabs(previusContentOffset.y), fabs(contentOffset.y)), contentInset: inset)
        }
        
        previusContentOffset = contentOffset
    }
    
    private func configureBackgroundHeightConstraint(contentOffsetY: CGFloat, contentInset: UIEdgeInsets) {
        var constant = CGFloat(-1.0)
        if position == .Top {
            constant = contentOffsetY + contentInset.top
        } else {
            constant = contentOffsetY + contentInset.bottom
        }
        if constant > 0 && constant > backgroundViewHeightConstraint?.constant {
            backgroundViewHeightConstraint?.constant = constant
        }
    }
    
    private func scrollViewDidScrollBottomPosition(scrollView: UIScrollView, contentOffset: CGPoint) {
        
        let y = scrollView.contentSize.height - (contentOffset.y + CGRectGetHeight(scrollView.bounds) + originalBottomInset)
        
        let previusY = scrollView.contentSize.height - (previusContentOffset.y + CGRectGetHeight(scrollView.bounds) + originalBottomInset)
        
        if state != .Loading {
            if !scrollView.dragging && -previusY > height && state == .Dragging {
                state = .Loading
                updateContainerView(state)
                actionHandler()
                containerView.setNeedsLayout()
                
                containerView.startAnimating(-previusY/height)
            }
            else if scrollView.dragging && y < 0.0 && state == .Stopped {
                state = .Dragging
                updateContainerView(state)
                containerView.setNeedsLayout()
            }
            else if y > 0.0 && state != .Stopped {
                state = .Stopped
                updateContainerView(state)
                containerView.setNeedsLayout()
            }
            
            if state == .Dragging {
                containerView.configure(-y/height)
                configureBackgroundHeightConstraint(max(fabs(previusY), fabs(y)), contentInset: scrollView.contentInset)
            }
        }
        if state == .Loading {
            let bottom = originalBottomInset+height
            var inset = scrollView.contentInset
            if bottom > inset.bottom {
                inset.bottom = bottom
                setContentInset(inset, animated: true)
            }
            configureBackgroundHeightConstraint(max(fabs(previusY), fabs(y)), contentInset: inset)
        }
        
        previusContentOffset = contentOffset
    }
    
    func updateContainerView(state: RMRPullToRefreshState) {
        containerView.updateView(state, result: self.result)
    }
    
    func updateContainerFrame() {
        if let scrollView = self.scrollView, let position = self.position {
            var frame = CGRectZero
            switch (position) {
            case .Top:
                frame = CGRectMake(0, -height, CGRectGetWidth(scrollView.bounds), height)
            case .Bottom:
                if scrollView.contentSize.height > CGRectGetHeight(scrollView.bounds) {
                    frame = CGRectMake(0, scrollView.contentSize.height, CGRectGetWidth(scrollView.bounds), height)
                }
            }
            
            self.containerView.frame = frame
        }
    }
    
    func resetContentInset() {
        if let scrollView = scrollView, let position = self.position {
            var inset = scrollView.contentInset
            switch (position) {
                case .Top:
                    inset.top = originalTopInset
                case .Bottom:
                    inset.bottom = originalBottomInset
            }
            setContentInset(inset, animated: true)
        }
    }
    
    func setContentInset(contentInset: UIEdgeInsets, animated: Bool) {
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: { () -> Void in
                self.scrollView?.contentInset = contentInset
            }, completion: { (finished) -> Void in
        })
    }
    
    // MARK: - KVO

    public func subscribeOnScrollViewEvents() {
        if !subscribing, let scrollView = self.scrollView {
            scrollView.addObserver(self, forKeyPath: RMRPullToRefreshConstants.KeyPaths.ContentOffset, options: .New, context: nil)
            scrollView.addObserver(self, forKeyPath: RMRPullToRefreshConstants.KeyPaths.ContentSize, options: .New, context: nil)
            subscribing = true
        }
    }
    
    public func unsubscribeFromScrollViewEvents() {
        if subscribing, let scrollView = self.containerView.superview {
            scrollView.removeObserver(self, forKeyPath: RMRPullToRefreshConstants.KeyPaths.ContentOffset)
            scrollView.removeObserver(self, forKeyPath: RMRPullToRefreshConstants.KeyPaths.ContentSize)
            subscribing = false
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == RMRPullToRefreshConstants.KeyPaths.ContentOffset {
            if let newContentOffset = change?[NSKeyValueChangeNewKey]?.CGPointValue, scrollView = self.scrollView {
                scrollViewDidScroll(scrollView, contentOffset:newContentOffset)
            }
        } else if keyPath == RMRPullToRefreshConstants.KeyPaths.ContentSize {
            if let newContentSize = change?[NSKeyValueChangeNewKey]?.CGSizeValue(), scrollView = self.scrollView {
                scrollViewDidChangeContentSize(scrollView, contentSize: newContentSize)
            }
        }
    }
    
}