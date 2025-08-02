import UIKit
import WebKit
import SnapKit

final class UserAgreementViewController: UIViewController {
    
    private let webView = WKWebView(frame: .zero)
    
    private let progressHud: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView(style: .medium)
        progress.hidesWhenStopped = true
        progress.color = UIColor.segmentActive
        
        return progress
    }()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    var link: URL?
    
    init(link: URL? = nil) {
        self.link = link
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        configure()
        
        progressHud.startAnimating()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [.new],
             changeHandler: {[weak self] _, _ in
                 guard let self = self else {return}
                 
                 updateProgressValue(webView.estimatedProgress)
             })
    }
    
    private func setProgressHidden(_ isHidden: Bool) {
        progressHud.stopAnimating()
    }
    
    private func updateProgressValue(_ value: Double) {
        let newProgress = Float(value)
        let shouldHideProgress = shouldHideProgress(for: newProgress)
        
        setProgressHidden(shouldHideProgress)
    }
    
    private func shouldHideProgress(for value: Float) -> Bool {
        return abs(value - 1.0) <= 0.0001
    }
    
    private func configure() {
        [webView,
         progressHud].forEach {
            view.addSubview($0)
        }
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        progressHud.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        if let url = link {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
