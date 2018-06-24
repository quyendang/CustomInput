//
//  CustomInputField.swift
//  CustomTextField
//
//  Created by Quyen Dang on 6/24/18.
//  Copyright © 2018 Quyen Dang. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
class CustomInputField: UIView {
    
    private(set)  var inputTextField = UITextField()
    private var titleLabel = UILabel()
    private(set)  var errorLabel = UILabel()
    private var bottomLineView = UIView()
    
    @IBInspectable var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    @IBInspectable var errorText: String = "" {
        didSet {
            errorLabel.text = errorText
            
            if errorText.isEmpty {
                bottomLineView.backgroundColor = bottomLineColor
            } else {
                bottomLineView.backgroundColor = textErrorColor
            }
        }
    }
    
    @IBInspectable var text: String? = "" {
        didSet {
            inputTextField.text = text
            if text == nil || text!.isEmpty {
                moveTitleToCenter()
            } else {
                moveTitleToTop()
            }
        }
    }
    
    @IBInspectable var bottomLineColor: UIColor = UIColor.gray {
        didSet {
            bottomLineView.backgroundColor = bottomLineColor
        }
    }
    
    @IBInspectable var textErrorColor: UIColor = UIColor.red {
        didSet {
            errorLabel.textColor = textErrorColor
        }
    }
    
    @IBInspectable var textTitleColor: UIColor = UIColor.gray {
        didSet {
            titleLabel.textColor = textTitleColor
        }
    }
    
    @IBInspectable var inputTextColor: UIColor = UIColor.black {
        didSet {
            inputTextField.textColor = inputTextColor
        }
    }
    
    @IBInspectable var isSecure: Bool = false {
        didSet {
            inputTextField.isSecureTextEntry = isSecure
        }
    }
    
    @IBInspectable var isEmailKeyboardType: Bool = false {
        didSet {
            if isEmailKeyboardType {
                inputTextField.keyboardType = .emailAddress
            }
        }
    }
    
    @IBInspectable var isPhoneKeyboardType: Bool = false {
        didSet {
            if isPhoneKeyboardType {
                inputTextField.keyboardType = .phonePad
            }
        }
    }
    
    @IBInspectable var isNumberKeyboardType: Bool = false {
        didSet {
            if isNumberKeyboardType {
                inputTextField.keyboardType = .numberPad
            }
        }
    }
    
    @IBInspectable var isNextReturnKey: Bool = false {
        didSet {
            if isNextReturnKey {
                inputTextField.returnKeyType = .next
            } else {
                inputTextField.returnKeyType = .done
            }
        }
    }
    
    @IBInspectable var inputTag: Int = 0 {
        didSet {
            inputTextField.tag = inputTag
        }
    }
    
    weak var delegate: UITextFieldDelegate? {
        didSet {
            inputTextField.delegate = delegate
        }
    }
    
    @IBInspectable var enabled:Bool = true {
        didSet {
            inputTextField.isEnabled = enabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        addSubView()
        constraintLayout()
    }
    
    private func addSubView() {
        addSubview(titleLabel)
        addSubview(errorLabel)
        addSubview(bottomLineView)
        addSubview(inputTextField)
    }
    
    private func constraintLayout() {
        titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(0)
        }
        
        bottomLineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        inputTextField.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(bottomLineView.snp.top).offset(0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUIElement()
    }
    
    private func configUIElement() {
        self.layoutIfNeeded()
        configTitlaLabel()
        configErrorLabel()
        configInputTextField()
        
        bottomLineView.backgroundColor = bottomLineColor
    }
    
    private func configErrorLabel() {
        errorLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        errorLabel.textColor = textErrorColor
        errorLabel.textAlignment = .right
    }
    
    private func configTitlaLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = textTitleColor.withAlphaComponent(0.7)
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        let anchorPointLabelTitle = CGPoint(x: 0,y: 0)
        titleLabel.layer.anchorPoint = anchorPointLabelTitle
    }
    
    private func configInputTextField() {
        inputTextField.borderStyle = .none
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        inputTextField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        inputTextField.textColor = inputTextColor
        inputTextField.addTarget(self, action: #selector(textFieldDidBeginEditting(sender:)), for: .editingDidBegin)
        inputTextField.addTarget(self, action: #selector(textFieldDidEndEditting(sender:)), for: .editingDidEnd)
        inputTextField.delegate = delegate
        inputTextField.tag = inputTag
        let toolbarTextField = UIToolbar()
        toolbarTextField.sizeToFit()
        let barButtonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                            target: self, action: #selector(CustomInputField.onDoneClick))
        let barButtonPlex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let barButtonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                              target: self, action: #selector(CustomInputField.onCancelClick))
        
        toolbarTextField.items = [barButtonCancel, barButtonPlex, barButtonDone]
        inputTextField.inputAccessoryView = toolbarTextField
        
    }
    
    @objc func onDoneClick() {
        self.inputTextField.endEditing(true)
    }
    
    @objc func onCancelClick() {
        self.inputTextField.text = ""
        self.inputTextField.endEditing(true)
    }
    
    @objc func textFieldDidBeginEditting(sender: Any) {
        if (inputTextField.text == nil || inputTextField.text!.isEmpty) {
            moveTitleToTop()
        }
    }
    
    @objc func textFieldDidEndEditting(sender: Any) {
        if (inputTextField.text == nil || inputTextField.text!.isEmpty) {
            moveTitleToCenter()
        }
    }
    
    private func moveTitleToCenter() {
        let transformMove = CGAffineTransform(translationX: 0, y: 0)
        let transformScale = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.titleLabel.transform = transformMove.concatenating(transformScale)
        }, completion: nil)
    }
    
    private func moveTitleToTop(completed: (() -> ())? = nil) {
        let transformMove = CGAffineTransform(translationX: 0, y: -10)
        let transformScale = CGAffineTransform(scaleX: 0.625, y: 0.625)
        UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.titleLabel.transform = transformMove.concatenating(transformScale)
        }, completion: { _ in
            completed?()
        })
    }
    
    override func becomeFirstResponder() -> Bool {
        self.inputTextField.becomeFirstResponder()
        return true
    }
//    override func canBecomeFirstResponder() -> Bool {
//        return true
//    }
//
//    //canbe
//    
//    override func isFirstResponder() -> Bool {
//        self.inputTextField.isFirstResponder
//        return true
//    }
}
