
//
//    Copyright 2015 - Jorge Ouahbi
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//


//
//  UIBezierPath+Random.swift
//  ExampleSwift
//
//  Created by Jorge Ouahbi on 24/4/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//

import UIKit

extension UIBezierPath
{
    // based on http://ericasadun.com/2015/05/15/swift-playground-hack-of-the-day/
    
    class public  func random(size : CGSize) -> UIBezierPath? {
        func RandomFloat() -> CGFloat {return CGFloat(arc4random()) / CGFloat(UINT32_MAX)}
        func RandomPoint() -> CGPoint {return CGPointMake(size.width * RandomFloat(), size.height * RandomFloat())}
        let path = UIBezierPath(); path.moveToPoint(RandomPoint())
        for _ in 0..<(3 + Int(arc4random_uniform(numericCast(10)))) {
            switch (arc4random() % 3) {
            case 0: path.addLineToPoint(RandomPoint())
            case 1: path.addQuadCurveToPoint(RandomPoint(), controlPoint: RandomPoint())
            case 2: path.addCurveToPoint(RandomPoint(), controlPoint1: RandomPoint(), controlPoint2: RandomPoint())
            default: break;
            }
        }
        path.closePath()
        
        // maximize it
        
        let boundingBox = path.boundingBox()
        
        var affine = CGAffineTransformMakeScale(size.width/boundingBox.size.width, size.height/boundingBox.size.height)
        
        return UIBezierPath(CGPath: CGPathCreateCopyByTransformingPath(path.CGPath, &affine)!)
    }
    
    func boundingBox() -> CGRect {
        return CGPathGetBoundingBox(self.CGPath)
    }
}
