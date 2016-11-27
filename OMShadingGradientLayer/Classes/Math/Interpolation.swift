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
//  Interpolation.swift
//
//  Created by Jorge Ouahbi on 13/5/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//
// from (http://paulbourke.net/miscellaneous/interpolation/)

import UIKit

enum InterpolationType {
    case linear
    case exponential
    case cosine
    case bilinear
    case hermite
}

class Interpolation
{
    
    // @note
    // Cubic interpolation is the simplest method that offers true continuity between the segments.
    // As such it requires more than just the two endpoints of the segment but also the two points on either side of them.
    // So the function requires 4 points in all labeled y0, y1, y2, and y3, in the code below. mu still behaves the same way for interpolating
    // between the segment y1 to y2.
    // This does raise issues for how to interpolate between the first and last segments.
    // In the examples here I just haven't bothered. A common solution is the dream up two extra points at the start and end of the sequence,
    // the new points are created so that they have a slope equal to the slope of the start or end segment.
    
    class func cubicerp(_ y0:CGFloat,y1:CGFloat,y2:CGFloat,y3:CGFloat,t:CGFloat) -> CGFloat {
        var a0:CGFloat
        var a1:CGFloat
        var a2:CGFloat
        var a3:CGFloat
        var t2:CGFloat
        
        // note
        // Paul Breeuwsma proposes the following coefficients for a smoother interpolated curve, which uses the slope 
        // between the previous point and the next as the derivative at the current point.
        // This results in what are generally referred to as Catmull-Rom splines.
        
        // a0 = -0.5*y0 + 1.5*y1 - 1.5*y2 + 0.5*y3;
        // a1 = y0 - 2.5*y1 + 2*y2 - 0.5*y3;
        // a2 = -0.5*y0 + 0.5*y2;
        // a3 = y1;
        
        t2 = t*t;
        a0 = y3 - y2 - y0 + y1;
        a1 = y0 - y1 - a0;
        a2 = y2 - y0;
        a3 = y1;
        
        return(a0*t*t2+a1*t2+a2*t+a3);
    }
    
    class func eerp(_ y0:CGFloat,y1:CGFloat,t:CGFloat) -> CGFloat {
        assert(t >= 0.0 && t <= 1.0);
        let end    = log(max(Double(y0), 0.01))
        let start  = log(max(Double(y1), 0.01))
        return   CGFloat(exp(start - (end + start) * Double(t)))
    }
    
    // Linear interpolation is the simplest method of getting values at positions in between the data points.
    // The points are simply joined by straight line segments. 
    // Each segment (bounded by two data points) can be interpolated independently.
    // The parameter mu defines where to estimate the value on the interpolated line,
    // it is 0 at the first point and 1 and the second point.
    // For interpolated values between the two points mu ranges between 0 and 1. 
    // Values of mu outside this range result in extrapolation.
    
    // @note
    // Imprecise method which does not guarantee v = v1 when t = 1, due to floating-point arithmetic error.
    // This form may be used when the hardware has a native Fused Multiply-Add instruction.
    // return v0 + t*(v1-v0);
    
    // Precise method which guarantees v = v1 when t = 1.
    // (1-t)*v0 + t*v1;
    
    class func lerp(_ y0:CGFloat,y1:CGFloat,t:CGFloat) -> CGFloat {
        assert(t >= 0.0 && t <= 1.0);
        let inverse = 1.0 - t;
        return inverse * y0 + t * y1
    }
    
    class func bilerp(_ y00:CGFloat,y01:CGFloat,t1:CGFloat,y10:CGFloat,y11:CGFloat,t2:CGFloat) -> CGFloat {
        assert(t1 >= 0.0 && t1 <= 1.0);
        assert(t2 >= 0.0 && t2 <= 1.0);
        let x = lerp(y00, y1: y01, t: t1)
        let y = lerp(y10, y1: y11, t: t2)
        return lerp(x, y1: y, t: 0.5)
    }
    
    
    // @note
    // Linear interpolation results in discontinuities at each point.
    // Often a smoother interpolating function is desirable, 
    // perhaps the simplest is cosine interpolation. 
    // A suitable orientated piece of a cosine function serves to provide a smooth transition between adjacent segments.
    
    
    class func coserp(_ y0:CGFloat,y1:CGFloat,t:CGFloat) -> CGFloat {
        assert(t >= 0.0 && t <= 1.0);
        let mu2 = CGFloat(1.0-cos(Double(t)*Double.pi))/2;
        return (y0*(1.0-mu2)+y1*mu2);
    }
    
    // @note
    // Tension: 1 is high, 0 normal, -1 is low
    // Bias: 0 is even,
    // positive is towards first segment,
    // negative towards the other
 
    class func hermiterp(_ y0:CGFloat, y1:CGFloat, y2:CGFloat, y3:CGFloat, mu:CGFloat, tension:CGFloat, bias:CGFloat) -> CGFloat {
        var m0:CGFloat
        var m1:CGFloat
        var mu2:CGFloat
        var mu3:CGFloat
        var a0:CGFloat
        var a1:CGFloat
        var a2:CGFloat
        var a3:CGFloat
        
        let t = (1-tension)/2
        mu2 = mu * mu;
        mu3 = mu2 * mu;
        m0  = (y1-y0)*(1+bias)*t;
        m0 += (y2-y1)*(1-bias)*t
        m1  = (y2-y1)*(1+bias)*t;
        m1 += (y3-y2)*(1-bias)*t;
        a0 =  2*mu3 - 3*mu2 + 1;
        a1 =    mu3 - 2*mu2 + mu;
        a2 =    mu3 -   mu2;
        a3 = -2*mu3 + 3*mu2;
        
        return(a0*y1+a1*m0+a2*m1+a3*y2);
    }
    
}
