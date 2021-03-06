

//
//    Copyright 2016 - Jorge Ouahbi
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
//  OMView.swift
//
//  Created by Jorge Ouahbi on 21/4/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//

import UIKit


// MARK: - Layer's View
public class OMView<T: CALayer>: UIView {
    
    // MARK: - Properties
    /// The view’s conical  layer used for rendering. (read-only)
    var gradientLayer: T {
        return super.layer as! T
    }
    
    override open class var layerClass: AnyClass {
        return T.self as AnyClass
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        let scale =  UIScreen.main.scale
        layer.contentsScale = scale
        layer.needsDisplayOnBoundsChange = true
        layer.drawsAsynchronously = true
        layer.allowsGroupOpacity = true
        layer.shouldRasterize = true
        layer.rasterizationScale = scale
        self.backgroundColor    = UIColor.white
        layer.setNeedsDisplay()
    }
}


// MARK: Interface Builder Additions

//
//@IBDesignable @available(*, unavailable, message = "This is reserved for Interface Builder")
//extension OMGradientView {
//    
//    @IBInspectable public var gradientType: Int {
//        set {
//            if let type = OMGradientType(rawValue: newValue) {
//                self.type = type
//            }
//        }
//        get {
//            return self.type.rawValue
//        }
//    }
//    
//    @IBInspectable public var startColor: UIColor {
//        set {
//            if colors.isEmpty {
//                colors.append(newValue)
//                colors.append(UIColor.clearColor())
//            } else {
//                colors[0] = newValue
//            }
//        }
//        get {
//            return (colors.count >= 1) ? colors[0] : UIColor.clearColor()
//        }
//    }
//    
//    @IBInspectable public var endColor: UIColor {
//        set {
//            if colors.isEmpty {
//                colors.append(UIColor.clearColor())
//                colors.append(newValue)
//            } else {
//                colors[1] = newValue
//            }
//        }
//        get {
//            return (colors.count >= 2) ? colors[1] : UIColor.clearColor()
//        }
//    }
//    
//    public override func prepareForInterfaceBuilder() {
//        // To improve IB performance, reduce generated image size
//        layer.contentsScale = 0.25
//    }
//    
//}
