import Cocoa
import WebKit

class AppDelegate: NSObject, NSApplicationDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    var window: NSWindow!
    var webView: WKWebView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let screenRect = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1280, height: 860)
        let windowWidth: CGFloat = 1180
        let windowHeight: CGFloat = 840
        let windowRect = NSRect(
            x: (screenRect.width - windowWidth) / 2 + screenRect.origin.x,
            y: (screenRect.height - windowHeight) / 2 + screenRect.origin.y,
            width: windowWidth,
            height: windowHeight
        )

        let userContentController = WKUserContentController()
        userContentController.add(self, name: "nativePrint")

        let printOverrideScript = WKUserScript(
            source: """
            window.print = function() {
                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.nativePrint) {
                    window.webkit.messageHandlers.nativePrint.postMessage('print');
                } else {
                    window.print();
                }
            };
            """,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        userContentController.addUserScript(printOverrideScript)

        let config = WKWebViewConfiguration()
        config.userContentController = userContentController

        webView = WKWebView(frame: windowRect, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        window = NSWindow(
            contentRect: windowRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "NCISM Textbook Assessment Tool"
        window.center()
        window.contentView = webView
        window.minSize = NSSize(width: 900, height: 650)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        if let resourcePath = Bundle.main.resourcePath {
            let htmlURL = URL(fileURLWithPath: resourcePath).appendingPathComponent("index.html")
            webView.loadFileURL(htmlURL, allowingReadAccessTo: URL(fileURLWithPath: resourcePath))
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "nativePrint" {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let printInfo = NSPrintInfo.shared
                printInfo.paperSize = NSSize(width: 595.28, height: 841.89)
                printInfo.topMargin = 20
                printInfo.bottomMargin = 20
                printInfo.leftMargin = 25
                printInfo.rightMargin = 25
                printInfo.orientation = .portrait

                let printOp = self.webView.printOperation(with: printInfo)
                printOp.showsPrintPanel = true
                printOp.showsProgressPanel = true
                if let win = self.window {
                    printOp.runModal(for: win, delegate: nil, didRun: nil, contextInfo: nil)
                } else {
                    printOp.run()
                }
            }
        }
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = NSAlert()
        alert.messageText = "NCISM Assessment Tool"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
        completionHandler()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
