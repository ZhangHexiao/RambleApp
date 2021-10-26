//
//  WebViewController.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-13.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseController {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var webView: WKWebView!
    var observer: NSKeyValueObservation?
    
    let viewModel = WebViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        
        observer = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.isHidden = webView.estimatedProgress == 1
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        
        viewModel.load { [weak self] (url, error) in
            if let err = error {
                self?.fail(error: err)
                return
            }
            
            guard let url = url else {
                self?.fail(error: error ?? "Something went wrong")
                return
            }
            
            self?.webView.load(URLRequest(url: url))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observer?.invalidate()
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = "ramble"
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .black
        wrapperView.addSubview(webView)
    }
    
    private func fail(error: String) {
        showError(err: error)
        navigationController?.popViewController(animated: true)
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showError(err: RMBError.unknown.localizedDescription)
        navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
}

extension WebViewController {
    static var instance: WebViewController {
        guard let vc = Storyboard.Settings.viewController(for: .webView) as? WebViewController else {
            assertionFailure("Something wrong while instantiating WebViewController")
            return WebViewController()
        }
        return vc
    }
}
