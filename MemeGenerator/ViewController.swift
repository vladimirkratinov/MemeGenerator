//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Vladimir Kratinov on 2022/7/3.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var addTopTextButton = HighlightedButtonGreen(type: .system)
    var addBottomTextButton = HighlightedButtonGreen(type: .system)
    
    var topText: String?
    var bottomText: String?

    let imageView = UIImageView()
    var images = [UIImage]()
    
    override func loadView() {
        view = UIView()
        view.sizeToFit()
        view.backgroundColor = UIColor(red: 0.00, green: 0.42, blue: 0.40, alpha: 1.00)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addTopTextButton.translatesAutoresizingMaskIntoConstraints = false
        addBottomTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        addTopTextButton.setTitle("Add Top Text", for: .normal)
        addTopTextButton.titleLabel?.font = UIFont(name: "Inter", size: 30)
        addTopTextButton.layer.cornerRadius = 10
        addTopTextButton.layer.shadowColor = UIColor.black.cgColor
        addTopTextButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addTopTextButton.layer.shadowRadius = 1
        addTopTextButton.layer.shadowOpacity = 1.0
        addTopTextButton.tintColor = UIColor.black
        addTopTextButton.backgroundColor = customColor
        addTopTextButton.layer.shouldRasterize = true
        addTopTextButton.layer.rasterizationScale = UIScreen.main.scale
        addTopTextButton.tag = 1
        addTopTextButton.addTarget(self, action: #selector(addTopTextButtonTapped), for: .touchUpInside)
        view.addSubview(addTopTextButton)
        
        addBottomTextButton.setTitle("Add Bottom Text", for: .normal)
        addBottomTextButton.titleLabel?.font = UIFont(name: "Inter", size: 30)
        addBottomTextButton.layer.cornerRadius = 10
        addBottomTextButton.layer.shadowColor = UIColor.black.cgColor
        addBottomTextButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addBottomTextButton.layer.shadowRadius = 1
        addBottomTextButton.layer.shadowOpacity = 1.0
        addBottomTextButton.tintColor = UIColor.black
        addBottomTextButton.backgroundColor = customColor
        addBottomTextButton.layer.shouldRasterize = true
        addBottomTextButton.layer.rasterizationScale = UIScreen.main.scale
        addBottomTextButton.tag = 1
        addBottomTextButton.addTarget(self, action: #selector(addBottomTextButtonTapped), for: .touchUpInside)
        view.addSubview(addBottomTextButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 512),
//            imageView.heightAnchor.constraint(equalToConstant: 512),
            
            addTopTextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            addTopTextButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            addTopTextButton.heightAnchor.constraint(equalToConstant: 30),
            addTopTextButton.widthAnchor.constraint(equalToConstant: 160),
            
            addBottomTextButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -180),
            addBottomTextButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            addBottomTextButton.heightAnchor.constraint(equalToConstant: 30),
            addBottomTextButton.widthAnchor.constraint(equalToConstant: 160),
        ])
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(sharePicture))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationController?.isToolbarHidden = true
    }

    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 400, height: 400).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)

            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = img
    }
    
    func drawImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        //context
        let image = renderer.image { ctx in
            
            let importedImage = images.first
            importedImage?.draw(at: CGPoint(x: 0, y: 0), blendMode: .overlay, alpha: 1)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "DINCondensed-Bold", size: 60)!,
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            
            //addTopText
            let attributedTopString = NSAttributedString(string: topText ?? "", attributes: attrs)
            attributedTopString.draw(
                with: CGRect(x: 32, y: 10, width: 448, height: 448),
                options: .usesLineFragmentOrigin,
                context: nil)
            
            //addBottomText
            let attributedBottomString = NSAttributedString(string: bottomText ?? "", attributes: attrs)
            attributedBottomString.draw(
                with: CGRect(x: 32, y: 450, width: 448, height: 448),
                options: .usesLineFragmentOrigin,
                context: nil)
            
            importedImage?.draw(at: CGPoint(x: 0, y: 0), blendMode: .overlay, alpha: 1)
        }
        
        imageView.image = image
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        drawImage()
        print(imageView.layer.position)
    }
    
    @objc func addTopTextButtonTapped() {
        
        let ac = UIAlertController(title: "Print Text:", message: nil, preferredStyle: .alert)
        
        ac.addTextField { field in
            field.placeholder = "type here..."
            field.returnKeyType = .done
            field.keyboardType = .default
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let topField = ac.textFields else { return }

            let textInField = topField[0]
            guard let answer = textInField.text else { return }
            
            self.topText = answer
            self.drawImage()
        }))
        
        present(ac, animated: true)
    }
    
    @objc func addBottomTextButtonTapped() {
        
        let ac = UIAlertController(title: "Print Text:", message: nil, preferredStyle: .alert)
        
        ac.addTextField { field in
            field.placeholder = "type here..."
            field.returnKeyType = .done
            field.keyboardType = .default
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let bottomField = ac.textFields else { return }

            let textInField = bottomField[0]
            guard let answer = textInField.text else { return }
            
            self.bottomText = answer
            self.drawImage()
        }))
        
        present(ac, animated: true)
    }
    
    @objc func sharePicture() {
        guard let image = imageView.image else { return }
 
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        // exclude some activity types from the list (optional)
        ac.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.postToFacebook
        ]
        
        present(ac, animated: true)
    }
    
}

