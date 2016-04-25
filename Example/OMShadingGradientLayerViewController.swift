import UIKit
import InfColorPicker

let kDefaultAnimationDuration:NSTimeInterval = 5.0

class OMShadingGradientLayerViewController : UIViewController, UITableViewDataSource, UITableViewDelegate , InfColorPickerControllerDelegate{
    
    @IBOutlet weak var tableView:  UITableView!
    
    @IBOutlet weak var pointStartX:  UISlider!
    @IBOutlet weak var pointEndX:  UISlider!
    
    @IBOutlet weak var pointStartY:  UISlider!
    @IBOutlet weak var pointEndY:  UISlider!
    
    @IBOutlet weak var endPointSliderValueLabel : UILabel!
    @IBOutlet weak var startPointSliderValueLabel : UILabel!
    
    @IBOutlet weak var viewForGradientLayer: UIView!
    
    @IBOutlet weak var startRadiusSlider: UISlider!
    @IBOutlet weak var startRadiusSliderValueLabel: UILabel!
    @IBOutlet weak var endRadiusSlider: UISlider!
    @IBOutlet weak var endRadiusSliderValueLabel: UILabel!
    
    @IBOutlet weak var typeGardientSwitch: UISwitch!
    @IBOutlet weak var typeFunctionSwitch: UISwitch!
    
    @IBOutlet weak var extendsPastEnd: UISwitch!
    @IBOutlet weak var extendsPastStart: UISwitch!
    
    @IBOutlet weak var colorStartView : UIButton!
    @IBOutlet weak var colorEndView : UIButton!
    
    let pickerStart = InfColorPickerController(nibName: "InfColorPickerView", bundle: NSBundle(forClass: InfColorPickerController.self))
    
    let pickerEnd = InfColorPickerController(nibName: "InfColorPickerView", bundle: NSBundle(forClass: InfColorPickerController.self))
    
    var colors      : [CGColor] = [CGColor]()
    var locations   : [CGFloat] = [0,1]
    let gradientLayer = OMShadingGradientLayer(type: .Radial)
    var animate       = false
    
    lazy var slopeFunction: [(Double) -> Double] = {
        return [
            LinearInterpolation,
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
            // average
            QuadraticEaseInAverage,
            QuadraticEaseOutAverage,
            QuadraticEaseInOutAverage,
            CubicEaseInAverage,
            CubicEaseOutAverage,
            CubicEaseInOutAverage,
            QuarticEaseInAverage,
            QuarticEaseOutAverage,
            QuarticEaseInOutAverage,
            QuinticEaseInAverage,
            QuinticEaseOutAverage,
            QuinticEaseInOutAverage,
            SineEaseInAverage,
            SineEaseOutAverage,
            SineEaseInOutAverage,
            CircularEaseInAverage,
            CircularEaseOutAverage,
            CircularEaseInOutAverage,
            ExponentialEaseInAverage,
            ExponentialEaseOutAverage,
            ExponentialEaseInOutAverage,
            ElasticEaseInAverage,
            ElasticEaseOutAverage,
            ElasticEaseInOutAverage,
            BackEaseInAverage,
            BackEaseOutAverage,
            BackEaseInOutAverage,
            BounceEaseInAverage,
            BounceEaseOutAverage,
            BounceEaseInOutAverage
        ]
    }()
    
    lazy var slopeFunctionString:[String] = {
        return ["LinearInterpolation",
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
                //average
                "QuadraticEaseInAverage",
                "QuadraticEaseOutAverage",
                "QuadraticEaseInOutAverage",
                "CubicEaseInAverage",
                "CubicEaseOutAverage",
                "CubicEaseInOutAverage",
                "QuarticEaseInAverage",
                "QuarticEaseOutAverage",
                "QuarticEaseInOutAverage",
                "QuinticEaseInAverage",
                "QuinticEaseOutAverage",
                "QuinticEaseInOutAverage",
                "SineEaseInAverage",
                "SineEaseOutAverage",
                "SineEaseInOutAverage",
                "CircularEaseInAverage",
                "CircularEaseOutAverage",
                "CircularEaseInOutAverage",
                "ExponentialEaseInAverage",
                "ExponentialEaseOutAverage",
                "ExponentialEaseInOutAverage",
                "ElasticEaseInAverage",
                "ElasticEaseOutAverage",
                "ElasticEaseInOutAverage",
                "BackEaseInAverage",
                "BackEaseOutAverage",
                "BackEaseInOutAverage",
                "BounceEaseInAverage",
                "BounceEaseOutAverage",
                "BounceEaseInOutAverage"
        ]
    }()
    
    // MARK: - UITableView Helpers
    
    func selectIndexPath(row:Int, section:Int = 0) {
        let indexPath = NSIndexPath(forItem: row, inSection: section)
        self.tableView.selectRowAtIndexPath(indexPath,animated: true,scrollPosition: .Bottom)
        self.gradientLayer.slopeFunction = self.slopeFunction[indexPath.row];
    }
    
