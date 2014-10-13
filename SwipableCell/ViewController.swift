//
//  ViewController.swift
//  SwipableCell
//
//  Created by TomoyaOnishi on 2014/10/12.
//  Copyright (c) 2014年 TomoyaOnishi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    }
    
    
}

