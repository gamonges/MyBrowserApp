//
//  ViewController.swift
//  MyBrowserApp
//
//  Created by 蒲生廣人 on 2018/01/21.
//  Copyright © 2018年 蒲生廣人. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var browserWebView: UIWebView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var browserActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.browserWebView.delegate = self
        self.urlTextField.delegate = self
        self.browserActivityIndicatorView.hidesWhenStopped = true

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != self.urlTextField {
            return true
        }
        if let urlString = textField.text {
            self.loadUrl(urlString: urlString)
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.browserActivityIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let urlString = self.browserWebView.request?.url?.absoluteString {
            self.urlTextField.text = urlString
            self.backButton.isEnabled = self.browserWebView.canGoBack
            self.forwardButton.isEnabled = self.browserWebView.canGoForward
        }
        self.browserActivityIndicatorView.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let urlString = "http://dotinstall.com"
//        let urlString = ""
        self.loadUrl(urlString: urlString)
        self.addBorder()
    }
    
    func addBorder(){
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.browserWebView.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        self.browserWebView.layer.addSublayer(topBorder)
    }
    
    func showAlert(_ message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getValidatedUrl(urlString: String) -> URL? {
        if URL(string: urlString) == nil {
//            print("Invalid URL")
            self.showAlert("Invalid URL")
            return nil
        }
        return URL(string: urlString)
    }
    func loadUrl(urlString: String){
        if let url = self.getValidatedUrl(urlString: urlString){
            let urlRequest = URLRequest(url: url)
            self.browserWebView.loadRequest(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBackButton(_ sender: Any) {
        self.browserWebView.goBack()
    }
    
    @IBAction func goForwardButton(_ sender: Any) {
        self.browserWebView.goForward()
    }
    
    @IBAction func reload(_ sender: Any) {
        self.browserWebView.reload()
    }
}

