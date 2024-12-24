//
//  CropAreaView.swift
//  PhotoTrim
//
//  Created by 이지훈 on 12/24/24.
//
//  Copyright (c) 2024 hooni0918. All rights reserved.
//  This source code is licensed under the MIT license found in the LICENSE file
//  in the root directory of this source tree.
//

import UIKit

public class CropAreaView: UIView {
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.backgroundColor?.setFill()
        UIRectFill(rect)
        
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        
        // Create circular crop area
        path.addRoundedRect(
            in: bounds,
            cornerWidth: bounds.width/2,
            cornerHeight: bounds.width/2
        )
        path.addRect(bounds)
        
        layer.path = path
        layer.fillRule = .evenOdd
        
        self.layer.mask = layer
    }
}
