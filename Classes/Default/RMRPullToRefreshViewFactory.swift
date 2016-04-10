//
//  RMRPullToRefreshViewFactory.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 19.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit

public class RMRPullToRefreshViewFactory: NSObject {

    class func defaultView(state: RMRPullToRefreshState, result: RMRPullToRefreshResult) -> RMRPullToRefreshView {
        
        switch (state) {
            case .Dragging:
                return draggingView(result)
            case .Loading:
                return loadingView(result)
            case .Stopped:
                return stoppedView(result)
        }
    }
    
    class func draggingView(result: RMRPullToRefreshResult) -> RMRPullToRefreshView {
        return RMRPullToRefreshDefaultDraggingView(result: result)
    }

    class func loadingView(result: RMRPullToRefreshResult) -> RMRPullToRefreshView {
        return RMRPullToRefreshDefaultLoadingView(result: result)
    }
    
    class func stoppedView(result: RMRPullToRefreshResult) -> RMRPullToRefreshView {
        return loadingView(result)
    }
}
