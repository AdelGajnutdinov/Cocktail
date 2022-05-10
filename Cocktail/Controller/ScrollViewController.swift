//
//  ScrollViewController.swift
//  Cocktail
//
//  Created by Adel Gainutdinov on 09.05.2022.
//

import UIKit
import SnapKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    let scrollView = UIScrollView()
    let contentView = UIView()
    var buttonsView = UIView()
    
    private var dataFetcher: DataFetcher!
    private var drinks: [Drink]! {
        didSet {
            setupButtonsView()
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
    private var textField: CustomTextField!
    private var textFieldWidthConstraint1: Constraint?
    private var textFieldWidthConstraint2: Constraint?
    private var textFieldBottomConstraint: Constraint?
    
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
        
        // Views
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
        contentView.addSubview(buttonsView)
        
        // TextField
        textField = CustomTextField()
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.delegate = self
        view.addSubview(textField!)
        textField.snp.makeConstraints { make in
            make.height.equalTo(40)
            textFieldWidthConstraint1 = make.width.equalTo(view.frame.width * 0.8).constraint
            textFieldWidthConstraint2 = make.width.equalTo(view.frame.width).constraint
            textFieldWidthConstraint2!.deactivate()
            make.centerX.equalTo(view.snp.centerX)
            textFieldBottomConstraint = make.bottom.equalTo(view).inset(view.frame.height * 0.2).constraint
        }
    }
    
    private func setupButtonsView() {
        activityIndicator.stopAnimating()
        
        var buttonsViewHeight: CGFloat = 0
        let offset: CGFloat = 8
        var isFirstInRow = true
        let viewWidth = view.frame.width
        var currentRowWidth: CGFloat = 0
        var prevTopView = buttonsView.safeAreaLayoutGuide.snp.top
        var prevLeadingView: UIView = buttonsView
        
        for i in 0..<drinks.count {
            let buttonTitle = drinks[i].name
            let button = CustomButton()
            button.titleText = buttonTitle
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.buttonsView.addSubview(button)
            buttons.append(button)
            button.snp.makeConstraints { make in
                let buttonWidth = button.buttonTitleSize!.width + 20
                let buttonHeight = button.buttonTitleSize!.height + 20
                make.height.equalTo(buttonHeight)
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
                    buttonsViewHeight += buttonHeight + offset
                }
                else {
                    make.leading.equalTo(prevLeadingView.snp.trailing).offset(offset)
                }
                make.top.equalTo(prevTopView).offset(offset)
                prevLeadingView = button
            }
        }
        
        buttonsView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(contentView)
            make.height.equalTo(buttonsViewHeight)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textFieldWidthConstraint1!.deactivate()
            textFieldWidthConstraint2!.activate()
            textFieldBottomConstraint!.update(inset: keyboardSize.height + CGFloat(textField?.layer.shadowRadius ?? 0))
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        textFieldWidthConstraint1!.activate()
        textFieldWidthConstraint2!.deactivate()
        textFieldBottomConstraint!.update(inset: view.frame.height * 0.2)
    }
    
    @objc func buttonAction(sender: CustomButton!) {
        if textField?.text?.count == 0 { // not in search mode
            selectedButton = sender
        }
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldEditingChanged() {
        selectedButton = nil
        if let text = textField?.text, text.count > 0 {
            let textLowercased = text.lowercased()
            buttons.forEach { button in
                button.isSelected = button.titleText!.lowercased().contains(textLowercased)
            }
        } else {
            buttons.forEach { button in
                button.isSelected = false
            }
        }
    }
}

extension ScrollViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
