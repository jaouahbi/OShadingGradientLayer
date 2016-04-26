
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
//  CGPoint+Projection.swift
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