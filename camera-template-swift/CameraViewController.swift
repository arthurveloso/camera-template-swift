//
//  CameraViewController.swift
//  camera-template-swift
//
//  Created by Tainá Cabral Benjamin on 15/04/20.
//  Copyright © 2020 Arthur Melo. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
//        AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
//        guard let backCamera = AVCaptureDevice.default(for: .video) else {
//                print("Unable to access back camera!")
//                return
//        }
        var back: AVCaptureDevice?
        if #available(iOS 11.1, *) {
            guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                return
            }
            back = backCamera
        } else {
            guard let backCamera = AVCaptureDevice.default(for: .video) else {
                print("Unable to access back camera!")
                return
            }
            back = backCamera
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: back!)

            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
                setupOverlay()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }

    func setupOverlay() {
        guard let image = UIImage(named: "arthur.jpg") else { return }
        let imageView = UIImageView(image: image)
        imageView.frame = self.view.frame
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.5
        self.view.addSubview(imageView)
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        view.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.videoPreviewLayer.frame = self.view.bounds
            }
        }
    }
    
}
