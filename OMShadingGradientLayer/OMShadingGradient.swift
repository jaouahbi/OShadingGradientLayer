//
//  OMShadingGradient.swift
//  ExampleSwift
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


func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}

public struct OMGradientShadingColors {
    
    let colorStart:UIColor
    let colorEnd:UIColor
    
    var redComponent:CGFloat = 0
    var greenComponent:CGFloat = 0
    var blueComponent:CGFloat = 0
    var alphaComponent:CGFloat = 0
    var redComponentEnd:CGFloat = 0
    var greenComponentEnd:CGFloat = 0
    var blueComponentEnd:CGFloat = 0
    var alphaComponentEnd:CGFloat = 0
    
    init(colorStart:UIColor, colorEnd:UIColor) {
        
        self.colorEnd   = colorEnd
        self.colorStart = colorStart
        
        self.colorStart.getRed(&redComponent,
                               green: &greenComponent,
                               blue: &blueComponent,
                               alpha: &alphaComponent)
        self.colorEnd.getRed(&redComponentEnd,
                             green: &greenComponentEnd,
                             blue: &blueComponentEnd,
                             alpha: &alphaComponentEnd)
    }
    
    init(colorStart:CGColor, colorEnd:CGColor) {
        self.init(colorStart: UIColor(CGColor: colorStart), colorEnd: UIColor(CGColor: colorEnd))
    }
}

func insetGradient() -> OMGradientShadingColors
{
    let gradient = OMGradientShadingColors(colorStart: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha:  0.2) ,
                                           colorEnd  : UIColor(red:0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha:  0))
    
    return gradient;
}

func shineGradient() -> OMGradientShadingColors
{
    let gradient = OMGradientShadingColors(colorStart:UIColor(red: 1, green: 1, blue: 1, alpha:  0) ,
                                           colorEnd  : UIColor(red: 1, green:1, blue: 1, alpha:  0.8))
    
    return gradient;
}


func shadeGradient() -> OMGradientShadingColors
{
    let gradient = OMGradientShadingColors(colorStart:UIColor(red:  252 / 255.0, green: 252 / 255.0, blue: 252 / 255.0, alpha:  0.65) ,
                                           colorEnd  : UIColor(red: 178 / 255.0, green: 178 / 255.0, blue: 178 / 255.0, alpha:  0.65))
    
    return gradient;
}


func convexGradient() -> OMGradientShadingColors
{
    let gradient = OMGradientShadingColors(colorStart:UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha:  0.43) ,
                                           colorEnd  : UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha:  0.05))
    
    return gradient;
}

func concaveGradient() -> OMGradientShadingColors
{
    let gradient = OMGradientShadingColors(colorStart:UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha:  0) ,
                            colorEnd  : UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha:  0.46))
    
    return gradient;
}

