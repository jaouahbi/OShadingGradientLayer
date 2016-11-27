
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

let kDefaultAnimationDuration:TimeInterval = 5.0

class OMShadingGradientLayerViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    @IBOutlet weak var typeFunctionSwitch: UISwitch!
    
    @IBOutlet weak var extendsPastEnd   : UISwitch!
    @IBOutlet weak var extendsPastStart : UISwitch!
    
    
    var colors      : [UIColor] = []
    var locations   : [CGFloat] = [0.0,1.0]
    
    let gradientLayer = OMShadingGradientLayer(type: .axial)
    var animate       = false
    
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
            "LinearInterpolation",
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
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomizeColors()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewBounds = viewForGradientLayer.bounds
        
        pointStartX.maximumValue   = 1.0
        pointStartY.minimumValue   = 0.0
        
        pointEndX.maximumValue     = 1.0
        pointEndY.minimumValue     = 0.0
        
        let startPoint = CGPoint(x:viewBounds.minX,y: viewBounds.minY) / viewBounds.size
        let endPoint   = CGPoint(x:viewBounds.minX,y: viewBounds.maxY) / viewBounds.size
        
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
        
        viewForGradientLayer.layer.addSublayer(gradientLayer)
        
        viewForGradientLayer.backgroundColor = UIColor.black
        
        #if DEBUG
            viewForGradientLayer.layer.borderWidth = 1.0
            viewForGradientLayer.layer.borderColor = UIColor.blackColor().CGColor
        #endif
        
        updateUI()
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
        
        updateUI()
        updateGradientLayer()
    }
    
    @IBAction func strokeSwitchChanged(_ sender: UISwitch) {
        
        if ((gradientLayer.path) != nil) {
            gradientLayer.stroke = sender.isOn
        }
    }
    
    @IBAction func maskSwitchChanged(_ sender: UISwitch) {

        if sender.isOn  {
            let path = UIBezierPath.polygon(frame: viewForGradientLayer.bounds,
                                            sides: Int(arc4random_uniform(32)) + 4,
                                            radius:  CGFloat(drand48()) * viewForGradientLayer.bounds.size.min(),
                                            startAngle: 0 ,
                                            style: PolygonStyle(rawValue:Int(arc4random_uniform(6)))!,
                                            percentInflection: CGFloat(drand48()))
            gradientLayer.path  = path.cgPath
        } else{
            gradientLayer.path  = nil
        }

        updateGradientLayer()
    }
    
    
    @IBAction func typeSwitchChanged(_ sender: UISwitch) {
        self.gradientLayer.gradientType = sender.isOn ?  .radial : .axial;
        
        if (sender.isOn == false) {
            // axial
            pointStartX.value = 0.0
            pointStartY.value = 0.5
            pointEndX.value   = 1.0
            pointEndY.value   = 0.5
            
        } else {
            
            //center
            pointStartX.value = 0.5
            pointStartY.value = 0.5
            pointEndX.value   = 0.5
            pointEndY.value   = 0.5
        }
        
        updateGradientLayer()
    }
    
    @IBAction func functionSwitchChanged(_ sender: UISegmentedControl) {
        
        switch(sender.selectedSegmentIndex)
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
        
        updateGradientLayer()
    }
    
    @IBAction func animateSwitchChanged(_ sender: UISwitch) {
        self.animate = sender.isOn;
        updateGradientLayer()
    }
    
    @IBAction func randomButtonTouchUpInside(_ sender: UIButton)
    {
        //        // random radius
        //        endRadiusSlider.value   = Float(drand48());
        //        startRadiusSlider.value = Float(drand48());
        //
        //        // random points
        //        pointStartX.value = Float(CGFloat(drand48()))
        //        pointStartY.value = Float(CGFloat(drand48()))
        //        pointEndX.value   = Float(CGFloat(drand48()))
        //        pointEndY.value   = Float(CGFloat(drand48()))
        
        // select random slope function
        //        selectIndexPath(Int(arc4random()) % tableView.numberOfRows(inSection: 0))
        
        
        if (gradientLayer.isAxial) {
            // axial
            pointStartX.value = 0.0
            pointStartY.value = 0.5
            pointEndX.value   = 1.0
            pointEndY.value   = 0.5
            
        } else {
            
            //center
            pointStartX.value = 0.5
            pointStartY.value = 0.5
            pointEndX.value   = 0.5
            pointEndY.value   = 0.5
            
            // random scale CGAffineTransform
        
            gradientLayer.radialTransform = CGAffineTransform.randomScale()
            
        }
        
        // random colors
        randomizeColors()
        // update the UI
        updateUI();
        // update the gradient layer
        updateGradientLayer()
    }
    
    // MARK: - Helpers
    
    func randomizeColors() {
       self.locations = []
        self.colors.removeAll()
        var numberOfColor  = 2
        while numberOfColor > 0 {
            if let color = UIColor.random() {
                self.colors.append(color)
                numberOfColor = numberOfColor - 1
            }
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
        
        if (self.animate) {
            
            // allways remove all animations
            
            gradientLayer.removeAllAnimations()
            
            let mediaTime =  CACurrentMediaTime()
            CATransaction.begin()
            
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
            
            gradientLayer.animateKeyPath("startPoint",
                                         fromValue: NSValue(cgPoint: gradientLayer.startPoint),
                                         toValue: NSValue(cgPoint:startPoint),
                                         beginTime: mediaTime ,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("endCenter",
                                         fromValue: NSValue(cgPoint:gradientLayer.endPoint),
                                         toValue: NSValue(cgPoint:endPoint),
                                         beginTime: mediaTime,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
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
    
    func updateUI() {
        
        // points text
        startPointSliderValueLabel.text =  String(format: "%.1f,%.1f", pointStartX.value,pointStartY.value)
        endPointSliderValueLabel.text   =  String(format: "%.1f,%.1f", pointEndX.value,pointEndY.value)
        
        //radius text
        startRadiusSliderValueLabel.text = String(format: "%.1f", Double(startRadiusSlider.value))
        endRadiusSliderValueLabel.text   = String(format: "%.1f", Double(endRadiusSlider.value))
        
        //assert(self.colors.count == 2)
    }
}
