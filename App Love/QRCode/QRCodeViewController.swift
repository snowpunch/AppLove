//
//  QRCodeViewController.swift
//  PushNotification
//
//  Created by Apple on 16/6/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, ZBarReaderDelegate, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate{
    
    var device:AVCaptureDevice?
    var input:AVCaptureDeviceInput?
    var output:AVCaptureMetadataOutput?
    var session:AVCaptureSession?
    var preview:AVCaptureVideoPreviewLayer?
    var urlString:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initConfig()
    }
    
    func readerControllerDidFailToRead(reader: ZBarReaderController!, withRetry retry: Bool) {
        
    }
    
    func initConfig() {
        let mediaType:String = AVMediaTypeVideo
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(mediaType)
        if (authStatus == AVAuthorizationStatus.Denied || authStatus == AVAuthorizationStatus.Restricted) {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        self.device = AVCaptureDevice.defaultDeviceWithMediaType(mediaType)
        if (self.device == nil) {
            print("no device")
            return
        }
        
        self.input = try! AVCaptureDeviceInput(device: self.device)
        self.output = AVCaptureMetadataOutput()
        self.output!.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        self.session = AVCaptureSession()
        self.session!.sessionPreset = AVCaptureSessionPresetHigh
        
        if (self.session!.canAddInput(self.input)) {
            self.session!.addInput(self.input)
        }
        
        if (self.session!.canAddOutput(self.output)) {
            self.session!.addOutput(self.output)
        }
        
        //条码类型
        self.output!.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        self.preview = AVCaptureVideoPreviewLayer(session: self.session)
        self.preview!.videoGravity = AVLayerVideoGravityResize
        self.preview!.frame = self.view.layer.bounds
        self.view.layer.insertSublayer(self.preview!, atIndex: 0)
        
        self.session!.startRunning()
        
        let qrView:QRView = QRView(frame: self.view.frame)
        
        print("\(NSStringFromCGRect(self.view.frame))")
        
        var size:CGSize = CGSizeZero
        if self.view.frame.size.width > 320 {
            size = CGSizeMake(300, 300)
        } else {
            size = CGSizeMake(200, 200)
        }
        qrView.transparentArea = size
        qrView.backgroundColor = UIColor.clearColor()
        qrView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        self.view.addSubview(qrView)
        
        let tipLabel:UILabel = UILabel(frame: CGRectMake(0, qrView.center.y - size.height / 2 - 30, self.view.frame.size.width, 20))
        
        tipLabel.text = "请将摄像头对准二维码 即可自动扫描"
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.font = UIFont.systemFontOfSize(15)
        tipLabel.textAlignment = .Center
        
        let myQRViewBtn = UIButton(frame: CGRectMake(qrView.frame.origin.x, qrView.center.y + size.height / 2 + 15, qrView.frame.size.width, 20))
        myQRViewBtn.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        myQRViewBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        myQRViewBtn.setTitle("我的二维码", forState: UIControlState.Normal)
        myQRViewBtn.addTarget(self, action: #selector(QRCodeViewController.go2myQRView), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tipLabel)
        self.view.addSubview(myQRViewBtn)
        
    }
    
    func go2myQRView(){
        
    }
    
    //pragma mark -----AVCaptureFileOutputRecordingDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            self.session?.stopRunning()
            let metadataObject:AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            self.urlString = metadataObject.stringValue
        }
        self.handelURLString(self.urlString)
    }
    // 处理扫描的字符串
    func handelURLString(urlString:String){
        let array:NSArray = urlString.componentsSeparatedByString("/")
        if (urlString.hasPrefix("http")) {
            if (array.firstObject != nil) {
                if (array[2].isEqualToString("www.baidu.com")) {
                    self.session?.startRunning()
                    
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://www.baidu.com")!)
                } else {
                    
                    let alertView:UIAlertView = UIAlertView(title: "提示", message: "该链接可能存在风险 \(urlString)", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "openUrl")
   
                    alertView.tag = 100086
                    alertView.delegate = self
                    self.urlString = urlString
                    self.session?.stopRunning()
                    alertView.show()
                }
            }
        }
        else {
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "扫描结果: \(urlString)", delegate: self, cancelButtonTitle: "ok")
            
            alertView.tag = 100087
            self.session?.stopRunning()
            alertView.show()
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if (alertView.tag == 100086) {
            if (buttonIndex == 1) {
                self.session!.startRunning()
                UIApplication.sharedApplication().openURL(NSURL(string:self.urlString)!)
            } else {
                self.session!.startRunning()
            }
        }
        
        if (alertView.tag == 100087) {
            if (buttonIndex == 0) {
                self.session!.startRunning()
            }
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
