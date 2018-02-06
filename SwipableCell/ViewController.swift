//
//  ViewController.swift
//  SwipableCell
//
//  Created by TomoyaOnishi on 2014/10/12.
//  Copyright (c) 2014年 TomoyaOnishi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    }

}
