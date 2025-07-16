import UIKit
import SnapKit

final class CurrencyPaymentBottomPanel: UIView {
    
    private let onTap: () -> Void
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor.segmentActive
        label.numberOfLines = 0
        // NSLocalizedString
        label.text = NSLocalizedString("Совершая покупку, вы соглашаетесь с условиями", comment: "")
        
        return label
    }()
    
    private let linkButton: UIButton = {
       let button = UIButton(type: .system)
        // NSLocalizedString
        button.setTitle(
            NSLocalizedString("Пользовательского соглашения",
                              comment: ""),
            for: .normal
        )
        button.setTitleColor(
            UIColor.systemBlue,
            for: .normal
        )
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.caption2
        
        return button
    }()
    
    private let paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            NSLocalizedString(
                "Оплатить", comment: ""),
            for: .normal
        )
        button.setTitleColor(
            UIColor.background,
            for: .normal
        )
        button.backgroundColor = UIColor.segmentActive
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        return button
    }()
    
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
        
        super.init(frame: .zero)
        
//        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blockButton() {
        paymentButton.isEnabled = false
        paymentButton.backgroundColor = UIColor.notEnabled
    }
    
    func unlockButton() {
        paymentButton.isEnabled = true
        paymentButton.backgroundColor = UIColor.segmentActive
    }
    
    private func configure() {
        backgroundColor = UIColor.segmentInactive
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 12
        
        paymentButton.addTarget(self, action: #selector(showWebView), for: .touchUpInside)
        blockButton()
        
        // setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(paymentButton)
        
        let vStack = UIStackView(arrangedSubviews: [textLabel, linkButton])
        vStack.axis = .vertical
        vStack.alignment = .leading
        addSubview(vStack)
        
        vStack.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(16)
        }
        
        paymentButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(vStack.snp.bottom).offset(16)
            make.height.equalTo(60)
        }
    }
        
    @objc
    private func showWebView() {
        onTap()
    }
}
