//
//  ResultViewController.swift
//  camera-template-swift
//
//  Created by Arthur Melo on 05/05/20.
//  Copyright © 2020 Arthur Melo. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    lazy var resultImageView = {
        return UIImageView()
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Salvar foto", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveImagePressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSubviews()
    }
    
    private func addSubviews() {
        self.view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func saveImagePressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
