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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "WHC-集合菜单样式一";
        let menuParam = WHC_MenuViewParam.getWHCMenuViewDefaultParam(titles: ["WHC","公司通知","直销客户","渠道客户","拜访管理","拜访回馈","回馈问题","销售计划","项目报备","项目跟踪","合同管理","收款管理","工作小结","请假申请","费用申请","汇总统计","发布通知","客户审核","回馈批注","小结批注","报备审核","市场推广","售后服务","费用审核","请假审批","w","h","c","吴海超","吴","超","海","iOS","Android","WP","手机","苹果","大神"], imageNames: ["icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2","icon3","icon1","icon2"], cacheWHCMenuKey: "WHC-集合菜单样式一");
        print(CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height + 50))
        
        let menuView = WHC_MenuView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 64), menuViewParam: menuParam);
        menuView.delegate = self;
        self.view.addSubview(menuView);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func WHCMenuView(menuView: WHC_MenuView ,item: WHC_MenuItem, title: String){
        print(title);
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