    // MARK: - UITableView Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slopeFunction.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        assert(self.slopeFunctionString.count == self.slopeFunction.count)
        
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.font          = UIFont(name: "Helvetica", size: 9)
        cell.textLabel?.text          = "\(self.slopeFunctionString[indexPath.row])"
        
        cell.layer.cornerRadius       = 8
        cell.layer.masksToBounds      = true
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.gradientLayer.slopeFunction = self.slopeFunction[indexPath.row];
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomizeColors()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewBounds = viewForGradientLayer.bounds
        
        pointStartX.maximumValue   = Float(viewBounds.size.width)
        pointStartY.maximumValue   = Float(viewBounds.size.height)
        
        pointEndX.maximumValue     = Float(viewBounds.size.width)
        pointEndY.maximumValue     = Float(viewBounds.size.height)
        
        let midPoint = CGPoint(x: CGRectGetMidX(viewBounds), y: CGRectGetMidY(viewBounds));
        
        pointStartX.value = Float(midPoint.x)
        pointStartY.value = Float(midPoint.y)
        
        pointEndX.value = Float(midPoint.x)
        pointEndY.value = Float(midPoint.y)
        
        extendsPastEnd.on   = true
        extendsPastStart.on = true
        endRadiusSlider.maximumValue     = radius(viewBounds.size)*2
        endRadiusSlider.minimumValue     = 0
        startRadiusSlider.maximumValue     = radius(viewBounds.size)*2
        startRadiusSlider.minimumValue     = 0
        
        endRadiusSlider.value   = radius(viewBounds.size)
        startRadiusSlider.value = 0.0;
        
        // select the first element
        selectIndexPath(0)
        
        gradientLayer.frame         = viewBounds
        gradientLayer.locations     = locations
        
        viewForGradientLayer.layer.addSublayer(gradientLayer)
        
        #if DEBUG
            viewForGradientLayer.layer.borderWidth = 1.0
            viewForGradientLayer.layer.borderColor = UIColor.blackColor().CGColor
        #endif
        
