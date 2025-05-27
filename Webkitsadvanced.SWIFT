import SwiftUI
import WebKit

struct Plugin {
    let name: String
    let sourceCode: String
    let injectionTime: WKUserScriptInjectionTime
    let forMainFrameOnly: Bool
}

class WebViewCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate, ObservableObject {
    var parent: AppleEnhancedWebView
    
    init(_ parent: AppleEnhancedWebView) {
        self.parent = parent
    }
    
    // MARK: - Navigation Delegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        parent.isLoading = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        parent.isLoading = false
        parent.pageTitle = webView.title ?? ""
        parent.canGoBack = webView.canGoBack
        parent.canGoForward = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           url.host?.contains("apple.com") == true || url.host?.contains("icloud.com") == true {
            parent.alertMessage = "You're visiting an Apple site: \(url.host ?? "")"
            parent.showAlert = true
            decisionHandler(.allow)
            return
        }
        decisionHandler(.allow)
    }
    
    // MARK: - JavaScript alert handling
    
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        parent.alertMessage = message
        parent.showAlert = true
        completionHandler()
    }
    
    // MARK: - Message Handler from JS
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Handle messages from JS plugins here
        if message.name == "pluginHandler", let body = message.body as? String {
            parent.alertMessage = "Plugin message: \(body)"
            parent.showAlert = true
        }
    }
}

struct AppleEnhancedWebView: UIViewRepresentable {
    let url: URL
    
    // State Bindings
    @Binding var isLoading: Bool
    @Binding var pageTitle: String
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    // Plugins (User Scripts) to inject
    var plugins: [Plugin] = []
    
    class Coordinator: WebViewCoordinator {
        @objc func refreshWebView(_ sender: UIRefreshControl) {
            if let webView = sender.superview as? WKWebView {
                webView.reload()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    sender.endRefreshing()
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.applicationNameForUserAgent = "AppleEnhancedWebView/1.0 (iOS/macOS)"
        
        let userContentController = WKUserContentController()
        
        // Inject plugins scripts
        for plugin in plugins {
            let userScript = WKUserScript(source: plugin.sourceCode,
                                          injectionTime: plugin.injectionTime,
                                          forMainFrameOnly: plugin.forMainFrameOnly)
            userContentController.addUserScript(userScript)
        }
        
        // Add script message handler for JS <-> Swift communication
        userContentController.add(context.coordinator, name: "pluginHandler")
        
        config.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.refreshWebView(_:)), for: .valueChanged)
            webView.scrollView.refreshControl = refreshControl
        }
        
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
}

// MARK: - Example Plugins

let examplePlugin = Plugin(
    name: "DarkModeCSS",
    sourceCode: """
    var style = document.createElement('style');
    style.innerHTML = `
    body { background-color: #121212 !important; color: #e0e0e0 !important; }
    a { color: #0a84ff !important; }
    `;
    document.head.appendChild(style);
    """,
    injectionTime: .atDocumentEnd,
    forMainFrameOnly: true
)

let exampleJSPlugin = Plugin(
    name: "HelloWorldJS",
    sourceCode: """
    window.webkit.messageHandlers.pluginHandler.postMessage('Hello from injected JS plugin!');
    """,
    injectionTime: .atDocumentEnd,
    forMainFrameOnly: true
)

// MARK: - ContentView to test plugins

struct ContentView: View {
    @State private var isLoading = false
    @State private var pageTitle = "Loading..."
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let initialURL = URL(string: "https://icloud.com/mail")!
    
    var body: some View {
        VStack(spacing: 0) {
            Text(pageTitle)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                AppleEnhancedWebView(
                    url: initialURL,
                    isLoading: $isLoading,
                    pageTitle: $pageTitle,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    showAlert: $showAlert,
                    alertMessage: $alertMessage,
                    plugins: [examplePlugin, exampleJSPlugin] // Inject plugins here
                )
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
            }
            
            HStack {
                Button(action: {
                    // Implement Back navigation
                }) {
                    Image(systemName: "chevron.left")
                }
                .disabled(!canGoBack)
                
                Button(action: {
                    // Implement Forward navigation
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(!canGoForward)
                
                Spacer()
                
                Button("Reload") {
                    // Implement reload action
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}