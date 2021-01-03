//import UIKit
//import WebKit
//
//
//// HTML상의 js를 invoke시켜 iOS로 응답을 받아냄.
//// 예) 웹상에 입력했던 "로그인아이디", "암호"를 iOS로 전송해줌.
//
//
//class JSToiOSViewController_simple: UIViewController{
//
//    var webview:WKWebView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initWebview_then_callFromJs()
//        loadUrl()
//    }
//
//    func initWebview_then_callFromJs(){
//        
//        //contents컨트롤러 만듬.
//        let contentController = WKUserContentController()
//        contentController.add(self, name:"doneAction")
//
//        //config 만듬
//        let config = WKWebViewConfiguration()
//        config.userContentController = contentController
//
//        //위 인자사용한 초기화
//        webview = WKWebView(frame: CGRect.zero , configuration: config )
//    }
//
//    func loadUrl(){
//
//        //request 만들고
//        guard let htmlUrl = Bundle.main.url(forResource:"buttonPress", withExtension:"html") else { return }
//        let request = URLRequest(url:htmlUrl)
//        webview.load(request)
//
//        // UI 구성
//        self.view.addSubview(webview)
//        webview.layer.borderWidth = 4.0
//        webview.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
//        webview.addToSuper(top: 10, left: 10, bottom: 10, right: 10)
//    }
//
//}
//extension JSToiOSViewController_simple:   WKScriptMessageHandler{
//
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//
//        if message.name == "doneAction" {
//            print("JavaScript 에서 메시지가 왔어요 \(message.body)")
//        }
//    }
//
//}
