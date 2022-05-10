//
//  CustomTextField.swift
//  Cocktail
//
//  Created by Adel Gainutdinov on 30.03.2022.
//

import UIKit

final class CustomTextField: UITextField {
    
    private let darkGray = UIColor.darkGray.cgColor
    private let cornerRadius: CGFloat = 12
    
    private var shadowLayer: CAShapeLayer?
    
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
        
        shadowLayer?.removeFromSuperlayer()
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        print(bounds)
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = darkGray
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 3
        
        layer.insertSublayer(shadowLayer, at: 0)
        self.shadowLayer = shadowLayer
    }
}
