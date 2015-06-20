//
//  FrontPageTableViewController.swift
//  Ideatap
//
//  Created by Viktor Gardart on 12/06/15.
//  Copyright (c) 2015 Ideatap. All rights reserved.
//

import UIKit

class FrontPageTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        if(!LoginHelper.isLoggedIn) {
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! loginViewController
            self.presentViewController(loginVC, animated: false, completion: nil)
            return
        }
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 6
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FrontPageCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.selectionStyle = .None

        cell.textLabel?.text = "Cell #\(indexPath.row)"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert: UIAlertView = UIAlertView(title: "Cell #\(indexPath.row)", message: "", delegate: self, cancelButtonTitle: "Ok")
        alert.show()
    }
    @IBAction func logout(sender: AnyObject) {
        LoginHelper.signOut()
        self.viewDidAppear(true)
    }
}
