//
//  Network.swift
//  Camera
//
//  Created by wyx on 2017/11/4.
//  Copyright © 2017年 wyx. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Network {
   
    static let sharedInstance = Network()
    fileprivate init() {
    }
    
    func upload(uploadImage: UIImage, address: String, scale: Double, success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        Alamofire.upload(multipartFormData: { (formData) in
            let data = UIImageJPEGRepresentation(uploadImage, CGFloat(scale))
            let imageName = "\(NSDate())" + ".png"
            
            //multipartFormData.appendBodyPart(data: ,name: ,fileName: ,mimeType: )这里把图片转为二进制,作为第一个参数
            formData.append(data!, withName: imageName, mimeType: "image/png")
        }, to: address) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let value = response.result.value as? [String: AnyObject]{
                        success(value)
//                        let json = JSON(value)
//                        print(json)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                failture(encodingError)
            }
        }
    }
}
