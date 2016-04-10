//
//  RMRPullToRefreshConstants.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 19.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public enum RMRPullToRefreshPosition: Int {
    case Top
    case Bottom
}

public enum RMRPullToRefreshState: Int {
    case Stopped
    case Dragging
    case Loading
}

public enum RMRPullToRefreshResult: Int {
    case Success
//    case Error
}

public struct RMRPullToRefreshConstants {
    
    struct KeyPaths {
        static let ContentOffset = "contentOffset"
        static let ContentSize = "contentSize"
        static let ContentInset = "contentInset"
        static let Frame = "frame"
    }
    
    static let DefaultHeight = CGFloat(70.0)
    static let DefaultBackgroundColor = UIColor.whiteColor()
}