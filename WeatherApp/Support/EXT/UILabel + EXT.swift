//
//  UILabel + EXT.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit

extension UILabel {
    func addTextShadowAndOutline(shadowColor: UIColor = .black,
                                 shadowOffset: CGSize = CGSize(width: 1, height: 1),
                                 shadowRadius: CGFloat = 0.3,
                                 outlineColor: UIColor = .black,
                                 outlineWidth: CGFloat = -0.3,
                                 textColor: UIColor = .white) {

        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = shadowOffset
        shadow.shadowBlurRadius = shadowRadius

        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: outlineColor,
            .strokeWidth: outlineWidth,
            .foregroundColor: textColor,
            .shadow: shadow
        ]

        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
}
