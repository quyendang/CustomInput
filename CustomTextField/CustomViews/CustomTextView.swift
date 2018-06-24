//
//  CustomTextView.swift
//  CustomTextField
//
//  Created by Quyen Dang on 6/24/18.
//  Copyright © 2018 Quyen Dang. All rights reserved.
//

import QuartzCore
import UIKit

@IBDesignable
class CustomTextView: UITextView {
    
    @IBInspectable var placeholder = "" {
        didSet {
            placeHolderLabel.text = placeholder
            placeHolderLabel.text = placeholder
            placeHolderLabel.sizeToFit()
            sendSubview(toBack: placeHolderLabel)
        }
    }
    @IBInspectable var placeholderColor = UIColor.lightGray
    
    private var placeHolderLabel: UILabel!
    
    let placeHolderChangeAnimationDuration = 0.25
    let placeHolderTag = 999
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        initUI()
        configDefaultUI()
    }
    
    private func initUI() {
        let placeholderLb = UILabel(frame: CGRect(x: 5, y: 8, width: bounds.size.width - 16, height: 0))
        addSubview(placeholderLb)
        self.placeHolderLabel = placeholderLb
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
    }
    
    private func configDefaultUI() {
        placeHolderLabel.lineBreakMode = .byWordWrapping
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.font = font
        placeHolderLabel.backgroundColor = UIColor.clear
        placeHolderLabel.textColor = placeholderColor
        placeHolderLabel.alpha = 1
        placeHolderLabel.tag = placeHolderTag
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(notification:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textChanged(notification: Notification?) {
        if placeholder.isEmpty {
            return
        }
        UIView.animate(withDuration: placeHolderChangeAnimationDuration) {
            if let view = self.viewWithTag(999) {
                if self.text != nil && self.text!.isEmpty {
                    view.alpha = 1
                } else {
                    view.alpha = 0
                }
            }
        }
    }
}

