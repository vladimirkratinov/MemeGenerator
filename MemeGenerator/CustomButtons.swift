//
//  CustomButtons.swift
//  MemeGenerator
//
//  Created by Vladimir Kratinov on 2022/7/4.
//

import UIKit

let customColor = UIColor(red: 0.30, green: 0.54, blue: 0.81, alpha: 1.00)

class HighlightedButtonGreen: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .green : customColor
        }
    }
}
