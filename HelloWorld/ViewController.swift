//
//  ViewController.swift
//  HelloWorld
//
//  Created by 张楚昭 on 16/4/30.
//  Copyright © 2016年 tianxing. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIWebViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        //注册键盘出现通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        //注册键盘隐藏通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //解除键盘出现通知
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        //解除键盘隐藏通知
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
    //键盘打开时,触发本回调函数
    func keyboardDidShow(notification:NSNotification){
        NSLog("键盘打开")
    }
    //键盘隐藏时,触发本回调函数
    func keyboardDidHide(notification:NSNotification){
        NSLog("键盘关闭")
    }
    
    //利用 TextField 的委托协议来放弃第一响应者
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    //开关控件 UISwitch
    @IBOutlet weak var LeftSwitch: UISwitch!
    @IBOutlet weak var RightSwitch: UISwitch!
    @IBAction func switchValueChanged(sender: AnyObject) {
        let witchSwitch = sender as! UISwitch
        let setting = witchSwitch.on
        self.LeftSwitch.setOn(setting, animated:true)
        self.RightSwitch.setOn(setting, animated:true)
    }
    //分段控件UISegmented Control
    @IBAction func touchDown(sender: AnyObject) {
        if self.LeftSwitch.hidden == true{
            self.LeftSwitch.hidden = false
            self.RightSwitch.hidden = false
        }else{
            self.LeftSwitch.hidden = true
            self.RightSwitch.hidden = true
        }
    }
    //滑块控件 UISlider
    @IBOutlet weak var SliderValue: UILabel!
    @IBAction func sliderValueChange(sender: AnyObject) {
        let slider = sender as! UISlider
        let progressAsInt = Int(slider.value)
        self.SliderValue.text = "\(progressAsInt)"
    }
    //网页视图 WebView
    @IBOutlet weak var webView: UIWebView!
    //本地资源加载: loadHTMLString:baseURL 同步方式
    @IBAction func testLoadHTMLString(sender: AnyObject) {
        let htmlPath = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let bundleUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
        var error:NSError?
        let html:String?
        do{
            html = try String(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding)
            self.webView.loadHTMLString(html!, baseURL: bundleUrl)
        }catch let error1 as NSError{
            error = error1
            html = nil
        }
    }
    //本地资源加载: loadData:MIMEType:textEncodingName:baseURL 同步方式
    @IBAction func testLoadData(sender: AnyObject) {
        let htmlPath = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let bundleUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
        let htmlData = NSData(contentsOfFile: htmlPath!)
        self.webView.loadData(htmlData!, MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: bundleUrl)
    }
    //网络资源加载: loadRequest: 异步方式
    @IBAction func testLoadRequest(sender: AnyObject) {
        let url = NSURL(string: "http://www.baidu.com")
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        self.webView.delegate = self
    }
    //活动指示器 ActivityIndicatorView
    var timer:NSTimer!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBAction func startToMove(sender: AnyObject) {
        if self.activityIndicatorView.isAnimating(){
            self.activityIndicatorView.stopAnimating()
        }else{
            self.activityIndicatorView.startAnimating()
        }
    }
    //模拟进度条ProgressView
    @IBOutlet var progressView: UIView!
    @IBOutlet weak var myProgressView: UIProgressView!
    @IBAction func downloadProgress(sender: AnyObject) {
        myProgressView.progress = 0.0
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"download", userInfo:nil, repeats: true)
    }
    //计时器回调函数
    func download(){
        self.myProgressView.progress = self.myProgressView.progress + 0.1
        if self.myProgressView.progress == 1.0{
            timer.invalidate()
            let alert = UIAlertView(title: "DownloadCompleted!", message: "", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    // 构建警告框
    @IBAction func testAlertView(sender: AnyObject) {
        let alertView:UIAlertView = UIAlertView(title: "通知", message: "明天放假啦", delegate:  self, cancelButtonTitle: "NO", otherButtonTitles: "YES")
        alertView.show()
    }
    // 实现 UIAlertDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("ClickButton = %i",buttonIndex)
    }
    //构建操作表
    @IBAction func testActionSheet(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "分享", delegate:  self, cancelButtonTitle: "取消", destructiveButtonTitle: "破坏性按钮", otherButtonTitles: "QQ", "微信", "微博")
        actionSheet.showInView(self.view)
    }
    //实现 UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("ClickSheetButton = %i", buttonIndex)
    }
    // UIAlertController 构建警告框
    @IBAction func testNewAlertView(sender: AnyObject) {
        let alertController:UIAlertController = UIAlertController(title: "新通知", message: "周末又来了", preferredStyle:  UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: {(alertAction)-> Void in
                                NSLog("Tap to NO")
        }))
        //尾闭包写法
        alertController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default){(alertAction)->Void in
                                NSLog("Tap to YES")
        })
//可以添加三个按钮,样式类似 sheet
//        alertController.addAction(UIAlertAction(title: "YE", style: UIAlertActionStyle.Destructive, handler: {(alertAction)->Void in
//            NSLog("Tap to YE")
//        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // UIAlertController 构建操作表 ActionSheet
    @IBAction func testNewActionSheet(sender: AnyObject) {
        let actionSheetController:UIAlertController = UIAlertController()
        actionSheetController.addAction(UIAlertAction(title: "取消", style:  UIAlertActionStyle.Cancel, handler: {(alertAction)->Void in
                NSLog("Tap 取消按钮")
        }))
        actionSheetController.addAction(UIAlertAction(title: "破坏性按钮", style:  UIAlertActionStyle.Destructive, handler: {(alertAction)->Void in
                NSLog("Tap 破坏性按钮")
        }))
        actionSheetController.addAction(UIAlertAction(title: "破坏性按钮2", style:  UIAlertActionStyle.Destructive, handler: {(alertAction)->Void in
            NSLog("Tap 破坏性按钮2")
        }))
        actionSheetController.addAction(UIAlertAction(title: "新浪", style:  UIAlertActionStyle.Default, handler: {(alertAction)->Void in
            NSLog("Tap 新浪按钮")
        }))
        actionSheetController.addAction(UIAlertAction(title: "QQ", style:  UIAlertActionStyle.Default, handler: {(alertAction)->Void in
            NSLog("Tap qq按钮")
        }))
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    //工具栏 save 按钮响应函数
    @IBAction func save(sender: AnyObject) {
        NSLog("Tap save 按钮")
    }
    //工具栏 open 按钮响应函数
    @IBAction func open(sender: AnyObject) {
        NSLog("Tap open 按钮")
    }
    //导航栏 Save 按钮响应函数
    @IBAction func saveNavigationBar(sender: AnyObject) {
        NSLog("Tap save navigation bar button")
    }
    //导航栏+按钮触发响应函数
    @IBAction func addNavigationBar(sender: AnyObject) {
        NSLog("Tap add navigation bar button")
    }
    
    
    
    
    
    
    
    
    
    
    

}

