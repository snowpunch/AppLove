//
//  WHCViewController.swift
//  App Love
//
//  Created by Apple on 16/6/29.
//  Copyright © 2016年 Snowpunch. All rights reserved.
//

import UIKit
extension UIColor {
    /// 主题颜色
    class func themeColor() -> UIColor{
        return UIColor(red: 38.0 / 255.0, green: 110.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0);
    }
    
    /// VC主背景颜色
    class func themeBackgroundColor() -> UIColor{
        return UIColor(red: 245.0 / 255.0, green: 246.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0);
    }
    
    /// 线颜色
    class func lineColor() -> UIColor{
        return UIColor(red: 197 / 255.0, green: 199 / 255.0, blue: 200 / 255.0, alpha: 1.0);
    }
}

class WHCViewController: UIViewController, WHC_MenuViewDelegate {
    
    //to do
    var AppCategoryList:[AppCategoryItem] = [AppCategoryItem]();
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    var images:[String]! = []
    var titles:[String]! = []
    var menuView:WHC_MenuView!

    
    func initAppCategoryList() -> [AppCategoryItem] {
        let data:NSData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("customdir", ofType: "json")!)!
        
        let dataDic:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        
        let dataArray:NSArray = dataDic.objectForKey("data") as! NSArray
        var newArray:[AppCategoryItem] = [AppCategoryItem]()
        for item in dataArray {
            let appCategoryItem:AppCategoryItem = AppCategoryItem(dic: item as! NSDictionary)
            newArray.append(appCategoryItem)
        }
        return newArray
    }
    
    func getAppCategoryItemByMenu(array:[AppCategoryItem],menu:String) -> AppCategoryItem? {
        for item in array {
            if menu == item.title! {
                return item
            }
        }
        return nil
    }
    
    func getNewImages() -> [String] {
        var menus = self.menuView.getMenuItemTitles()
        menus.removeLast()
        
        var newImages:[String] = [String]();
        
        for menu in menus {
            for item in self.AppCategoryList {
                if menu == item.title {
                    newImages.append(item.icon!)
                    break;
                }
            }
        }
        
        return newImages;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "App Love";
        let rightBarItem:UIBarButtonItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WHCViewController.refreshAction(_:)))
        self.navigationItem.rightBarButtonItem = rightBarItem;
        weak var weakSelf = self as WHCViewController
        
        //self.AppCategoryList = self.initAppCategoryList()
//        print("AppCategoryList:\(self.AppCategoryList.last?.title)")
        
        weakSelf?.delay(0.5, Block: {

            let url = BaseHttper().getUrl()
            
            MyAppInfo.getInit(url as String, completion: { (resultArray, succeeded, error) in
                if(succeeded){
                    for result in resultArray!{
                        self.images.append((result["icon"] as? String)!)
                        self.titles.append((result["title"] as? String)!)
                        let appCategoryItem:AppCategoryItem = AppCategoryItem(dic: result as! NSDictionary)
                        self.AppCategoryList.append(appCategoryItem)
                    }
//                    print(self.AppCategoryList.last?.title)
                    
                    self.initList(weakSelf)
                }else{
                    
                }
            })
        })
        // Do any additional setup after loading the view.
    }
    
    func refreshAction(sender:AnyObject?) -> Void {
        
        let newImages = self.getNewImages();
        self.menuView.update(imagesName: newImages, titles: self.menuView.getMenuItemTitles(), deleteImages: nil, deleteTitles: nil)

    }
    
    func initList(weakSelf:WHCViewController?) -> Void {
        weakSelf?.delay(2.0, Block: {

            let menuParam = WHC_MenuViewParam.getWHCMenuViewDefaultParam(titles:self.titles, imageNames: self.images, cacheWHCMenuKey: "App Love");
            
            self.menuView = WHC_MenuView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, self.view.frame.size.height), menuViewParam: menuParam);
            
            self.menuView.delegate = self;
            self.view.addSubview(self.menuView);
            
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
    
    func WHCMenuView(menuView: WHC_MenuView ,item: WHC_MenuItem, title: String){
        print(title);
        
        if let item:AppCategoryItem = self.getAppCategoryItemByMenu(self.AppCategoryList, menu: title) {
            let url = item.url! + (NSString(format: BASEPART, item.sort!, 1, 25) as String)
            
            let myAppListTableViewController:MyAppListTableViewController = MyAppListTableViewController()
            myAppListTableViewController.mainUrl = url
            
            self.navigationController?.pushViewController(myAppListTableViewController, animated: true)
        }
        
    }
    func WHCMenuViewClickDelete(item: WHC_MenuItem){
        
    }
    func WHCMenuViewClickInsertItem(){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
