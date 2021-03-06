//
//  NTCropOverlayView.swift
//  NTKit
//
//  Created by Nathan Tornquist on 5/25/16.
//  Copyright © 2016 Nathan Tornquist. All rights reserved.
//
//  Hosted on github at github.com/Tornquist/NTKit
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class NTCropOverlayView: UIView {
    
    // The maximum amount of the overlay that the cropFrame can fill
    // The overlay will grow until it is this value of the height or
    // width of the enclosing view (whichever is reached first)
    var maxFillPercent: CGFloat = 0.8
    
    // Values updated and maintained by scaleCropPath
    var scaledCropPath: UIBezierPath? = nil
    var scaledCropWidth: CGFloat? = nil
    var scaledCropHeight: CGFloat? = nil
    var cropRect: CGRect? {
        get {
            if scaledCropWidth == nil || scaledCropHeight == nil {
                return nil
            }
            
            let x = self.frame.width/2 - scaledCropWidth!/2
            let y = self.frame.height/2 - scaledCropHeight!/2
            return CGRect(x: x, y: y, width: scaledCropWidth!, height: scaledCropHeight!)
        }
    }
    
    var shadeColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    var cropPathColor: UIColor = UIColor.clear
    
    var _cropPath: UIBezierPath? = nil
    var oldFrame: CGRect = CGRect.zero
    var cropPath: UIBezierPath? {
        get {
            return _cropPath
        }
        set {
            _cropPath = newValue
            self.scaleCropPath()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.configureView()
    }
    
    func configureView() {
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        shadeColor.setFill()
        UIRectFill(rect)
        if let path = scaledPathInFrame() {
            UIGraphicsGetCurrentContext()?.setBlendMode(.clear)
            path.fill()
            UIGraphicsGetCurrentContext()?.setBlendMode(.normal)
            cropPathColor.setFill()
            path.fill()
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false // Overlay ignores touchces
    }
    
    // MARK: - Scale Crop Path
    
    func scaleCropPath() {
        guard cropPath != nil else {
            scaledCropPath = nil
            scaledCropWidth = nil
            scaledCropHeight = nil
            return
        }
        
        let cropBoundingBox = self.cropPath!.bounds
        let cropAspectRatio = cropBoundingBox.width/cropBoundingBox.height
        let viewAspectRatio = self.frame.width/self.frame.height
        
        var widthMultiplier: CGFloat = 0
        var heightMultiplier: CGFloat = 0
        
        if viewAspectRatio > cropAspectRatio  {
            heightMultiplier = maxFillPercent
            widthMultiplier = (self.frame.height*heightMultiplier*cropAspectRatio)/self.frame.width
        } else {
            widthMultiplier = maxFillPercent
            heightMultiplier = (self.frame.width*widthMultiplier/cropAspectRatio)/self.frame.height
        }
        
        self.scaledCropWidth = widthMultiplier*self.frame.width
        self.scaledCropHeight = heightMultiplier*self.frame.height
        self.scaledCropPath = NTCropHelper.scale(cropPath!, toPoint: CGPoint.zero, withScale: scaledCropWidth!/self.cropPath!.bounds.width)
        DispatchQueue.main.async(execute: {
            //TODO: Make this animate smoother when rotating
            self.setNeedsDisplay()
        })
    }
    
    func scaledPathInFrame() -> UIBezierPath? {
        guard self.scaledCropPath != nil && self.scaledCropWidth != nil && self.scaledCropHeight != nil else {
            return nil
        }
        
        let pointX = self.frame.width/2-self.scaledCropWidth!/2
        let pointY = self.frame.height/2-self.scaledCropHeight!/2
        
        return NTCropHelper.scale(scaledCropPath!, toPoint: CGPoint(x: pointX, y: pointY), withScale: 1)
    }
    
    // MARK: - Layout Views
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.oldFrame != self.frame {
            self.oldFrame = self.frame
            self.scaleCropPath()
        }
    }
}
