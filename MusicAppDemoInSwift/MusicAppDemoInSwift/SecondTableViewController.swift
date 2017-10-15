//
//  SecondTableViewController.swift
//  MusicAppDemoInSwift
//
//  Created by Chengzhi Jia on 15/11/21.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

import UIKit

class SecondTableViewController: UITableViewController {
    var tableViewIdentifier = Int()
    let fetch = FetchWebData()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch.fetchMainData(self.tableViewIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name: "secondReload", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        self.tableView.reloadData()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "secondReload", object: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetch.dataArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("secondCell", forIndexPath: indexPath) ?? UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "secondCell")
        cell.textLabel!.text = fetch.dataArray[indexPath.row]
        return cell
    }
    

    
}
