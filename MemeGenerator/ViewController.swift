//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Vladimir Kratinov on 2022/7/3.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var images = [UIImage]()
    var imageView = UIImageView()
    var topText: String?
    var bottomText: String?
    
    override func loadView() {
        let view = DetailUIView()
        
        imageView.alpha = 0
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "600x600")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        images.insert(UIImage(named: "600x600")!, at: 0)
        
        view.addTopTextButton.addTarget(self, action: #selector(addTopTextButtonTapped), for: .touchUpInside)
        view.addBottomTextButton.addTarget(self, action: #selector(addBottomTextButtonTapped), for: .touchUpInside)
        
        view.addSubview(imageView)
        self.view = view
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 512),
            imageView.heightAnchor.constraint(equalToConstant: 512)
            ])
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clear navigationBar color & shadow
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        title = "MemeGenerator v0.1"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(sharePicture))
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .purple
        
        //animation of imageView
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3) {
                self.imageView.alpha = 0.1
                }
        }
        
    }
    
    func drawImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { _ in
            
            let importedImage = images.first
            importedImage?.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "impact", size: 55)!,
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -4,
                .paragraphStyle: paragraphStyle
            ]
            
            //addTopText
            let attributedTopString = NSAttributedString(string: topText ?? "", attributes: attrs)
            attributedTopString.draw(
                with: CGRect(x: 32, y: -5, width: 448, height: 448),
                options: .usesLineFragmentOrigin,
                context: nil)
            
            //addBottomText
            let attributedBottomString = NSAttributedString(string: bottomText ?? "", attributes: attrs)
            attributedBottomString.draw(
                with: CGRect(x: 32, y: 440, width: 448, height: 448),
                options: .usesLineFragmentOrigin,
                context: nil)
        }
        
        imageView.alpha = 1
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
        
        images.removeAll()
        images.insert(image, at: 0)
        topText = ""
        bottomText = ""
        drawImage()
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
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        let itemsList: [Any] = [image]
 
        let ac = UIActivityViewController(activityItems: itemsList, applicationActivities: nil)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
}
