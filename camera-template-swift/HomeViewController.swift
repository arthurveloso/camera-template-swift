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
        presentLibraryPicker()
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
    
    private func presentLibraryPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Disabled
    private func goToCustomCamera() {
        let viewController = CameraViewController()
        viewController.view.backgroundColor = .white
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func goToPreview(with imageView: UIImageView) {
        let previewController = PreviewViewController()
        previewController.previewImageView = imageView
        self.navigationController?.pushViewController(previewController,
                                                      animated: true)
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: { [weak self] in
            self?.goToPreview(with: UIImageView(image: image))
        })
    }
}
