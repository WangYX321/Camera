//
//  ViewController.swift
//  Camera
//
//  Created by wyx on 2017/11/4.
//  Copyright © 2017年 wyx. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var takePictureBtn: UIButton!
    @IBOutlet weak var switchCameraBtn: UIButton!
    
    var isUsingBackCamera = true
    var captureSession = AVCaptureSession()
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    let backCamera = AVCaptureDevice.default(for: .video)
    let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Live Preview
        // 将音视频采集会话的预设设置为高分辨率照片--选择照片分辨率
        
        self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        
        do {
            
            // 当前设备输入端
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: self.frontCamera!)
            
            self.stillImageOutput = AVCaptureStillImageOutput()
            
            // 输出图像格式设置
            
            self.stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            self.captureSession.addInput(captureDeviceInput)
            
            self.captureSession.addOutput(self.stillImageOutput!)
            
        }
            
        catch {
            
            print(error)
            
            return
            
        }
        
        // 创建预览图层
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
        self.view.layer.addSublayer(previewLayer!)
        
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        self.previewLayer?.frame = view.layer.frame
        
        // 启动音视频采集的会话
        
        self.captureSession.startRunning()
        
        self.view.bringSubview(toFront: self.takePictureBtn)
        self.view.bringSubview(toFront: self.switchCameraBtn)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        // 获得音视频采集设备的连接
        
        let videoConnection = stillImageOutput?.connection(with: AVMediaType.video)
        
        // 输出端以异步方式采集静态图像
        
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (imageDataSampleBuffer, error) -> Void in
            
            // 获得采样缓冲区中的数据
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
            
            let uploadViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "uploadViewController") as! UploadViewController
            
            uploadViewController.imageToUse = UIImage(data: imageData!)!
            self.present(uploadViewController, animated: true, completion: nil)   
        })
    }
    
    @IBAction func switchCamera(_ sender: Any) {
        self.captureSession.beginConfiguration()
        let newDevice = (self.isUsingBackCamera) ? self.frontCamera : self.backCamera
        self.isUsingBackCamera = !self.isUsingBackCamera
        for input in (self.captureSession.inputs){
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        }
        catch {
            print(error)
            return
        }
        if (captureSession.canAddInput(cameraInput)) {
            captureSession.addInput(cameraInput)
        }
        self.captureSession.commitConfiguration()
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let imageCaptured = UIImage(data: imageData!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "uploadViewController") as! UploadViewController
        vc.image.image = imageCaptured
        self.present(vc, animated: true, completion: nil)
    }
}

