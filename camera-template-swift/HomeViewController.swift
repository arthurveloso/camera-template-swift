//
//  HomeViewController.swift
//  camera-template-swift
//
//  Created by Tainá Cabral Benjamin on 15/04/20.
//  Copyright © 2020 Arthur Melo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private var cameFromPicker = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !cameFromPicker {
            presentLibraryPicker()
        }
    }

    private func presentLibraryPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.modalPresentationStyle = .fullScreen
        cameFromPicker = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    private func goToPreview(with image: UIImage) {
        let previewController = PreviewViewController()
        previewController.image = image
        cameFromPicker = false
        self.navigationController?.pushViewController(previewController, animated: true)
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: { [weak self] in
            self?.goToPreview(with: image)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UINavigationBar.appearance().tintColor = .clear
    }
}
