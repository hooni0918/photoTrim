//
//  CropAreaView.swift
//  PhotoTrim
//
//  Created by 이지훈 on 12/24/24.
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
