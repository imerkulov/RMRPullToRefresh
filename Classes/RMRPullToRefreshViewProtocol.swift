//
//  RMRPullToRefreshViewProtocol.swift
//  RMRPullToRefreshViewProtocol
//
//  Created by Merkulov Ilya on 19.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public protocol RMRPullToRefreshViewProtocol {
   
    func didChangeDraggingProgress(progress: CGFloat)
    func didStartLoadingAnimation(startProgress: CGFloat)
    func didFinishLoadingAnimation()
}