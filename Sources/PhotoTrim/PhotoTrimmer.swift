//
//  PhotoTrimmer.swift
//  PhotoTrim
//
//  Created by 이지훈 on 12/24/24.
//  Copyright (c) 2024 hooni0918. All rights reserved.
//  This source code is licensed under the MIT license found in the LICENSE file
//  in the root directory of this source tree.
//

import UIKit

public class PhotoTrimmer {
    public static func crop(_ image: UIImage?,
                          cropRect: CGRect,
                          imageViewFrame: CGRect) -> UIImage? {
        guard let image = image else { return nil }
        
        let xCrop = cropRect.minX - imageViewFrame.minX
        let yCrop = cropRect.minY - imageViewFrame.minY
        let widthCrop = cropRect.width
        let heightCrop = cropRect.height
        
        // Calculate scale ratio between original image and displayed image
        let scaleRatio = image.size.width / imageViewFrame.width
        
        // Create scaled crop rect
        let scaledCropRect = CGRect(
            x: xCrop * scaleRatio,
            y: yCrop * scaleRatio,
            width: widthCrop * scaleRatio,
            height: heightCrop * scaleRatio
        )
        
        // Perform cropping
        guard let cutImageRef = image.cgImage?.cropping(to: scaledCropRect) else {
            return nil
        }
        
        return UIImage(cgImage: cutImageRef)
    }
}
