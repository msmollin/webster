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
class WebViewDelegate: NSObject, WebFrameLoadDelegate {

//  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
  func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
    print("Navigation Did Finish")
//    if webView.isLoading { return }


    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let printOpts: NSDictionary = [NSPrintJobDisposition: NSPrintSaveJob, NSPrintSaveJob: directoryURL]
    let printInfo = NSPrintInfo(dictionary: printOpts as! [String : AnyObject])
//    let printInfo = NSPrintInfo.shared()
    printInfo.orientation = .landscape
    printInfo.horizontalPagination = .autoPagination
    printInfo.verticalPagination = .autoPagination
    printInfo.topMargin = 0.0
    printInfo.leftMargin = 0.0
    printInfo.rightMargin = 0.0
    printInfo.bottomMargin = 0.0

    //TODO: This part needs to be worked a bit - it seems to function correctly but throws an error about being unable to get a container. Internet says it's apple's sandboxing security. Adding an Info.plist didn't help so need to do more research
//    let directory = directoryURL.path + "test.pdf"
    let directory = "/Users/Smollinger/Desktop/test.pdf"
//    let printOperation = NSPrintOperation.pdfOperation(with: sender.mainFrame.frameView.documentView, inside: NSRect(x: 0.0, y: 0.0, width: 562, height: 768), toPath: directory, printInfo: printInfo)
    NSPrintOperation.pdfOperation(with: sender.mainFrame.frameView.documentView, inside: NSRect(x: 0.0, y: 0.0, width: 562, height: 4000), toPath: directory, printInfo: printInfo).run()
//    NSPrintOperation.pdfOperation(view: sender.mainFrame.frameView.documentView).run()
//    let printOperation = sender.mainFrame.frameView.printOperation(with: printInfo)!
//    printOperation.showsPrintPanel = false
//    printOperation.showsProgressPanel = false
//    printOperation.run()
    abort()
  }
}

let myURL = URL(string: "https://www.mapzen.com/blog/ios-sdk-1.0.0/")
let webView = WebView()
let delegate = WebViewDelegate()
//webView.navigationDelegate = delegate
webView.frameLoadDelegate = delegate
webView.frame = NSRect(x: 0.0, y: 0.0, width: 562, height: 762)
webView.mainFrame.load(URLRequest(url: myURL!))

//URLSession.shared.downloadTask(with: myURL!) { (downloadLocation, urlResponse, error) in
//
//  let mimeType = urlResponse!.mimeType!
//  let characterEncoding = urlResponse!.textEncodingName!
//
//  var htmlData: Data?
//  do {
//    htmlData = try Data.init(contentsOf: downloadLocation!)
//  } catch {
//    //Shrug
//  }
//
//  DispatchQueue.main.async {
////    webView.load(htmlData!, mimeType: mimeType, characterEncodingName: characterEncoding, baseURL: myURL!)
//    webView.mainFrame.load(htmlData!, mimeType: mimeType, textEncodingName: characterEncoding, baseURL: myURL)
//
//  }
//
//}.resume()

//This little bit gets us a runloop and spins it. Otherwise nothing above here works.
var shouldKeepRunning = true
let theRL = RunLoop.current
while shouldKeepRunning && theRL.run(mode: .defaultRunLoopMode, before: .distantFuture) { }




