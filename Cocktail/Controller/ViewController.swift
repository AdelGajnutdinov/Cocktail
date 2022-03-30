//
//  ViewController.swift
//  Cocktail
//
//  Created by Adel Gainutdinov on 29.03.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private var dataFetcher: DataFetcher!
    private var drinks: [Drink]! {
        didSet {
            setupViews()
        }
    }
    
    private var buttons = [CustomButton]()
    private var selectedButton: CustomButton? {
        willSet {
            selectedButton?.toggleState()
            newValue?.toggleState()
        }
    }
    private var activityIndicator = UIActivityIndicatorView()
    private var textField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
         let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // ActivityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicator.startAnimating()
        
        // Data fetching
        dataFetcher = NetworkDataFetcher()
        dataFetcher.fetchDrinks(with: ["a" : "Non_Alcoholic"]) { [unowned self] drinks in
            self.drinks = drinks
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textField!.snp.remakeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(view.frame.width * 0.8)
                make.centerX.equalTo(view.snp.centerX)
                make.bottom.equalTo(view).inset(keyboardSize.height + CGFloat(textField?.layer.shadowRadius ?? 0))
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        textField!.snp.remakeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(view.frame.width * 0.8)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view).inset(200)
        }
    }
    
    private func setupViews() {
        activityIndicator.stopAnimating()
        
        let offset: CGFloat = 8
        var isFirstInRow = true
        let viewWidth = view.frame.width
        var currentRowWidth: CGFloat = 0
        var prevTopView = view.safeAreaLayoutGuide.snp.top
        var prevLeadingView: UIView = view
        
        for i in 0..<drinks.count {
            if i == 15 {
                break //scrollView needed
            }
            let buttonTitle = drinks[i].name
            let button = CustomButton()
            button.titleText = buttonTitle
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            view.addSubview(button)
            buttons.append(button)
            button.snp.makeConstraints { make in
                let buttonWidth = button.buttonTitleSize!.width + 20
                make.height.equalTo(button.buttonTitleSize!.height + 20)
                make.width.equalTo(buttonWidth)
                
                currentRowWidth += offset + buttonWidth
                if currentRowWidth > viewWidth - offset {
                    isFirstInRow = true
                    currentRowWidth = offset + buttonWidth
                    prevTopView = buttons[i - 1].snp.bottom
                }
                if isFirstInRow {
                    make.leading.equalToSuperview().offset(offset)
                    isFirstInRow = false
                }
                else {
                    make.leading.equalTo(prevLeadingView.snp.trailing).offset(offset)
                }
                make.top.equalTo(prevTopView).offset(offset)
                prevLeadingView = button
            }
        }
        
        // TextField
        textField = CustomTextField()
        textField!.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField!.delegate = self
        view.addSubview(textField!)
        textField!.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(view.frame.width * 0.8)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view).inset(200)
        }
    }
    
    @objc func buttonAction(sender: CustomButton!) {
        if textField?.text?.count == 0 { // not in search mode
            selectedButton = sender
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldEditingChanged() {
        selectedButton = nil
        if let text = textField?.text, text.count > 0 {
            buttons.forEach { button in
                button.isSelected = button.titleText!.contains(text)
            }
        } else {
            buttons.forEach { button in
                button.isSelected = false
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
