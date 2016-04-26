
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
//  OMShadingGradient.swift
//
//  Created by Jorge Ouahbi on 20/4/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//


import Foundation
import UIKit

public enum GradientFunction {
    case Linear
    case Exponential
}

public enum GradientType {
    case Axial
    case Radial
}

public struct OMGradientShadingColors {
    
    let colorStart:UIColor
    let colorEnd:UIColor
    private let startComponents:UnsafePointer<CGFloat>
    private let endComponents:UnsafePointer<CGFloat>
    
    init(colorStart:UIColor, colorEnd:UIColor) {
        self.colorStart      = colorStart
        self.colorEnd        = colorEnd
        self.startComponents = CGColorGetComponents(colorStart.CGColor)
        self.endComponents   = CGColorGetComponents(colorEnd.CGColor)
    }
    
    init(colorStart:CGColor, colorEnd:CGColor) {
        self.init(colorStart: UIColor(CGColor: colorStart), colorEnd: UIColor(CGColor: colorEnd))
    }
}

func ShadingFunctionCreateExponential(colors : OMGradientShadingColors, _ slopeFunction: (Double) -> Double) -> (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void
{
    return { inData, outData in
        let alpha : Float = Float(slopeFunction(Double(inData[0])))
        
        for paintInfo in 0 ..< 4 {
            let end    = logf(max(Float(colors.endComponents[paintInfo]), 0.01))
            let start  = logf(max(Float(colors.startComponents[paintInfo]), 0.01))
            outData[paintInfo] = CGFloat(expf(start - (end + start) * alpha))
        }
    }
}


func ShadingFunctionCreateLinear(colors : OMGradientShadingColors, _ slopeFunction: (Double) -> Double) -> (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void
{
    return { inData, outData in
        let alpha = CGFloat(slopeFunction(Double(inData[0])))
        let inverse = 1.0 - alpha;
        
        outData[0] = inverse * colors.startComponents[0] + alpha * colors.endComponents[0];
        outData[1] = inverse * colors.startComponents[1] + alpha * colors.endComponents[1];
        outData[2] = inverse * colors.startComponents[2] + alpha * colors.endComponents[2];
        outData[3] = inverse * colors.startComponents[3] + alpha * colors.endComponents[3];
        
    }
}
func ShadingCallback(infoPointer: UnsafeMutablePointer<Void>, inData: UnsafePointer<CGFloat>, outData: UnsafeMutablePointer<CGFloat>) -> Void {
    var info = UnsafeMutablePointer<OMShadingGradient>(infoPointer).memory
    info.shadingFunction(inData, outData)
}

struct OMShadingGradient {
    
    let colors : OMGradientShadingColors
    let from : CGPoint
    let to : CGPoint
    let startRadius : CGFloat
    let endRadius : CGFloat
    let extendsPastStart:Bool
    let extendsPastEnd:Bool
    let colorSpace: CGColorSpace?
    let slopeFunction: (Double) -> Double
    let functionType : GradientFunction
    let gradientType : GradientType
    
    init(startColor: UIColor, endColor: UIColor, from: CGPoint, to: CGPoint, extendStart: Bool, extendEnd: Bool,functionType: GradientFunction, slopeFunction: (Double) -> Double) {
        self.init(startColor: startColor,
                  endColor: endColor,
                  from: from,
                  startRadius: 0,
                  to: to,
                  endRadius: 0, extendStart: extendStart, extendEnd: extendEnd,functionType: functionType, gradientType: .Axial, slopeFunction: slopeFunction)
    }
    
    init(startColor: UIColor, endColor: UIColor, from: CGPoint,  startRadius: CGFloat, to: CGPoint, endRadius: CGFloat,extendStart: Bool, extendEnd: Bool, functionType: GradientFunction, slopeFunction: (Double) -> Double) {
        self.init(startColor: startColor, endColor: endColor, from: from,  startRadius: startRadius,to: to, endRadius: endRadius, extendStart: extendStart, extendEnd: extendEnd,functionType: functionType, gradientType: .Radial, slopeFunction: slopeFunction)
    }
    
    init(startColor: UIColor, endColor: UIColor, from: CGPoint,  startRadius: CGFloat, to: CGPoint, endRadius: CGFloat,
         extendStart: Bool, extendEnd: Bool, functionType: GradientFunction, gradientType : GradientType , slopeFunction: (Double) -> Double)
    {
        self.colors      = OMGradientShadingColors(colorStart: startColor,colorEnd: endColor)
        self.from        = from
        self.to          = to
        self.startRadius = startRadius
        self.endRadius   = endRadius
        
        // must be the same colorspace
        assert( CGColorSpaceGetModel(CGColorGetColorSpace(startColor.CGColor)) ==
            CGColorSpaceGetModel(CGColorGetColorSpace(endColor.CGColor)))
        
        self.colorSpace     = CGColorGetColorSpace(startColor.CGColor)
        self.slopeFunction  = slopeFunction
        self.functionType   = functionType
        self.gradientType   = gradientType
        self.extendsPastStart = extendStart
        self.extendsPastEnd = extendEnd
    }
    
    lazy var shadingFunction : (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void = {
        if (self.functionType == .Linear) {
            return ShadingFunctionCreateLinear(self.colors, self.slopeFunction)
        } else {
            assert(self.functionType == .Exponential)
            return ShadingFunctionCreateExponential(self.colors, self.slopeFunction)
        }
    }()
    
    lazy var CGFunction : CGFunctionRef? = {
        var callbacks = CGFunctionCallbacks(version: 0, evaluate: ShadingCallback, releaseInfo: nil)
        
        return CGFunctionCreate(&self,                      // info
            1,                          // domainDimension
            [0, 1],                     // domain
            4,                          // rangeDimension
            [0, 1, 0, 1, 0, 1, 0, 1],   // range
            &callbacks)                 // callbacks
    }()
    
    lazy var CGShading : CGShadingRef! = {
        var callbacks = CGFunctionCallbacks(version: 0, evaluate: ShadingCallback, releaseInfo: nil)
        if(self.gradientType == .Axial) {
            return CGShadingCreateAxial(self.colorSpace,
                                        self.from,
                                        self.to,
                                        self.CGFunction,
                                        self.extendsPastStart,
                                        self.extendsPastEnd)
        } else {
            assert(self.gradientType == .Radial)
            return CGShadingCreateRadial(self.colorSpace,
                                         self.from,
                                         self.startRadius,
                                         self.to,
                                         self.endRadius,
                                         self.CGFunction,
                                         self.extendsPastStart,
                                         self.extendsPastEnd)
        }
    }()
}