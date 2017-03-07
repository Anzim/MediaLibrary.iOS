//
//  RoundButton.swift
//  Cooking
//
//  Created by Andriy Zymenko on 10/7/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit

//@IBDesignable
public class RoundButton: UIButton {
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard (super.point(inside: point, with: event)) else { return false }
        let radius = max(bounds.width, bounds.height) * 0.5
        let squareOfDistanceFromCentre =
            (radius - point.x)*(radius - point.x) +
            (radius - point.y)*(radius - point.y);
        return (squareOfDistanceFromCentre <= radius * radius);
    }
//    @IBInspectable var imageTextSpacing = CGFloat(8)
//    @IBInspectable var contentIsCenteredVertically = true
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        updateCornerRadius()
//        if contentIsCenteredVertically {
//            centerContentVertically()
//        }
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        updateCornerRadius()
//        if contentIsCenteredVertically {
//            centerContentVertically()
//        }
//    }
//
//    override public func layoutSubviews() {
//        super.layoutSubviews()
//        updateCornerRadius()
//        if contentIsCenteredVertically {
////            centerContentVertically()
//        }
//    }
//
//    private func updateCornerRadius() {
//        let minSize = min(bounds.width, bounds.height)
//        layer.cornerRadius = 0.5 * minSize
//        layer.masksToBounds = true
//        clipsToBounds = true
//    }
//
//    public override func draw(_ rect: CGRect) {
//        updateCornerRadius()
//        super.draw(rect)
//    }
//    override var cornerRadius: CGFloat? {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//        }
//    }

//    func centerContentVertically() {
//        // update positioning of image and title
//        guard let imageSize = self.imageView?.frame.size,
//            let titleSize = self.titleLabel?.frame.size else
//        {
//            return
//        }
//        self.titleEdgeInsets = UIEdgeInsets(top:0,
//                                            left:-imageSize.width,
//                                            bottom:-(imageSize.height + imageTextSpacing),
//                                            right:0)
//        self.imageEdgeInsets = UIEdgeInsets(top:-(titleSize.height + imageTextSpacing),
//                                            left:0,
//                                            bottom: 0,
//                                            right:-titleSize.width)
//
//        // reset contentInset, so intrinsicContentSize() is still accurate
//        let trueContentSize = self.titleLabel!.frame.union(self.imageView!.frame).size
//        let oldContentSize = self.intrinsicContentSize
//        let heightDelta = trueContentSize.height - oldContentSize.height
//        let widthDelta = trueContentSize.width - oldContentSize.width
//        self.contentEdgeInsets = UIEdgeInsets(top:heightDelta/2.0,
//                                              left:widthDelta/2.0,
//                                              bottom:heightDelta/2.0,
//                                              right:widthDelta/2.0)
//    }
}

@IBDesignable
class RoundedButton: UIButton {


    // IBInspectable properties for the gradient colors
    @IBInspectable var bottomColor: UIColor = UIColor(red:0.98, green:0.49, blue:0.2, alpha:1)
    @IBInspectable var middleColor: UIColor = UIColor(red:0.98, green:0.85, blue:0.38, alpha:1)
    @IBInspectable var topColor: UIColor = UIColor(red:0.98, green:0.49, blue:0.2, alpha:1)
    @IBInspectable var bottomColorAlpha: CGFloat = 1.0
    @IBInspectable var middleColorAlpha: CGFloat = 1.0
    @IBInspectable var topColorAlpha: CGFloat = 1.0

    // IBInspectable properties for rounded corners and border color / width
//    @IBInspectable var cornerSize: CGFloat = 0
//    @IBInspectable var borderSize: CGFloat = 0
//    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var borderAlpha: CGFloat = 1.0

    override func draw(_ rect: CGRect) {

        // set up border and cornerRadius
        self.layer.cornerRadius = cornerRadius ?? 0
        self.layer.borderColor = borderColor.withAlphaComponent(borderAlpha).cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true

        // set up gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        let c1 = bottomColor.withAlphaComponent(bottomColorAlpha).cgColor
        let c2 = middleColor.withAlphaComponent(middleColorAlpha).cgColor
        let c3 = topColor.withAlphaComponent(topColorAlpha).cgColor
        gradientLayer.colors = [c3, c2, c1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }

//    override var bounds: CGRect {
//        get {
//            return super.bounds
//        }
//        set {
//            super.bounds = newValue
//            let minSize = min(bounds.width, bounds.height)
//            cornerRadius = minSize / 2
//            setNeedsDisplay()
//        }
//    }

//    override public func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = 0.5 * bounds.size.width
//        clipsToBounds = true
//    }

}