        updateUI()
        updateGradientLayer()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animateAlongsideTransition({(UIViewControllerTransitionCoordinatorContext) in
            
        }) {(UIViewControllerTransitionCoordinatorContext) in
            // update the gradient layer frame
            self.gradientLayer.frame = self.viewForGradientLayer.bounds
        }
    }
    
    // MARK: - Triggered actions
    
    @IBAction func extendsPastStartChanged(sender: UISwitch) {
        
        gradientLayer.extendsPastStart = sender.on
    }
    
    @IBAction func extendsPastEndChanged(sender: UISwitch) {
        
        gradientLayer.extendsPastEnd = sender.on
    }
    
    @IBAction func gradientSliderChanged(sender: UISlider) {
        
        updateGradientLayer()
    }
    
    @IBAction func strokeSwitchChanged(sender: UISwitch) {
        
        if ((gradientLayer.path) != nil) {
            gradientLayer.stroke = sender.on
        }
    }
    
    @IBAction func maskSwitchChanged(sender: UISwitch) {
        
        if (sender.on) {
            gradientLayer.path  = UIBezierPath.random(viewForGradientLayer.bounds.size)!.CGPath
        } else {
            gradientLayer.path = nil
        }
        
        updateGradientLayer()
    }
    
    
    @IBAction func typeSwitchChanged(sender: UISwitch) {
        self.gradientLayer.type = sender.on ?  .Radial : .Axial;
        updateGradientLayer()
    }
    
    @IBAction func functionSwitchChanged(sender: UISwitch) {
        self.gradientLayer.function = sender.on ? .Exponential : .Linear;
        updateGradientLayer()
    }
    
    @IBAction func animateSwitchChanged(sender: UISwitch) {
        self.animate = sender.on;
        updateGradientLayer()
    }
    
    @IBAction func randomButtonTouchUpInside(sender: UIButton)
    {
        let maxSize = gradientLayer.bounds.size
        
        endRadiusSlider.value   = Float(drand48()*Double(radius(gradientLayer.bounds.size)));
        startRadiusSlider.value = Float(drand48()*Double(radius(gradientLayer.bounds.size)));
        
        pointStartX.value = Float( maxSize.width * CGFloat(drand48()))
        pointStartY.value = Float( maxSize.height * CGFloat(drand48()))
        pointEndX.value   = Float( maxSize.width * CGFloat(drand48()))
        pointEndY.value   = Float( maxSize.height * CGFloat(drand48()))
        
        // select random element
        selectIndexPath(Int(rand()) % tableView.numberOfRowsInSection(0))
        
        randomizeColors()
        
        updateUI();
        
        updateGradientLayer()
        
    }
    
    
    @IBAction func colorStartViewTapped(sender: UIButton) {
        pickerStart.sourceColor = self.colorStartView.backgroundColor
        pickerStart.delegate    = self
        pickerStart.presentModallyOverViewController(self)
        
    }
    
    @IBAction func colorEndViewTapped(sender: UIButton) {
        pickerEnd.sourceColor = self.colorEndView.backgroundColor
        pickerEnd.delegate    = self;
        pickerEnd.presentModallyOverViewController(self)
    }
    
    // MARK: - Helpers
    
    func randomizeColors() {
        let color                 = UIColor.random()
        self.colors               = [color!.prev()!.CGColor,color!.next()!.CGColor]
        self.gradientLayer.colors = colors
    }
    
    func radius(size:CGSize) -> Float {
        if (size.height < size.width) {
            return Float(size.height) * 0.5;
        } else {
            return Float(size.width) * 0.5;
        }
    }
    
    func updateGradientLayer() {
        
        viewForGradientLayer.layoutIfNeeded()
        
        let endRadius   = Double(endRadiusSlider.value)
        let startRadius = Double(startRadiusSlider.value)
        
        let startPoint = CGPoint(x:CGFloat(pointStartX.value),y:CGFloat(pointStartY.value))
        let endPoint   = CGPoint(x:CGFloat(pointEndX.value),y:CGFloat(pointEndY.value))
        
        gradientLayer.extendsPastEnd   = extendsPastEnd.on
        gradientLayer.extendsPastStart = extendsPastStart.on
        
#if DEBUG
        print("Updating \(typeGardientSwitch.on ? "radial" : "axial") gradient\nstart: \(startPoint)\nend: \(endPoint)\nstartRadius: \(startRadius)\nendRadius: \(endRadius)\nbounds: \(gradientLayer.bounds.integral)\nFunction \(typeFunctionSwitch.on ? "exponential" : "linear") slope function: \(self.slopeFunctionString[tableView.indexPathForSelectedRow!.row])\n")
#endif
        if (self.animate) {
            
            // allways remove all animations
            
            gradientLayer.removeAllAnimations()
            
            let mediaTime =  CACurrentMediaTime()
            CATransaction.begin()
            
            gradientLayer.animateKeyPath("startRadius",
                                         fromValue: Double(gradientLayer.startRadius),
                                         toValue: startRadius,
                                         beginTime: mediaTime ,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("endRadius",
                                         fromValue: Double(gradientLayer.endRadius),
                                         toValue: endRadius,
                                         beginTime: mediaTime,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("startPoint",
                                         fromValue: NSValue(CGPoint: gradientLayer.startPoint),
                                         toValue: NSValue(CGPoint:startPoint),
                                         beginTime: mediaTime ,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("endCenter",
                                         fromValue: NSValue(CGPoint:gradientLayer.endPoint),
                                         toValue: NSValue(CGPoint:endPoint),
                                         beginTime: mediaTime,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("colors",
                                         fromValue:nil,
                                         toValue: colors,
                                         beginTime: mediaTime,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            
            gradientLayer.animateKeyPath("locations",
                                         fromValue:nil,
                                         toValue: self.locations,
                                         beginTime: mediaTime,
                                         duration: kDefaultAnimationDuration,
                                         delegate: nil)
            CATransaction.commit()
            
        } else {
            
            gradientLayer.startPoint   =  startPoint
            gradientLayer.endPoint     =  endPoint
            gradientLayer.colors        = self.colors
            gradientLayer.locations     = self.locations
            
            gradientLayer.startRadius   = CGFloat(startRadius)
            gradientLayer.endRadius     = CGFloat(endRadius)
            
            self.gradientLayer.setNeedsDisplay()
        }
    }
    
    func updateUI() {
        
        // points text
        startPointSliderValueLabel.text = "x:\(roundf(pointStartX.value))\ny:\(roundf(pointStartY.value))"
        endPointSliderValueLabel.text   = "x:\(roundf(pointEndX.value))\ny:\(roundf(pointEndY.value))"
        
        //radius text
        startRadiusSliderValueLabel.text = String(format: "%.1f", gradientLayer.startRadius)
        endRadiusSliderValueLabel.text   = String(format: "%.1f", gradientLayer.endRadius)
        
        assert(self.colors.count == 2);
        
        // color labels
        colorStartView.backgroundColor = UIColor(CGColor: self.colors.first!)
        colorEndView.backgroundColor   = UIColor(CGColor: self.colors.last!)
    }
    
    // MARK: -  InfColorPickerController Delegate
    
    func colorPickerControllerDidChangeColor(picker:InfColorPickerController) {
        //@unused
    }
    
    func colorPickerControllerDidFinish(picker:InfColorPickerController)
    {
        if (pickerStart == picker) {
            self.colors[0] = picker.resultColor.CGColor
        } else {
            self.colors[1] = picker.resultColor.CGColor
        }
        
        self.gradientLayer.colors = colors
        
        picker.dismissViewControllerAnimated(true) {
            self.updateUI()
            self.updateGradientLayer()
        }
    }
}
