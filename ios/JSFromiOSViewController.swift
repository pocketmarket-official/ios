//class JSFromiOSViewController: UIViewController {
//
//    var webview:WKWebView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        initWebview_with_callJsFunc_modifyHTML()
//        loadUrl()
//
//    }
//
//    func initWebview_with_callJsFunc_modifyHTML(){
//     
//        //contents 만듬.
//        let contentController = WKUserContentController()
//        let userScript = WKUserScript(source: "mobileHeader()",
//                                      injectionTime: .atDocumentEnd,
//                                      forMainFrameOnly: true )
//        //mobileHeader()라는 javaScript 함수가 html로딩완료후 호출됨.
//
//        contentController.addUserScript(userScript)
//
//        //config 만듬
//        let config = WKWebViewConfiguration()
//        config.userContentController = contentController
//
//        //put it all together
//        //자바스크립트 함수를 실행시킬 준비를 미리하고, 이를 configuration에 넣고
//        //이를 다시 userContentController에 저장해둔후
//        //웹뷰를 만든다.
//        webview = WKWebView(frame: CGRect.zero , configuration: config )
//    }
//
//    func loadUrl(){
//
//        //request 만들고
//        guard let htmlUrl = Bundle.main.url(forResource:"loginPage", withExtension:"html") else { return }
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
