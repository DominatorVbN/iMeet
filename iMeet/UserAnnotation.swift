//
//  UserAnnotation.swift
//  iMeet
//
//  Created by dominator on 02/04/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import UIKit
import MapKit

import UIKit
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}

class UserAnnotationView: MKAnnotationView{
    
    private let maxContentWidth = CGFloat(50)
    private let interItemSpacing = CGFloat(10)
    private let blurEffect = UIBlurEffect(style: .systemThickMaterial)
    private let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
    
    private var imageHeightConstraint: NSLayoutConstraint?
    private var labelHeightConstraint: NSLayoutConstraint?
    
    private lazy var backgroundMaterial: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, labelVibrancyView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = interItemSpacing
        
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.preferredMaxLayoutWidth = maxContentWidth
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelVibrancyView: UIVisualEffectView = {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .secondaryLabel)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(self.label)
        
        return vibrancyView
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        addSubview(backgroundMaterial)
        
        backgroundMaterial.contentView.addSubview(stackView)
        
        // Make the background material the size of the annotation view container
        backgroundMaterial.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundMaterial.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundMaterial.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundMaterial.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        // Anchor the top and leading edge of the stack view to let it grow to the content size.
        stackView.leadingAnchor.constraint(equalTo: backgroundMaterial.leadingAnchor, constant: contentInsets.left).isActive = true
        stackView.topAnchor.constraint(equalTo: backgroundMaterial.topAnchor, constant: contentInsets.top).isActive = true
        
        // Limit how much the content is allowed to grow.
        imageView.widthAnchor.constraint(equalToConstant: maxContentWidth).isActive = true
        labelVibrancyView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        labelVibrancyView.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
        labelVibrancyView.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        labelVibrancyView.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        labelVibrancyView.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        imageView.layer.cornerRadius = maxContentWidth/2
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        /*
         If using the same annotation view and reuse identifier for multiple annotations, iOS will reuse this view by calling `prepareForReuse()`
         so the view can be put into a known default state, and `prepareForDisplay()` right before the annotation view is displayed. This method is
         the view's oppurtunity to update itself to display content for the new annotation.
         */
        if let annotation = annotation as? UserAnnotation {
            label.text = annotation.title
            
            if let image = annotation.image {
                imageView.image = image
                
                /*
                 The image view has a width constraint to keep the image to a reasonable size. A height constraint to keep the aspect ratio
                 proportions of the image is required to keep the image packed into the stack view. Without this constraint, the image's height
                 will remain the intrinsic size of the image, resulting in extra height in the stack view that is not desired.
                 */
                
                if let heightConstraint = imageHeightConstraint {
                    imageView.removeConstraint(heightConstraint)
                }
                
                imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1, constant: 0)
                imageHeightConstraint?.isActive = true
            }
        }
        
        // Since the image and text sizes may have changed, require the system do a layout pass to update the size of the subviews.
        setNeedsLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // The stack view will not have a size until a `layoutSubviews()` pass is completed. As this view's overall size is the size
        // of the stack view plus a border area, the layout system needs to know that this layout pass has invalidated this view's
        // `intrinsicContentSize`.
        invalidateIntrinsicContentSize()
        
        // Use the intrinsic content size to inform the size of the annotation view with all of the subviews.
        let contentSize = intrinsicContentSize
        frame.size = intrinsicContentSize
        
        // The annotation view's center is at the annotation's coordinate. For this annotation view, offset the center so that the
        // drawn arrow point is the annotation's coordinate.
        centerOffset = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
        
        let shape = CAShapeLayer()
        let path = CGMutablePath()
        
        
        
//        // Draw the pointed shape.
//        let pointShape = UIBezierPath()
//        pointShape.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.height + 50))
//        pointShape.addLine(to: CGPoint(x: 0, y: self.frame.height * 0.2))
//        pointShape.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.height + 50))
//        pointShape.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.height * 0.2))
//        path.addPath(pointShape.cgPath)
        
        
        //Draw Rect
        let roundedRect = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.height - 20), cornerRadius: 10)
        path.addPath(roundedRect.cgPath)
        
        let pinShape = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width/2, y: self.frame.height))
        path.addLine(to: CGPoint(x: (self.frame.width/2) - 10, y: self.frame.height - 25))
        path.addLine(to: CGPoint(x: (self.frame.width/2)+10, y: self.frame.height - 25))
        path.addLine(to: CGPoint(x: self.frame.width/2, y: self.frame.height))
        path.closeSubpath()
        path.addPath(pinShape.cgPath)
        
        shape.path = path
        backgroundMaterial.layer.mask = shape
        
        

        
    }
    override var intrinsicContentSize: CGSize {
        var size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width += contentInsets.left + contentInsets.right
        size.height += contentInsets.top + contentInsets.bottom
        return size
    }
}
