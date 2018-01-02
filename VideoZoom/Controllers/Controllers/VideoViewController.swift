//
//  VideoViewController.swift
//  VideoZoom
//
//  Created by Ulugbek on 1/1/18.
//  Copyright © 2018 Ulugbek. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var customView: UIView!
    
    var captureDevice:AVCaptureDevice?
    var captureSecsion: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSecsion = AVCaptureSession()
            captureSecsion?.addInput(input)
            
            
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSecsion?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSecsion!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            customView.layer.addSublayer(videoPreviewLayer!)
            
            
            
            
        } catch {
            print(error)
            return
        }
        
        
        
        captureSecsion?.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSecsion?.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        
        var initialVideoZoomFactor: CGFloat = 0.0
        
        if (sender.state == UIGestureRecognizerState.began) {
            initialVideoZoomFactor = (self.captureDevice?.videoZoomFactor)!
        } else {
            let scale: CGFloat = min(max(1, 1 * sender.scale), 4)
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.01)
            self.videoPreviewLayer?.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
            CATransaction.commit()
            do {
                try captureDevice?.lockForConfiguration()
                self.captureDevice?.videoZoomFactor = scale
                self.captureDevice?.unlockForConfiguration()
            } catch {
                print(error)
            }
            
        }
    }

}
