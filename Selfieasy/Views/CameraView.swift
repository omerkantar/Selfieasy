//
//  CameraView.swift
//  Selfieasy
//
//  Created by omer on 18.01.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

import AVFoundation

class CameraView: UIView {
    
    // AVFoundation properties
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var captureDeviceFormat: AVCaptureDeviceFormat?
    let stillImageOutput = AVCaptureStillImageOutput()
    var cameraLayer: AVCaptureVideoPreviewLayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCamera()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCamera()
    }
    
    func initCamera() {
        captureSession.beginConfiguration()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        // get the front camera
        if let device = cameraDeviceForPosition(position: AVCaptureDevicePosition.front) {
            
            captureDevice = device
            captureDeviceFormat = device.activeFormat
            
            var error: NSError?
            
            do {
                try captureDevice!.lockForConfiguration()
            } catch let error1 as NSError {
                error = error1
            }
            //            captureDevice!.focusMode = AVCaptureFocusMode.Locked
            //            captureDevice!.unlockForConfiguration()
            
            var deviceInput: AVCaptureDeviceInput!
            
            do {
                deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            } catch let error1 as NSError {
                error = error1
                deviceInput = nil
            }
            
            
            if(error == nil) {
                captureSession.addInput(deviceInput)
            }
            
            captureSession.addOutput(stillImageOutput)
            
            // use the high resolution photo preset
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            
            
            // setup camera preview
            cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            
            if let player = cameraLayer {
                player.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.layer.addSublayer(player)
                player.frame = self.layer.bounds
                player.connection.videoOrientation = AVCaptureVideoOrientation.portrait
            }
            
            // commit and start capturing
            captureSession.commitConfiguration()
            captureSession.startRunning()
        }
        
        captureSession.commitConfiguration()
    }
    
    func setFocusWithLensPosition(pos: CFloat) {
        var error: NSError?
        
        do {
            try captureDevice!.lockForConfiguration()
        } catch let error1 as NSError {
            error = error1
        }
        
        
        captureDevice!.setFocusModeLockedWithLensPosition(pos, completionHandler: nil)
        captureDevice!.unlockForConfiguration()
    }
    
    // return the camera device for a position
    func cameraDeviceForPosition(position:AVCaptureDevicePosition) -> AVCaptureDevice?
    {
        for device: Any in AVCaptureDevice.devices() {
            if ((device as AnyObject).position == position) {
                return device as? AVCaptureDevice;
            }
        }
        
        return nil
    }
    
    
    func takePhoto(completion: @escaping (_ img: UIImage) -> ()) {
        
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                (sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProvider(data: imageData as! CFData)
                let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.relativeColorimetric)
                
                let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                
                let imageView = UIImageView(image: image)
                
                imageView.frame = CGRect(x:0, y:0, width: self.frame.size.width, height: self.frame.size.height)
                
                completion(image)
                
                //Save the captured preview to image
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
            })
        }

    }
    
}
