//
//  BaseHttper.swift
//  App Love
//
//  Created by Apple on 16/7/12.
//  Copyright © 2016年 Snowpunch. All rights reserved.
//

import UIKit

//每日推荐
let CUSTOMDIR = "http://i.apptao.com/customdir?app=AR_IconFreeCN&lang=zh_CN"

let BASEPART = "&sort=%@&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"

let dateInt = "\(Int(NSDate().timeIntervalSince1970 * 1000))"
//1.精品限免
let LIMITEDFREEURL = "http://i.apptao.com/limitedfree?&sort=hot&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)";
//2.精品免费
let MUSTLISTFREEURL = "http://i.apptao.com/mustlist?listname=musthave_dailyfeatured&sort=new&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)";
//3.限时降价
let MUSTLISTPAIDURL = "http://i.apptao.com/mustlist?listname=must_paid_cn&sort=new&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)";
//4.最新上架
let MUSTLISTNEWURL = "http://i.apptao.com/mustlist?listname=goodnewapp&sort=new&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)";
//5.下载榜单
let DOWNLOADLISTURL = "http://i.apptao.com/downloadlist?&sort=hot&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"
//6.游戏
let GAMEURL = "http://i.apptao.com/limitedfreelist?category=Games&sort=hot&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"
//7.小编推荐
let RECOMENDURL = "http://i.apptao.com/mustlist?listname=must_recommend_cn&sort=new&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"
//8.一元冰点
let ONEYUANURL = "http://i.apptao.com/mustlist?listname=oneyuanapp&sort=new&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"
//9.装机必备
let MUSTHAVEURL = "http://i.apptao.com/mustlist?listname=must_musthave_cn&sort=new&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"
//10.神奇周四
let TOPICLIST = "http://i.apptao.com/topiclist?listname=topic_2016_thursday24&sort=new&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)";
//11.单机游戏
let OFFLINEGAMEURL = "http://i.apptao.com/mustlist?listname=must_offlinegame_cn&sort=new&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"
//12.中国付费榜
let TOPRANKLISTCNPAIDURL = "http://i.apptao.com/topranklist?category=All&storecode=143465&popid=30&sort=paid&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"
//13.中国免费榜
let TOPRANKLISTCNFREEURL = "http://i.apptao.com/topranklist?category=All&storecode=143465&popid=27&sort=free&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"

//14.美国免费榜
let TOPRANKLISTUSFREEURL = "http://i.apptao.com/topranklist?category=All&storecode=143441&popid=27&sort=free&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"

//15.美国付费榜
let TOPRANKLISTUSPAIDURL = "http://i.apptao.com/topranklist?category=All&storecode=143441&popid=30&sort=paid&page=%ld&count=%ld&app=AR_IconFreeCN&v=3.7.111&lang=zh-Hans&time=\(dateInt)"

class BaseHttper: NSObject {
    
    override init(){
//        let dateDouble:String = "\(Int(NSDate().timeIntervalSince1970 * 1000))"
//        let url = NSString(format: url,1,2)
//        
//        print("urlAndDate:\(url),\(dateDouble)")
    }
    
    func getUrl() -> String {
        return CUSTOMDIR;
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        
    }

}
