//
//  ViewController.swift
//  ios
//
//  Created by JhonnyClocheMa on 2020/12/17.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var blnErrFlag: Bool = false
    var strErrMsg: String = ""
    var token: String!

    func getFcmToken() -> Bool {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        token = delegate.token
        
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad Call")
        
        if initWebView() == true {
            if loadWebView() == true {
                blnErrFlag = false
            }
            else {
                strErrMsg = "[Err] loadWebView fail"
                blnErrFlag = true
            }
        }
        else {
            strErrMsg = "[Err] initWebView fail"
            blnErrFlag = true
        }
        print(String(blnErrFlag) + " : " + strErrMsg)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("viewDidAppear call.")

        if blnErrFlag {
            let alert = UIAlertController(title: "포켓마켓", message: strErrMsg, preferredStyle: UIAlertController.Style.alert)


            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
//                print("App Exit!!")
//                exit(0)
            }))

            self.present(alert, animated: true, completion: nil)
        } else {
            if checkNetworkConnect() {
                print("App load success.")
                ///DEV
//                 self.showCaptureSession()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @available(iOS 9.0, *)
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        self.webView?.evaluateJavaScript("makeFcmTokenCookie('\(token!)')", completionHandler: { result, error in
            if let anError = error {
                let alert = UIAlertController(title: "포켓마켓", message: "[오류] FCM TOKEN 오류 발생\n\(anError)", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
                print("fcm error occured")
            }
        })
        
        
        self.activityIndicator.removeFromSuperview()
        
        
    }
    
    
    func checkNetworkConnect() -> Bool {
        if Reachability.isConnectedToNetwork() {
            print("Network Connect")
            return true
        } else {
            print("Nework not connect")

            let networkCheckAlert = UIAlertController(title: "포켓마켓", message: "[오류] 네트워크 연결 상태를 확인해 주십시오.\nApp을 종료합니다.", preferredStyle: UIAlertController.Style.alert)

            networkCheckAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                print("App Exit!!")
                exit(0)
            }))

            self.present(networkCheckAlert, animated: true, completion: nil)
            return false
        }
    }
    
    
    
    
    
    func initWebView() -> Bool {
        print("initWebView")
        let config = WKWebViewConfiguration()
        ///Javscript Call Function Controller
        let contentController = WKUserContentController()
        contentController.add(self, name: "native")

        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.userContentController = contentController
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        
//        let preferences = WKPreferences()
//        preferences.javaScriptEnabled = true
//        WKWebpagePreferences.allows
//        let configuration = WKWebViewConfiguration()
//        configuration.preferences = preferences
        
//        let webview = WKWebView(frame: .zero, configuration: configuration)
        

        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.bounces = false

//        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies])
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = NSDate(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: date as Date, completionHandler:{
            //remove callback
//            print("cache, cookies remove success!")
            self.getFcmToken()
            print("cache remove success!")
        })
        
        return true
    }
    
    ///Webview 호출
    func loadWebView() -> Bool  {
        print("loadWebView")
        view.addSubview(webView)

        let strUrl = "http://13.124.90.138:3000"
        ///WK Webview Setting!
        let urlRequest = URLRequest(url: NSURL.init(string: strUrl)! as URL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)

        webView.load(urlRequest)

        self.view = self.webView!
        return true
    }
    
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
        
        
        
        
        if message.name == "native" {
            if let dictionary: [String: String] = message.body as? Dictionary {
                if let funcName = dictionary["funcName"] {
                    switch funcName {
                        case "isNative":
                            webView.evaluateJavaScript("appYn = true;", completionHandler: nil)
                            break
                        default:
                            let alert = UIAlertController(title: "포켓마켓", message: "[오류] 웹 오류 발생\n정의되지 않은 funcName 입니다.\n[\(funcName)]", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            print("undefined functionName")
                    }
                } else {
                    let alert = UIAlertController(title: "포켓마켓", message: "[오류] 웹 오류 발생\nfuncName을 찾을 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("funcName is Not Found!")
                }
            } else {
                let alert = UIAlertController(title: "포켓마켓", message: "[오류] 웹 오류 발생\nBody를 찾을 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
                print("Message Body is Not Dictionary!")
            }
        }
    }
}
