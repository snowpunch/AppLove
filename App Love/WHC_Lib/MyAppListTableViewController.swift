//
//  MyAppListTableViewController.swift
//  App Love
//
//  Created by Apple on 16/7/25.
//  Copyright © 2016年 Snowpunch. All rights reserved.
//

import UIKit

class MyAppListTableViewController: UITableViewController {
    
    var appModels:[MyAppModel] = [MyAppModel]();
    var mainUrl:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "AppCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AppCellID")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 71
        self.tableView.separatorStyle = .None
        self.initAppList(mainUrl!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func initAppList(url:String) -> Void {
        weak var weakSelf = self as MyAppListTableViewController
        weakSelf?.delay(1.0, Block: {
            if self.mainUrl != nil {
                MyAppInfo.getInit(url as String, completion: { (resultArray, succeeded, error) in
                    if(succeeded){
                        for result in resultArray!{

                            let appCategoryItem:MyAppModel = MyAppModel(resultsDic: result as! NSDictionary)
                            self.appModels.append(appCategoryItem)
                        }
                        //                    print(self.AppCategoryList.last?.title)
                        self.tableView.reloadData()
                    }else{
                        
                    }
                })
            }
        })
    }
    func delay(time: NSTimeInterval, Block block: (() -> Void)){
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            block
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.appModels.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AppCellID", forIndexPath: indexPath) as! AppCell
        let model = self.appModels[indexPath.row]
        let newModel:AppModel = AppModel(resultsDic: ["trackName":model.title!,"artistName":model.developer!,"artworkUrl100":model.icon!,"averageUserRating":0,"userRatingCount":0,"trackId":model.appId])
        //AppList.sharedInst.appModels[indexPath.row]
        
        cell.setup(newModel)
        return cell

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
