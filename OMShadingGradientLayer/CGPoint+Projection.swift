//
//  CGPoint+Projection.swift
//  ExampleSwift
//
//  Created by Jorge Ouahbi on 26/4/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func projectLine( point :CGPoint, length:CGFloat) -> CGPoint  {
        var newPoint = CGPoint(x: point.x, y: point.y)
        let x = (point.x - self.x);
        let y = (point.y - self.y);
        if (fpclassify(x) == Int(FP_ZERO)) {
            newPoint.y += length;
        } else if (fpclassify(y) == Int(FP_ZERO)) {
            newPoint.x += length;
        } else {
            #if CGFLOAT_IS_DOUBLE
                let angle = atan(y / x);
                newPoint.x += sin(angle) * length;
                newPoint.y += cos(angle) * length;
            #else
                let angle = atanf(Float(y) / Float(x));
                newPoint.x += CGFloat(sinf(angle) * Float(length));
                newPoint.y += CGFloat(cosf(angle) * Float(length));
            #endif
        }
        return newPoint;
    }
}