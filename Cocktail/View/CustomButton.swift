//
//  CustomButton.swift
//  Cocktail
//
//  Created by Adel Gainutdinov on 29.03.2022.
//

import UIKit

class CustomButton: UIButton {
    
    let buttonFontSize: CGFloat = 14
    var buttonTitleSize: CGSize?

    var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.buttonTitleSize = (titleText! as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(buttonFontSize))])
        }
    }
    
    private var gradientLayer: CAGradientLayer?
    override var isSelected: Bool {
        didSet {
            gradientLayer?.removeFromSuperlayer()
            if isSelected {
                if gradientLayer == nil {
                    gradientLayer = self.applyGradient(colors: [UIColor(hex: 0xEC666A), UIColor(hex: 0xEA62F7)])
                } else {
                    self.layer.insertSublayer(gradientLayer!, at: 0)
                }
            }
        }
    }

    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 10
        self.titleLabel?.font = .systemFont(ofSize: buttonFontSize)
    }
    
    func toggleState() {
        isSelected.toggle()
    }
}
