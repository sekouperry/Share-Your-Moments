//
//  CameraVC.swift
//  SnappySnap
//
//  Created by Isomi on 4/23/17.
//  Copyright © 2017 Humberto Espinola. All rights reserved.
//

import UIKit
import CameraManager

class CameraVC: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var snapButton: UIButton!
    @IBOutlet weak var changeCameraButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    // MARK: - Class Members
    private let cameraManager = CameraManager()
    private var flashActivatedImage: UIImage!
    private var flashAutoImage: UIImage!
    
    // MARK: - Override controller life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: .stillImage)
        cameraManager.cameraOutputQuality = .high
        cameraManager.flashMode = .auto
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.shouldRespondToOrientationChanges = false
        
        flashActivatedImage = UIImage(named: "flash_btn")
        flashAutoImage = UIImage(named: "flash_auto_btn")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraManager.resumeCaptureSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    @IBAction func snapButtonTapped(_ sender: Any) {
        cameraManager.capturePictureWithCompletion({ (image, error) in
            if let image = image {
                self.performSegue(withIdentifier: "EditImageVC", sender: image)
            }
        })
    }
    
    @IBAction func changeCameraButtonTapped(_ sender: Any) {
        cameraManager.cameraDevice = cameraManager.cameraDevice == .back ? .front : .back
    }
    
    @IBAction func flashButtonTapped(_ sender: Any) {
        switch (cameraManager.changeFlashMode()) {
            case .off:
                flashButton.setImage(flashActivatedImage, for: .normal)
                flashButton.alpha = 0.5
                break
            
            case .on:
                flashButton.setImage(flashActivatedImage, for: .normal)
                flashButton.alpha = 1
                break
            
            case .auto:
                flashButton.setImage(flashAutoImage, for: .normal)
                flashButton.alpha = 1
                break
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditImageVC" {
            if let editImageVC = segue.destination as? EditImageVC {
                if let image = sender as? UIImage {
                    editImageVC.image = image
                }
            }
        }
    }
 

}