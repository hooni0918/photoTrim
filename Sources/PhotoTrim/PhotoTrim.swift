//
//  PhotoTrimView.swift
//  PhotoTrim
//
//  Created by hooni0918 on 2024/01/10.
//
//  Copyright (c) 2024 hooni0918. All rights reserved.
//  This source code is licensed under the MIT license found in the LICENSE file
//  in the root directory of this source tree.
//

import UIKit

public class PhotoTrimView: UIView {
    // MARK: - Public Properties
    public private(set) var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    public private(set) var cropAreaView: CropAreaView = {
        let view = CropAreaView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    public var minimumZoomScale: CGFloat = 1.0
    public var maximumZoomScale: CGFloat = 3.0
    public var shouldShowGuideLines: Bool = true
    
    // MARK: - Private Properties
    private let pinchGR = UIPinchGestureRecognizer()
    private let panGR = UIPanGestureRecognizer()
    
    private var imageViewWidthConstraint: NSLayoutConstraint?
    private var imageViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        clipsToBounds = true
        
        // Add subviews
        addSubview(imageView)
        addSubview(cropAreaView)
        
        // Setup gesture recognizers
        setupGestureRecognizers()
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupGestureRecognizers() {
        pinchGR.addTarget(self, action: #selector(handlePinch(_:)))
        pinchGR.delegate = self
        cropAreaView.addGestureRecognizer(pinchGR)
        
        panGR.addTarget(self, action: #selector(handlePan(_:)))
        panGR.delegate = self
        cropAreaView.addGestureRecognizer(panGR)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cropAreaView.translatesAutoresizingMaskIntoConstraints = false
        
        // Center image view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Setup crop area view constraints
        NSLayoutConstraint.activate([
            cropAreaView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cropAreaView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cropAreaView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            cropAreaView.heightAnchor.constraint(equalTo: cropAreaView.widthAnchor)
        ])
    }
    
    // MARK: - Public Methods
    public func setImage(_ image: UIImage) {
        imageView.image = image
        setupImageViewSize(for: image)
    }
    
    public func getCroppedImage() -> UIImage? {
        return PhotoTrimmer.crop(imageView.image,
                               cropRect: cropAreaView.frame,
                               imageViewFrame: imageView.frame)
    }
    
    // MARK: - Private Methods
    private func setupImageViewSize(for image: UIImage) {
        let imageRatio = image.size.width / image.size.height
        let cropViewRatio = cropAreaView.frame.width / cropAreaView.frame.height
        let screenWidth = UIScreen.main.bounds.width
        
        imageViewWidthConstraint?.isActive = false
        imageViewHeightConstraint?.isActive = false
        
        if cropViewRatio > imageRatio {
            imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: screenWidth)
            imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: screenWidth / imageRatio)
        } else {
            imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: screenWidth * imageRatio)
            imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: screenWidth)
        }
        
        imageViewWidthConstraint?.isActive = true
        imageViewHeightConstraint?.isActive = true
    }
}

// MARK: - Gesture Handling
extension PhotoTrimView: UIGestureRecognizerDelegate {
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            var transform = imageView.transform
            transform = transform.scaledBy(x: gesture.scale, y: gesture.scale)
            imageView.transform = transform
        case .ended:
            handlePinchEnded()
        default:
            break
        }
        gesture.scale = 1.0
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        imageView.center = CGPoint(
            x: imageView.center.x + translation.x,
            y: imageView.center.y + translation.y
        )
        gesture.setTranslation(.zero, in: self)
        
        if gesture.state == .ended {
            keepImageInCropArea()
        }
    }
    
    private func handlePinchEnded() {
        var transform = imageView.transform
        var needsAdjustment = false
        
        if transform.a < minimumZoomScale {
            transform = .identity
            needsAdjustment = true
        }
        
        if transform.a > maximumZoomScale {
            transform.a = maximumZoomScale
            transform.d = maximumZoomScale
            needsAdjustment = true
        }
        
        if needsAdjustment {
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = transform
            }
        }
    }
    
    private func keepImageInCropArea() {
        let imageRect = imageView.frame
        let cropRect = cropAreaView.frame
        var correctedFrame = imageRect
        
        if imageRect.minY > cropRect.minY {
            correctedFrame.origin.y = cropRect.minY
        }
        if imageRect.maxY < cropRect.maxY {
            correctedFrame.origin.y = cropRect.maxY - imageRect.height
        }
        if imageRect.minX > cropRect.minX {
            correctedFrame.origin.x = cropRect.minX
        }
        if imageRect.maxX < cropRect.maxX {
            correctedFrame.origin.x = cropRect.maxX - imageRect.width
        }
        
        if imageRect != correctedFrame {
            UIView.animate(withDuration: 0.3) {
                self.imageView.frame = correctedFrame
            }
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                 shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
