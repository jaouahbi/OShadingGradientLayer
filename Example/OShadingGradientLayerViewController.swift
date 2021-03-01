
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


import UIKit
import OMShadingGradientLayer
import LibControl

let kDefaultAnimationDuration: TimeInterval = 5.0

class OShadingGradientLayerViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:  UITableView!
    
    @IBOutlet weak var pointStartX  :  UISlider!
    @IBOutlet weak var pointEndX    :  UISlider!
    
    @IBOutlet weak var pointStartY  :  UISlider!
    @IBOutlet weak var pointEndY    :  UISlider!
    
    @IBOutlet weak var endPointSliderValueLabel   : UILabel!
    @IBOutlet weak var startPointSliderValueLabel : UILabel!
    
    @IBOutlet weak var viewForGradientLayer : UIView!
    
    @IBOutlet weak var startRadiusSlider    : UISlider!
    @IBOutlet weak var endRadiusSlider      : UISlider!
    
    @IBOutlet weak var startRadiusSliderValueLabel  : UILabel!
    @IBOutlet weak var endRadiusSliderValueLabel    : UILabel!
    
    @IBOutlet weak var typeGardientSwitch: UISwitch!
    
    @IBOutlet weak var extendsPastEnd   : UISwitch!
    @IBOutlet weak var extendsPastStart : UISwitch!
    @IBOutlet weak var segmenFunction : UISegmentedControl!
    
    @IBOutlet weak var strokePath  : UISwitch!
    @IBOutlet weak var randomPath : UISwitch!
    
    var colors      : [UIColor] = []
    var locations   : [CGFloat] = [0.0,1.0]
    var subviewForGradientLayer : OMView<OMShadingGradientLayer>!
    var gradientLayer: OMShadingGradientLayer = OMShadingGradientLayer(type:.radial)
    var animate       = true
    
    lazy var slopeFunction: [(Double) -> Double] = {
        return [
            Linear,
            QuadraticEaseIn,
            QuadraticEaseOut,
            QuadraticEaseInOut,
            CubicEaseIn,
            CubicEaseOut,
            CubicEaseInOut,
            QuarticEaseIn,
            QuarticEaseOut,
            QuarticEaseInOut,
            QuinticEaseIn,
            QuinticEaseOut,
            QuinticEaseInOut,
            SineEaseIn,
            SineEaseOut,
            SineEaseInOut,
            CircularEaseIn,
            CircularEaseOut,
            CircularEaseInOut,
            ExponentialEaseIn,
            ExponentialEaseOut,
            ExponentialEaseInOut,
            ElasticEaseIn,
            ElasticEaseOut,
            ElasticEaseInOut,
            BackEaseIn,
            BackEaseOut,
            BackEaseInOut,
            BounceEaseIn,
            BounceEaseOut,
            BounceEaseInOut,
        ]
    }()
    
    lazy var slopeFunctionString:[String] = {
        return [
            "Linear",
            "QuadraticEaseIn",
            "QuadraticEaseOut",
            "QuadraticEaseInOut",
            "CubicEaseIn",
            "CubicEaseOut",
            "CubicEaseInOut",
            "QuarticEaseIn",
            "QuarticEaseOut",
            "QuarticEaseInOut",
            "QuinticEaseIn",
            "QuinticEaseOut",
            "QuinticEaseInOut",
            "SineEaseIn",
            "SineEaseOut",
            "SineEaseInOut",
            "CircularEaseIn",
            "CircularEaseOut",
            "CircularEaseInOut",
            "ExponentialEaseIn",
            "ExponentialEaseOut",
            "ExponentialEaseInOut",
            "ElasticEaseIn",
            "ElasticEaseOut",
            "ElasticEaseInOut",
            "BackEaseIn",
            "BackEaseOut",
            "BackEaseInOut",
            "BounceEaseIn",
            "BounceEaseOut",
            "BounceEaseInOut",
        ]
    }()
    
    // MARK: - UITableView Helpers
    
    func selectIndexPath(_ row:Int, section:Int = 0) {
        let indexPath = IndexPath(item: row, section: section)
        self.tableView.selectRow(at: indexPath,animated: true,scrollPosition: .bottom)
        self.gradientLayer.slopeFunction = self.slopeFunction[(indexPath as NSIndexPath).row];
    }
    
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slopeFunction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        assert(self.slopeFunctionString.count == self.slopeFunction.count)
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font          = UIFont(name: "Helvetica", size: 9)
        cell.textLabel?.text          = "\(self.slopeFunctionString[(indexPath as NSIndexPath).row])"
        
        cell.layer.cornerRadius       = 8
        cell.layer.masksToBounds      = true
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gradientLayer.slopeFunction = self.slopeFunction[(indexPath as NSIndexPath).row];
    }
    
    @IBAction func maskTextSwitchChanged(_ sender: UISwitch) {
        
        if (sender.isOn) {
            textLayer.removeFromSuperlayer()
            gradientLayer.mask = textLayer
        } else {
            gradientLayer.mask = nil
            gradientLayer.addSublayer(textLayer)
        }
        updateGradientLayer()
    }
    
    
    // MARK: - View life cycle
    var textLayer: OMTextLayer = OMTextLayer(string: "Hello text shading", font: UIFont(name: "Helvetica",size: 50)!)
  
    override func viewDidLoad() {
        super.viewDidLoad()

        subviewForGradientLayer  = OMView<OMShadingGradientLayer>(frame: viewForGradientLayer.frame)
        
        viewForGradientLayer.addSubview(subviewForGradientLayer)
        
        gradientLayer   = subviewForGradientLayer!.gradientLayer
        
        gradientLayer.addSublayer(textLayer)
        
        randomizeColors()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewBounds = viewForGradientLayer.bounds
        
        pointStartX.maximumValue   = 1.0
        pointStartY.minimumValue   = 0.0
        
        pointEndX.maximumValue     = 1.0
        pointEndY.minimumValue     = 0.0
        
        let startPoint = CGPoint(x:viewBounds.minX / viewBounds.size.width,y: viewBounds.minY / viewBounds.size.height)
        let endPoint   = CGPoint(x:viewBounds.minX / viewBounds.size.width,y: viewBounds.maxY / viewBounds.size.height)
        
        pointStartX.value = Float(startPoint.x)
        pointStartY.value = Float(startPoint.y)
        
        pointEndX.value   = Float(endPoint.x)
        pointEndY.value   = Float(endPoint.y)
        
        extendsPastEnd.isOn   = true
        extendsPastStart.isOn = true
        
        // radius
        
        endRadiusSlider.maximumValue     = 1.0
        endRadiusSlider.minimumValue     = 0
        
        startRadiusSlider.maximumValue   = 1.0
        startRadiusSlider.minimumValue   = 0
        
        startRadiusSlider.value   = 1.0
        endRadiusSlider.value     = 0
        
        
        // select the first element
        selectIndexPath(0)
        
        gradientLayer.frame         = viewBounds
        gradientLayer.locations     = locations
        
        
        // update the gradient layer frame
        self.gradientLayer.frame = self.viewForGradientLayer.bounds
        
        // text layers
        self.textLayer.frame = self.viewForGradientLayer.bounds
        
        // 2%
//        textLayer.borderWidth = 100
        
//        self.textLayer.frame = self.viewForGradientLayer.bounds
//
//        viewForGradientLayer.layer.addSublayer(gradientLayer)
//
        viewForGradientLayer.backgroundColor = UIColor.clear
        
        #if DEBUG
        viewForGradientLayer.layer.borderWidth = 1.0
        viewForGradientLayer.layer.borderColor = UIColor.blackColor().CGColor
        #endif
        
        updateTextPointsUI()
        updateGradientLayer()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate(alongsideTransition: {(UIViewControllerTransitionCoordinatorContext) in
            
        }) {(UIViewControllerTransitionCoordinatorContext) in
            // update the gradient layer frame
            self.gradientLayer.frame = self.viewForGradientLayer.bounds
        }
    }
    
    // MARK: - Triggered actions
    
    @IBAction func extendsPastStartChanged(_ sender: UISwitch) {
        
        gradientLayer.extendsBeforeStart = sender.isOn
    }
    
    @IBAction func extendsPastEndChanged(_ sender: UISwitch) {
        
        gradientLayer.extendsPastEnd = sender.isOn
    }
    
    @IBAction func gradientSliderChanged(_ sender: UISlider) {
        
        updateTextPointsUI()
        updateGradientLayer()
    }
    
    @IBAction func strokeSwitchChanged(_ sender: UISwitch) {
        
        if ((gradientLayer.path) != nil) {
            gradientLayer.stroke = sender.isOn
        }
        
        sender.isOn = gradientLayer.stroke
    }
    
    @IBAction func maskSwitchChanged(_ sender: UISwitch) {
        if sender.isOn  {
            let style = PolygonStyle(rawValue:Int(arc4random_uniform(6)))!
            let radius = CGFloat(drand48()) * viewForGradientLayer.bounds.size.min
            let sides = Int(arc4random_uniform(32)) + 4
            let path = UIBezierPath.polygon(frame: viewForGradientLayer.bounds,
                                            sides: sides,
                                            radius:  radius,
                                            startAngle: 0,
                                            style: style,
                                            percentInflection: CGFloat(drand48()))
            gradientLayer.path  = path.cgPath
        } else{
            gradientLayer.path  = nil
            strokePath.isOn = false
        }
        updateGradientLayer()
    }
    
    
    @IBAction func typeSwitchChanged(_ sender: UISwitch) {
        self.gradientLayer.gradientType = sender.isOn ?  .radial : .axial;
        updateGradientLayer()
    }
    
    fileprivate func updateSlopeFunction(_ index: Int) {
        switch(index)
        {
        case 0:
            self.gradientLayer.function =  .linear
            break
        case 1:
            self.gradientLayer.function =  .exponential
            break
        case 2:
            self.gradientLayer.function =  .cosine
            break
        default:
            self.gradientLayer.function =  .linear
            assertionFailure();
        }
    }
    
    @IBAction func functionSwitchChanged(_ sender: UISegmentedControl) {
        
        updateSlopeFunction(sender.selectedSegmentIndex)
        
        updateGradientLayer()
    }
    
    @IBAction func animateSwitchChanged(_ sender: UISwitch) {
        self.animate = sender.isOn
        updateGradientLayer()
    }
    
    @IBAction func randomButtonTouchUpInside(_ sender: UIButton)
    {
        // random points
        pointStartX.value = Float(CGFloat(drand48()))
        pointStartY.value = Float(CGFloat(drand48()))
        pointEndX.value   = Float(CGFloat(drand48()))
        pointEndY.value   = Float(CGFloat(drand48()))
        
        // select random slope function
        selectIndexPath(Int(arc4random()) % tableView.numberOfRows(inSection: 0))
        let segmentIndex = Int(arc4random()) % segmenFunction.numberOfSegments
        updateSlopeFunction(segmentIndex)
        segmenFunction.selectedSegmentIndex = segmentIndex
        typeGardientSwitch.isOn = Float(drand48()) > 0.5 ? true : false
        extendsPastEnd.isOn  = Float(drand48()) > 0.5 ? true : false
        extendsPastStart.isOn = Float(drand48()) > 0.5 ? true : false
        
        if (typeGardientSwitch.isOn) {
            // random radius
            endRadiusSlider.value   = Float(drand48());
            startRadiusSlider.value = Float(drand48());
            // random scale CGAffineTransform
            gradientLayer.radialTransform = CGAffineTransform.randomScale()
        }
        // random colors
        randomizeColors()
        // update the UI
        updateTextPointsUI();
        // update the gradient layer
        updateGradientLayer()
    }
    
    // MARK: - Helpers
    
    func randomizeColors() {
        self.locations = []
        self.colors.removeAll()
        var numberOfColor  = round(Float(drand48()) * 16)
        while numberOfColor > 0 {
            let color = UIColor.random
            self.colors.append(color)
            numberOfColor = numberOfColor - 1
        }
        self.gradientLayer.colors = colors
    }
    
    
    func updateGradientLayer() {
        
        viewForGradientLayer.layoutIfNeeded()
        
        let endRadius   = Double(endRadiusSlider.value)
        let startRadius = Double(startRadiusSlider.value)
        
        let startPoint = CGPoint(x:CGFloat(pointStartX.value),y:CGFloat(pointStartY.value))
        let endPoint   = CGPoint(x:CGFloat(pointEndX.value),y:CGFloat(pointEndY.value))
        
        gradientLayer.extendsPastEnd   = extendsPastEnd.isOn
        gradientLayer.extendsBeforeStart = extendsPastStart.isOn
        gradientLayer.gradientType =  typeGardientSwitch.isOn ? .radial: .axial
        
        if (self.animate) {
            
            // allways remove all animations
            
            gradientLayer.removeAllAnimations()
            
            let mediaTime =  CACurrentMediaTime()
            CATransaction.begin()
            
            gradientLayer.animateKeyPath("colors",
                                         fromValue:nil,
                                         toValue: colors as AnyObject?,
                                         beginTime: mediaTime,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("locations",
                                         fromValue:nil,
                                         toValue: self.locations as AnyObject?,
                                         beginTime: mediaTime,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("startPoint",
                                         fromValue: NSValue(cgPoint: gradientLayer.startPoint),
                                         toValue: NSValue(cgPoint:startPoint),
                                         beginTime: mediaTime ,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("endPoint",
                                         fromValue: NSValue(cgPoint:gradientLayer.endPoint),
                                         toValue: NSValue(cgPoint:endPoint),
                                         beginTime: mediaTime,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            if gradientLayer.gradientType == .radial {
                gradientLayer.animateKeyPath("startRadius",
                                             fromValue: Double(gradientLayer.startRadius) as AnyObject?,
                                             toValue: startRadius as AnyObject?,
                                             beginTime: mediaTime ,
                                             duration: kDefaultAnimationDuration,
                                             delegate: nil)
                
                gradientLayer.animateKeyPath("endRadius",
                                             fromValue: Double(gradientLayer.endRadius) as AnyObject?,
                                             toValue: endRadius as AnyObject?,
                                             beginTime: mediaTime,
                                             duration: kDefaultAnimationDuration,
                                             delegate: nil)
            }
            
            CATransaction.commit()
            
        } else {
            
            gradientLayer.startPoint   = startPoint
            gradientLayer.endPoint     = endPoint
            gradientLayer.colors       = self.colors
            
            // gradientLayer.locations     = self.locations
            
            gradientLayer.startRadius   = CGFloat(startRadius)
            gradientLayer.endRadius     = CGFloat(endRadius)
            
            self.gradientLayer.setNeedsDisplay()
        }
    }
    
    func updateTextPointsUI() {
        
        // points text
        startPointSliderValueLabel.text =  String(format: "%.1f,%.1f", pointStartX.value,pointStartY.value)
        endPointSliderValueLabel.text   =  String(format: "%.1f,%.1f", pointEndX.value,pointEndY.value)
        
        //radius text
        startRadiusSliderValueLabel.text = String(format: "%.1f", Double(startRadiusSlider.value))
        endRadiusSliderValueLabel.text   = String(format: "%.1f", Double(endRadiusSlider.value))
    }
}
