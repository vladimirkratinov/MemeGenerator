//
//  DetailUIView.swift
//  MemeGenerator
//
//  Created by Vladimir Kratinov on 2022/7/6.
//

import UIKit

class DetailUIView: UIView {
    
    var addTopTextButton = HighlightedButtonGreen(type: .system)
    var addBottomTextButton = HighlightedButtonGreen(type: .system)
    var backgroundImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
        createConstraints()
    }
    
    func createSubviews() {        
        addTopTextButton.translatesAutoresizingMaskIntoConstraints = false
        addBottomTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background7")
        backgroundImage.contentMode =  .scaleAspectFill
        backgroundImage.applyBlurEffect()
        
        self.insertSubview(backgroundImage, at: 0)
        
        addTopTextButton.setTitle("Add Top Text", for: .normal)
        addTopTextButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 14)
        addTopTextButton.layer.cornerRadius = 2
        addTopTextButton.layer.shadowColor = UIColor.black.cgColor
        addTopTextButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addTopTextButton.layer.shadowRadius = 1
        addTopTextButton.layer.shadowOpacity = 1.0
        addTopTextButton.tintColor = UIColor.black
        addTopTextButton.backgroundColor = customColor
        addTopTextButton.layer.shouldRasterize = true
        addTopTextButton.layer.rasterizationScale = UIScreen.main.scale
        addTopTextButton.tag = 1
        
        self.addSubview(addTopTextButton)
        
        addBottomTextButton.setTitle("Add Bottom Text", for: .normal)
        addBottomTextButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 14)
        addBottomTextButton.layer.cornerRadius = 2
        addBottomTextButton.layer.shadowColor = UIColor.black.cgColor
        addBottomTextButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addBottomTextButton.layer.shadowRadius = 1
        addBottomTextButton.layer.shadowOpacity = 1.0
        addBottomTextButton.tintColor = UIColor.black
        addBottomTextButton.backgroundColor = customColor
        addBottomTextButton.layer.shouldRasterize = true
        addBottomTextButton.layer.rasterizationScale = UIScreen.main.scale
        addBottomTextButton.tag = 1
        
        self.addSubview(addBottomTextButton)
    }
    
    func createConstraints() {
        NSLayoutConstraint.activate([
            addTopTextButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 150),
            addTopTextButton.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            addTopTextButton.heightAnchor.constraint(equalToConstant: 30),
            addTopTextButton.widthAnchor.constraint(equalToConstant: 170),
            
            addBottomTextButton.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -180),
            addBottomTextButton.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            addBottomTextButton.heightAnchor.constraint(equalToConstant: 30),
            addBottomTextButton.widthAnchor.constraint(equalToConstant: 170),
        ])
    }
}

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
