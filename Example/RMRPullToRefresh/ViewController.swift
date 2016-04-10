//
//  ViewController.swift
//  RMRPullToRefresh
//
//  Created by Merkulov Ilya on 19.03.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit
import RMRPullToRefresh

public enum ExampleType: Int {
    case PerekrestokTop
    case PerekrestokBottom
    case BeelineTop
    case BeelineBottom
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var exampleType: ExampleType = .BeelineBottom
    
    var pullToRefresh: RMRPullToRefresh?
    
    let formatter = NSDateFormatter()
    
    var items: [String] = []
    var count = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        loadData()
        
        pullToRefresh = configurePullToRefresh(examplePosition(),
                                               pullToRefreshView: exampleView(),
                                               backgroundColor: exampleBackgroundColor())
    }
    
    // MARK: - Pull to Refresh
    
    func configurePullToRefresh(position: RMRPullToRefreshPosition, pullToRefreshView: RMRPullToRefreshView, backgroundColor: UIColor) -> RMRPullToRefresh {
        
        let pullToRefresh = RMRPullToRefresh(scrollView: tableView, position: position) { [weak self](this) in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.loadMore()
                this?.stopLoading()
            })
        }
        
        pullToRefresh.configureView(pullToRefreshView, state: .Dragging, result: .Success)
        pullToRefresh.configureView(pullToRefreshView, state: .Loading, result: .Success)
        
        pullToRefresh.height = 70.0
        
        pullToRefresh.backgroundColor = backgroundColor
        
        return pullToRefresh
    }
    
    // MARK: - Build example values
    
    func exampleView() -> RMRPullToRefreshView {
        if exampleType == .PerekrestokTop || exampleType == .PerekrestokBottom {
            return PerekrestokView.XIB_VIEW()!
        }
        return BeelineView.XIB_VIEW()!
    }
    
    func exampleBackgroundColor() -> UIColor {
        if exampleType == .PerekrestokTop || exampleType == .PerekrestokBottom {
            return UIColor(red: 16.0/255.0, green: 192.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        }
        return UIColor.whiteColor()
    }
    
    func examplePosition() -> RMRPullToRefreshPosition {
        if exampleType == .PerekrestokTop || exampleType == .BeelineTop {
            return .Top
        }
        return .Bottom
    }
    
    // MARK: - Configure
    
    func configure() {
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
    }
    
    // MARK: - Test data
    
    func loadData() {
        for _ in 0...count {
            items.append(formatter.stringFromDate(NSDate()))
        }
    }
    
    func loadMore() {
        for _ in 0...5 {
            self.items.append(formatter.stringFromDate(NSDate(timeIntervalSinceNow: 20)))
        }
        self.tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
}

