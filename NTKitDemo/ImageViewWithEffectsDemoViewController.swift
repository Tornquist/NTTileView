//
//  ImageViewWithEffectsDemoViewController.swift
//  NTKitDemo
//
//  Created by Nathan Tornquist on 5/22/16.
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
import NTKit

class ImageViewWithEffectsDemoViewController: UIViewController {
    
    @IBOutlet weak var imageView: NTImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = NTImageExample()
    }    
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func NTImageExample() -> UIImage? {
        let image = NTImage(named: "Landscape")
        guard image != nil else {
            return nil
        }
        let rectEffect = NTImageRectangleEffect(rect: CGRectMake(50, 50, 100, 100),
                                                color: UIColor.redColor())
        let shadeEffect = NTImageShadeEffect(shape: .TriangleBottomRight,
                                             color: UIColor(red: 0, green: 1, blue: 0, alpha: 0.5))
        let progressEffect = NTImageProgressCircleEffect(center: CGPointMake(image!.size.width/2, image!.size.height/2),
                                                         innerRadius: 100,
                                                         outerRadius: 200,
                                                         startAngle: 0,
                                                         endAngle: 4,
                                                         color: UIColor(red: 0, green: 1, blue: 1, alpha: 0.75),
                                                         strokeInnerCircle: true,
                                                         strokeOuterCircle: true)
        let progressEffect2 = NTImageProgressCircleEffect(center: CGPointMake(image!.size.width/2 - 500, image!.size.height/2),
                                                          radius: 200,
                                                          percent: 0.66,
                                                          color: UIColor.orangeColor(),
                                                          strokeCircle: false)
        let textEffect = NTImageTextEffect(anchor: CGPointMake(100, 500),
                                           text: "Hello World",
                                           fontColor: UIColor.darkGrayColor())
        let textEffect2 = NTImageTextEffect(anchor: CGPointMake(image!.size.width/2, image!.size.height/2),
                                            anchorPosition: .Center,
                                            text: "This is a test of\nmultiline right\naligned text.",
                                            textAlignment: .Right,
                                            font: UIFont.systemFontOfSize(60),
                                            fontColor: UIColor.blackColor())
        let textEffect3 = NTImageBlockTextEffect(anchor: CGPointMake(image!.size.width, image!.size.height),
                                                 anchorPosition: .BottomRight,
                                                 maxWidth: 500,
                                                 text: "This will be a\ncomplicated string with multiple different\nlengths of lines.",
                                                 baseFont: UIFont.systemFontOfSize(60),
                                                 fontColor: UIColor.blackColor(),
                                                 capitalize: true,
                                                 trailingTargetCharacterThreshold: 100)
        let textEffect4 = NTImageBlockTextEffect(anchor: CGPointMake(image!.size.width, 0),
                                                 anchorPosition: .TopRight,
                                                 maxWidth: 1000,
                                                 text: "This will be a complicated string with multiple different lengths of lines.  As you type, more lines are added.",
                                                 baseFont: UIFont.systemFontOfSize(60),
                                                 fontColor: UIColor.blackColor(),
                                                 capitalize: true)
        image!.effects.append(rectEffect)
        image!.effects.append(shadeEffect)
        image!.effects.append(progressEffect)
        image!.effects.append(progressEffect2)
        image!.effects.append(textEffect)
        image!.effects.append(textEffect2)
        image!.effects.append(textEffect3)
        image!.effects.append(textEffect4)
        return image!.withEffects()
    }

}