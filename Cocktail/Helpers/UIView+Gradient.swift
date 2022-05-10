//
//  UIView+Gradient.swift
//  Cocktail
//
//  Created by Adel Gainutdinov on 29.03.2022.
//

import UIKit

extension UIView {

    func applyGradient(colors: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colors: colors, locations: nil)
    }

    func applyGradient(colors: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
