//
//  HomeViewController.swift
//  camera-template-swift
//
//  Created by Tainá Cabral Benjamin on 15/04/20.
//  Copyright © 2020 Arthur Melo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    @IBAction func magicButtonClicked(_ sender: UIButton) {
        presentDefaultPicker()
    }
    
    private func presentDefaultPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePicker = UIImagePickerController()
        guard let image = UIImage(named: "arthur.jpg") else { return }
        let imageView = UIImageView(image: image)
        imageView.frame = imagePicker.view.frame
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.5
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraOverlayView = imageView
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Disabled
    private func goToCustomCamera() {
        let viewController = CameraViewController()
        viewController.view.backgroundColor = .white
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let _ = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
    }
}
