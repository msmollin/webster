//
//  main.swift
//  webster
//
//  Created by Matt Smollinger on 4/5/17.
//  Copyright © 2017 mattsmollinger. All rights reserved.
//

import Foundation
import WebKit

//The class to receive delegate callbacks from the web view
class WebViewDelegate: NSObject, WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("Navigation Did Finish")
    if webView.isLoading { return }


    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let printOpts: NSDictionary = [NSPrintJobDisposition: NSPrintSaveJob, NSPrintSaveJob: directoryURL]
    let printInfo = NSPrintInfo(dictionary: printOpts as! [String : AnyObject])
    printInfo.horizontalPagination = .autoPagination
    printInfo.verticalPagination = .autoPagination
    printInfo.topMargin = 0.0
    printInfo.leftMargin = 0.0
    printInfo.rightMargin = 0.0
    printInfo.bottomMargin = 0.0

    //TODO: This part needs to be worked a bit - it seems to function correctly but throws an error about being unable to get a container. Internet says it's apple's sandboxing security. Adding an Info.plist didn't help so need to do more research
    let directory = directoryURL.path + "test.pdf"
    let printOperation = NSPrintOperation.pdfOperation(with: webView, inside: NSRect(x: 0.0, y: 0.0, width: 562, height: 768), toPath: directory, printInfo: printInfo)
    printOperation.showsPrintPanel = false
    printOperation.showsProgressPanel = false
    printOperation.run()
  }
}

let myURL = URL(string: "https://www.apple.com")
let webView = WKWebView()
let delegate = WebViewDelegate()
webView.navigationDelegate = delegate

URLSession.shared.downloadTask(with: myURL!) { (downloadLocation, urlResponse, error) in

  let mimeType = urlResponse!.mimeType!
  let characterEncoding = urlResponse!.textEncodingName!

  var htmlData: Data?
  do {
    htmlData = try Data.init(contentsOf: downloadLocation!)
  } catch {
    //Shrug
  }

  DispatchQueue.main.async {
    webView.load(htmlData!, mimeType: mimeType, characterEncodingName: characterEncoding, baseURL: myURL!)
  }

}.resume()

//This little bit gets us a runloop and spins it. Otherwise nothing above here works.
var shouldKeepRunning = true
let theRL = RunLoop.current
while shouldKeepRunning && theRL.run(mode: .defaultRunLoopMode, before: .distantFuture) { }




