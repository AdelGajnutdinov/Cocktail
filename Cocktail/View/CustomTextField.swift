//
//  CustomTextField.swift
//  Cocktail
//
//  Created by Adel Gainutdinov on 30.03.2022.
//

import UIKit

final class CustomTextField: UITextField {
    
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        textAlignment = .center
        autocapitalizationType = .none
        
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        attributedPlaceholder = NSAttributedString(
            string: "Cocktail name",
            attributes: [.paragraphStyle: centeredParagraphStyle,
                         .font: UIFont.systemFont(ofSize: 16)]
        )

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = .zero
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius = 3

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