func ShadingFunctionCreateExponential(colors : OMGradientShadingColors, _ slopeFunction: (Double) -> Double) -> (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void
{
    return { inData, outData in
        let alpha : Float = Float(inData[0]);
        let startColor = CGColorGetComponents(colors.colorStart.CGColor)
        
        print("startColor \(startColor[0]) \(startColor[1]) \(startColor[2]) \(startColor[3])")
        
        let endColor   = CGColorGetComponents(colors.colorEnd.CGColor)
        
        print("endColor \(endColor[0]) \(endColor[1]) \(endColor[2]) \(endColor[3])")
        
        for paintInfo in 0 ..< 4 {
            let end    = logf(max(Float(endColor[paintInfo]), 0.01))
            let start  = logf(max(Float(startColor[paintInfo]), 0.01))
            
            print("\(start) \(end)")
            
            let out = expf(start - (end + start) * alpha)
            
            print("out \(out)")
            
            outData[paintInfo] = CGFloat(out)
        }
        
        print("red : \(outData[0])")
        print("green : \(outData[1])")
        print("blue : \(outData[2])")
        print("alpha : \(outData[3])")
    }
}
//
//func ShadingFunctionCreateExponential(colors : OMGradientShadingColors, _ slopeFunction: (Double) -> Double) -> (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void
//{
//    return { inData, outData in
//        let alpha = Double(slopeFunction(Double(inData[0])))
//        
//        let minValue:Double = Double(0.01)
//
//        var end    = log(max(Double(colors.redComponentEnd),minValue))
//        var start  = log(max(Double(colors.redComponent),minValue))
//        outData[0] = CGFloat(exp(start - (end + start) * alpha))
//    
//        
//        end    = log(max(Double(colors.greenComponentEnd),minValue))
//        start  = log(max(Double(colors.greenComponent),minValue))
//        outData[1] = CGFloat(exp(start - (end + start) * alpha))
//        
//
//        end    = log(max(Double(colors.blueComponentEnd),minValue))
//        start  = log(max(Double(colors.blueComponent),minValue))
//        outData[2] = CGFloat(exp(start - (end + start) * alpha))
//        
//
//        end    = log(max(Double(colors.alphaComponentEnd),minValue))
//        start  = log(max(Double(colors.alphaComponent),minValue))
//        outData[3] = CGFloat(exp(start - (end + start) * alpha))
//        
//        print("red : \(outData[0])")
//        print("green : \(outData[1])")
//        print("blue : \(outData[2])")
//        print("alpha : \(outData[3])")
//    }
//}


func ShadingFunctionCreateLinear(colors : OMGradientShadingColors, _ slopeFunction: (Double) -> Double) -> (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void
{
    return { inData, outData in
        let alpha = CGFloat(slopeFunction(Double(inData[0])))
        let inverse = 1.0 - alpha;
        
        outData[0] = inverse * colors.redComponent + alpha * colors.redComponentEnd;
        outData[1] = inverse * colors.greenComponent + alpha * colors.greenComponentEnd;
        outData[2] = inverse * colors.blueComponent + alpha * colors.blueComponentEnd;
        outData[3] = inverse * colors.alphaComponent + alpha * colors.alphaComponentEnd;
        
//        print("red : \(outData[0])")
//        print("green : \(outData[1])")
//        print("blue : \(outData[2])")
//        print("alpha : \(outData[3])")
        
    }
}

//func ShadingFunctionCreate(startColor: UIColor, _ endColor: UIColor, _ slopeFunction: (Double) -> Double) -> (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void
//{
//    return { inData, outData in
//        let alpha = CGFloat(slopeFunction(Double(inData[0])))
//        
//        var redComponent:CGFloat = 0
//        var greenComponent:CGFloat = 0
//        var blueComponent:CGFloat = 0
//        var alphaComponent:CGFloat = 0
//        var redComponentEnd:CGFloat = 0
//        var greenComponentEnd:CGFloat = 0
//        var blueComponentEnd:CGFloat = 0
//        var alphaComponentEnd:CGFloat = 0
//        
//        startColor.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
//        endColor.getRed(&redComponentEnd, green: &greenComponentEnd, blue: &blueComponentEnd, alpha: &alphaComponentEnd)
//        
//        outData[0] = redComponent   + (redComponentEnd   - redComponent) * alpha
//        outData[1] = greenComponent + (greenComponentEnd - greenComponent) * alpha
//        outData[2] = blueComponent  + (blueComponentEnd  - blueComponent) * alpha
//        outData[3] = alphaComponent + (alphaComponentEnd - alphaComponent) * alpha
//    }
//}

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
    let colorSpace: CGColorSpace?
    let slopeFunction: (Double) -> Double
    let functionType : GradientFunction
    let gradientType : GradientType
    
    init(startColor: UIColor, endColor: UIColor, from: CGPoint, to: CGPoint, functionType: GradientFunction, slopeFunction: (Double) -> Double) {
        self.init(startColor: startColor,
                  endColor: endColor,
                  from: from,
                  startRadius: 0,
                  to: to,
                  endRadius: 0, functionType: functionType, gradientType: .Axial, slopeFunction: slopeFunction)
    }
    
    init(startColor: UIColor, endColor: UIColor, from: CGPoint,  startRadius: CGFloat, to: CGPoint, endRadius: CGFloat, functionType: GradientFunction, slopeFunction: (Double) -> Double) {
        self.init(startColor: startColor, endColor: endColor, from: from,  startRadius: startRadius,to: to, endRadius: endRadius, functionType: functionType, gradientType: .Radial, slopeFunction: slopeFunction)
    }
    
   init(startColor: UIColor, endColor: UIColor, from: CGPoint,  startRadius: CGFloat, to: CGPoint, endRadius: CGFloat, functionType: GradientFunction, gradientType : GradientType , slopeFunction: (Double) -> Double)
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
                                        false,
                                        false)
        } else {
            assert(self.gradientType == .Radial)
            return CGShadingCreateRadial(self.colorSpace,
                                         self.from,
                                         self.startRadius,
                                         self.to,
                                         self.endRadius,
                                         self.CGFunction,
                                         false,
                                         false)
        }
    }()
}