//
//  PreviewViewController.swift
//  camera-template-swift
//
//  Created by Tainá Cabral Benjamin on 17/04/20.
//  Copyright © 2020 Arthur Melo. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMobileAds

class PreviewViewController: UIViewController {

    var image: UIImage?
    lazy var previewImage = UIImageView()
    lazy var opacityMeter = UISlider()
    lazy var continueButton = UIButton()
    lazy var dismissButton = UIButton()
    private var resultImage: UIImage?
    private var userDidWon = false
    
    // Ads
    var interstitial: GADInterstitial!
    var rewarded: GADRewardedAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cameraBlack()
        setImageView()
        setOpacityMeter()
        setButtons()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["9962130c54ebca147233912ef1d95182"]
//        interstitial = createAndLoadInterstitial()
        rewarded = createAndLoadRewardedAd()
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial {
      let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
    
    private func createAndLoadRewardedAd() -> GADRewardedAd {
        let rewarded = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewarded.load(GADRequest()) { error in
          if let _ = error {
            // Handle ad failed to load case.
          } else {
            // Ad successfully loaded.
          }
        }
        return rewarded
    }
    
    private func setImageView() {
        previewImage.image = image
        previewImage.contentMode = .scaleAspectFit
        self.view.addSubview(previewImage)
        previewImage.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).inset(200)
        }
    }
    
    private func setOpacityMeter() {
        opacityMeter.maximumValue = 1.0
        opacityMeter.minimumValue = 0.0
        opacityMeter.value = 1.0
        opacityMeter.tintColor = .white
        opacityMeter.addTarget(self, action: #selector(opacityChanged),
                               for: .valueChanged)
        self.view.addSubview(opacityMeter)
        opacityMeter.snp.makeConstraints { (make) in
            make.top.equalTo(previewImage.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setButtons() {
        self.view.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.backgroundColor = .black
        dismissButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.top.equalTo(opacityMeter.snp.bottom).offset(10)
        }
        
        self.view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = .black
        continueButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.top.equalTo(opacityMeter.snp.bottom).offset(10)
        }
    }
    
    @objc private func opacityChanged() {
        previewImage.alpha = CGFloat(opacityMeter.value)
    }
    
    @objc private func continuePressed() {
        presentDefaultPicker()
    }
    
    @objc private func dismissPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func presentDefaultPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePicker = UIImagePickerController()
        let imageView = UIImageView(image: image)
        imageView.frame = imagePicker.view.frame
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = CGFloat(opacityMeter.value)
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            let screenWidth = UIScreen.main.bounds.size.width
            let previewHeight = screenWidth + (screenWidth / 3)

            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(previewHeight)
        }
        
        self.present(imagePicker, animated: true, completion: nil)

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidCaptureItem"),
                                               object:nil,
                                               queue:nil,
                                               using: { note in
                                                imageView.isHidden = true
        })

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidRejectItem"),
                                               object:nil,
                                               queue:nil,
                                               using: { note in
                                                imageView.isHidden = false
        })
    }
}

extension PreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let rawImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        resultImage = rawImage
        if picker.cameraDevice == .front {
            guard let cgImage = resultImage?.cgImage else { return }
            resultImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .downMirrored)
        }
        if rewarded.isReady == true {
            self.dismiss(animated: true) {
                self.rewarded.present(fromRootViewController: self, delegate:self)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIColor {
    class func cameraBlack() -> UIColor {
        return UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)
    }
}

extension PreviewViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
}

extension PreviewViewController: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        userDidWon = true
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        rewarded = createAndLoadRewardedAd()
        if userDidWon {
            let resultController = ResultViewController()
            self.navigationController?.pushViewController(resultController,
                                                          animated: true)
        }
    }
}
