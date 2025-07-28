//
//  ClearableTextView.swift
//  FakeNFT
//
//  Created by mpplokhov on 27.07.2025.
//

import UIKit

final class ClearableTextView: UITextView {

    private let clearButton = UIButton(type: .custom)

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupClearButton()
        setupObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupClearButton()
        setupObservers()
    }

    private func setupClearButton() {
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .lightGray
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        addSubview(clearButton)
        clearButton.isHidden = true
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editingDidBegin),
            name: UITextView.textDidBeginEditingNotification,
            object: self
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editingDidEnd),
            name: UITextView.textDidEndEditingNotification,
            object: self
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = 17
        clearButton.frame = CGRect(
            x: bounds.width - size - 16,
            y: (bounds.height - size) / 2,
            width: size,
            height: size
        )
        bringSubviewToFront(clearButton)
    }

    @objc private func clearText() {
        text = ""
        delegate?.textViewDidChange?(self)
        clearButton.isHidden = true
    }

    @objc private func textDidChange() {
        clearButton.isHidden = text.isEmpty || !isFirstResponder
    }

    @objc private func editingDidBegin() {
        clearButton.isHidden = text.isEmpty
    }

    @objc private func editingDidEnd() {
        clearButton.isHidden = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
