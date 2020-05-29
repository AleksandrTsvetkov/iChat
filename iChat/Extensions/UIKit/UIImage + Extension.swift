//
//  UIImage + Extension.swift
//  iChat
//
//  Created by Александр Цветков on 29.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

extension UIImage {
    
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 400
        let largerSide: CGFloat = max(size.height, size.width)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
