//
//  ViewController.swift
//  MiniBrowser2
//
//  Created by tech on 2022/08/04.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate,WKNavigationDelegate {

    @IBOutlet weak var bookMarkSegmentControl: UISegmentedControl!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mainWebView: WKWebView!
    @IBOutlet weak var spinningActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 메인 쓰레드의 시작
        
        let initialURL = "https://www.facebook.com"
        let myURL = URL(string:initialURL)
        let myRequest = URLRequest(url: myURL!)
        mainWebView.load(myRequest) // 비 동기로 받기 때문에 메인쓰레드와 따로 돈다. 백그라운드로 빠져서 돈다. 메인뷰의 로드가 끝나는 시점을 알기 위해서는 메인뷰의 로드(컨텐츠의 다운)를 트래킹을 해야한다.
        urlTextField.text = initialURL
        // spinningActivity 동작을 위해 필요한 delegate
        mainWebView.navigationDelegate = self
    }
    
    // spinningActivity의 시작
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinningActivityIndicatorView.startAnimating()
    }
    
    // spinningActivity의 끝
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinningActivityIndicatorView.stopAnimating()
    }
    
    // 북마크 세그먼트를 누를 때마다 해당 링크로 이동
    @IBAction func bookMarkAction(_ sender: Any) {
        
        // UISegmentedControl :
        // selectedSegmentIndex : 선택된 세그먼트의 인덱스 번호를 알아오는 것
        // titleForSegment(at:) : 지정한 segment의 타이틀을 가져오는 것
        let bookMarkURL = bookMarkSegmentControl.titleForSegment(at: bookMarkSegmentControl.selectedSegmentIndex)
        let urlString = "https://www.\(bookMarkURL!).com"

        mainWebView.load(URLRequest(url: URL(string: urlString)!))
        urlTextField.text = urlString
    }
    
    // 주소창에 url을 입력했을 때 링크로 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var urlString = "\(urlTextField.text!)"
        
        // urlString에 https:가 없어도 링크로 이동하도록
        if !urlString.hasPrefix("https://") {
            urlString = "https://\(urlTextField.text!)"
        }
        urlTextField.text = urlString
        mainWebView.load(URLRequest(url: URL(string: urlString)!))
        
        return true
    }
    
    // 뒤로 가기
    @IBAction func goBackAction(_ sender: Any) {
        mainWebView.goBack()
    }
    
    // 앞으로 가기
    @IBAction func goForwardAction(_ sender: Any) {
        mainWebView.goForward()
    }
    
    // 멈추기
    @IBAction func stopLaunching(_ sender: Any) {
        mainWebView.stopLoading()
    }
    
    // 새로고침
    @IBAction func refreshAction(_ sender: Any) {
        mainWebView.reload()
    }
    
    // UIActivityIndicatorView : task의 진행상황을 보여주는 뷰. startAnimating(), stopAnimation()을 써서 이용할 수 있다.
    
}

