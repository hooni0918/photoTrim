## License

PhotoTrim is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

# PhotoTrim

PhotoTrim is a powerful and intuitive image cropping library designed for iOS applications. Built with user experience as the top priority, it offers smooth gesture handling and an elegant UI.

## Key Features

PhotoTrim offers the following core functionalities:

### Image Manipulation
- Intuitive pinch gestures for zoom control (supporting 0.5x to 4x magnification)
- Smooth pan gestures for image positioning
- Automatic image size adjustment and alignment

### Crop Area
- Elegantly designed circular crop area
- Semi-transparent overlay to highlight the crop region
- Optional guidelines that can be enabled or disabled

### Technical Features
- Support for iOS 11.0 and above
- Modern codebase written in Swift 5.0
- Responsive design using Auto Layout
- Memory-efficient image processing
- Thread-safe cropping operations

## Installation

### Swift Package Manager
Here's how to add PhotoTrim to your project in Xcode:

1. Select File > Add Packages... from the Xcode menu
2. Enter the following URL in the search field:
```
https://github.com/hooni0918/photoTrim.git
```
3. Select Version Rule: 
   - Up to Next Major: 1.0.0
4. Click Add Package

Alternatively, you can add the dependency directly to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/hooni0918/photoTrim.git", from: "1.0.0")
]
```

## Detailed Usage Guide

### Basic Setup

First, import PhotoTrim:

```swift
import PhotoTrim
```

Here's the basic setup:

```swift
class ViewController: UIViewController {
    private var trimView: PhotoTrimView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize PhotoTrimView
        trimView = PhotoTrimView(frame: view.bounds)
        view.addSubview(trimView)
        
        // Setup Auto Layout
        trimView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trimView.topAnchor.constraint(equalTo: view.topAnchor),
            trimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Set image
        if let image = UIImage(named: "example") {
            trimView.setImage(image)
        }
    }
}
```

### Image Cropping

Here's how to obtain the cropped image:

```swift
@IBAction func cropButtonTapped(_ sender: Any) {
    if let croppedImage = trimView.getCroppedImage() {
        // Use the cropped image
        // Example: Save to photo library
        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
        
        // Or pass to another view controller
        let resultVC = ResultViewController()
        resultVC.image = croppedImage
        navigationController?.pushViewController(resultVC, animated: true)
    }
}
```

### Customization

PhotoTrimView provides various customization options:

```swift
// Configure zoom levels
trimView.minimumZoomScale = 0.5  // Default: 1.0
trimView.maximumZoomScale = 4.0  // Default: 3.0

// Configure guidelines
trimView.shouldShowGuideLines = true  // Default: true

// Customize crop area style
trimView.cropAreaView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
```

## Advanced Usage

### Implementing Delegate Pattern

To monitor image cropping status, implement PhotoTrimViewDelegate:

```swift
class ViewController: UIViewController, PhotoTrimViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        trimView.delegate = self
    }
    
    func photoTrimViewDidBeginEditing(_ trimView: PhotoTrimView) {
        // Called when editing begins
    }
    
    func photoTrimViewDidEndEditing(_ trimView: PhotoTrimView) {
        // Called when editing ends
    }
    
    func photoTrimView(_ trimView: PhotoTrimView, didChangeCropRect rect: CGRect) {
        // Called when crop area changes
    }
}
```

### Memory Management

Consider these points when handling large images:

```swift
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // Release image from memory
    trimView.imageView.image = nil
}
```

## Troubleshooting

### Common Issues

1. Image Not Displaying:
   - Verify image file is properly included in the project
   - Check image name accuracy in Asset Catalog

2. Unexpected Cropped Image Results:
   - Check original image orientation
   - Consider resizing if image is too large

3. Memory Warnings:
   - Implement image resizing for large images
   - Release unused images from memory

## Performance Optimization Tips

1. Image Size Optimization:
```swift
extension UIImage {
    func optimizedForCropping() -> UIImage {
        let maxDimension: CGFloat = 2048
        if size.width > maxDimension || size.height > maxDimension {
            let ratio = size.width / size.height
            let newSize: CGSize
            if ratio > 1 {
                newSize = CGSize(width: maxDimension, height: maxDimension / ratio)
            } else {
                newSize = CGSize(width: maxDimension * ratio, height: maxDimension)
            }
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
            return renderer.image { _ in
                draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
        return self
    }
}
```

2. Image Loading Optimization:
```swift
func loadImage() {
    DispatchQueue.global(qos: .userInitiated).async {
        if let image = UIImage(named: "example")?.optimizedForCropping() {
            DispatchQueue.main.async {
                self.trimView.setImage(image)
            }
        }
    }
}
```

## Contributing

To contribute to PhotoTrim:

1. Issue Submission:
   - Bug reports
   - Feature requests
   - Documentation improvements

2. Pull Requests:
   - Follow code style guidelines
   - Include test coverage
   - Provide detailed change descriptions

## License

PhotoTrim is available under the MIT license. See the [LICENSE](LICENSE) file for details.

## Contact

Please submit questions or issues through GitHub Issues.

## Version History

- 1.0.0
  - Initial release
  - Basic image cropping functionality
  - Circular crop area support
  - Gesture-based manipulation

## Acknowledgments

This project was inspired by the following open-source projects:
- YPImagePicker
- TOCropViewController

Thank you for choosing our library. We are committed to continuously improving the iOS development experience.


  <a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fhooni0918%2Fhit-counter&count_bg=%2379C83D&title_bg=%23555555&icon=github.svg&icon_color=%23FFFFFF&title=visited&edge_flat=false" alt="Hits"></a>

