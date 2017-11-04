//
//  CornerMark.swift
//  Camera
//
//  Created by wyx on 2017/11/4.
//  Copyright © 2017年 wyx. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum CornerMark {
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    //添加水印方法
    func addMarkedImage(markText:String, corner:CornerMark = .BottomRight,
                          margin:CGPoint = CGPoint(x: 20, y: 20),
                          markTextColor:UIColor = UIColor.white,
                          markTextFont:UIFont = UIFont.systemFont(ofSize: 20),
                          backgroundColor:UIColor = UIColor.clear) -> UIImage{
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:markTextColor,
                              NSAttributedStringKey.font:markTextFont,
                              NSAttributedStringKey.backgroundColor:backgroundColor]
        let textSize = NSString(string: markText).size(withAttributes: textAttributes)
        var textFrame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                       y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        NSString(string: markText).draw(in: textFrame, withAttributes: textAttributes)
        
        let markedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return markedImage!
    }
}
