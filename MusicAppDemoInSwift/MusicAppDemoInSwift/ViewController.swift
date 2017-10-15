//
//  ViewController.swift
//  MusicAppDemoInSwift
//
//  Created by Chengzhi Jia on 15/11/20.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    let fetch = FetchWebData()
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        fetch.fetchMainData(0)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetch.titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("mainCell") ?? UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "mainCell")
        cell.textLabel!.text = fetch.titleArray[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let desti = segue.destinationViewController as! SecondTableViewController
        let indexPath = self.myTableView.indexPathForSelectedRow
        desti.tableViewIdentifier = indexPath!.row
        
    }
    
    

}

