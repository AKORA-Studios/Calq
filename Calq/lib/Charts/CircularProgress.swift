//
//  AppDelegate.swift
//  CircularProgress
//
//  Created by Kiara on 07.11.21.
//
import UIKit

class CircularProgressView: UIView {
    private let labelLayer = CATextLayer()
    private let centerText = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    /// circle line width
    var lineWidth: Double  = 20
    /// Text inside the circle line 1
    var title : String = ""
    /// Text inside the circle line 2
    var subtitle : String = ""
    /// Circle foregroundColor
    var color: UIColor = UIColor.blue
    /// Circle backgroundColor
    var Backgroundcolor: UIColor = .systemBackground
    ///0.0 - 1.0
    var progress: Double = 0.5
    /// circle radius
    var radius: Int = 60
    
    override init(frame: CGRect) {
          super.init(frame: frame)
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: CGFloat(self.radius), startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        // Create background layer
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        backgroundLayer.lineWidth = self.lineWidth
        backgroundLayer.strokeEnd = 1.0
        backgroundLayer.strokeColor = Backgroundcolor.cgColor
        layer.addSublayer(backgroundLayer)
        
        // Create foreground layer
        foregroundLayer.path = circularPath.cgPath
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.lineCap = .round
        foregroundLayer.lineWidth = self.lineWidth
        foregroundLayer.strokeEnd = self.progress
        foregroundLayer.strokeColor = self.color.cgColor
        layer.addSublayer(foregroundLayer)
        }
    
    private func createLabels(){
        let centerPoint =  CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        centerText.sizeToFit()
        centerText.textAlignment = .center
        centerText.numberOfLines = 2

        if(self.subtitle == ""){  centerText.numberOfLines = 1 }
        centerText.frame = self.frame
        // center textfield in view
        centerText.center = centerPoint
        centerText.adjustsFontSizeToFitWidth = true
        
        //Text Formatting
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let firstAttributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 35.0), .foregroundColor: self.color, .paragraphStyle: titleParagraphStyle]
        let secondAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0), NSAttributedString.Key.foregroundColor: self.color, .paragraphStyle: titleParagraphStyle]
        
        let firstString = NSMutableAttributedString(string: self.title, attributes: firstAttributes)
        let secondString = NSMutableAttributedString(string: self.subtitle, attributes: secondAttributes)//
        
        firstString.append(secondString)
        centerText.attributedText = firstString
        
        self.addSubview(centerText)
    }
    
    
    func setprogress(_ progress: Double = 0.5, _ color: UIColor = UIColor.blue, _ text: String = "", _ text2: String = ""){
        self.progress =  progress
        self.color = color
        self.title = String(text.prefix(5))
        self.Backgroundcolor = .clear
        
        if(text2 != ""){self.subtitle = "\n" + text2}
        createLabels()
        createCircularPath()
    }
    
    func animate(_ value: Double, duration: TimeInterval = 2 ) {
            let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
            circularProgressAnimation.duration = duration
            circularProgressAnimation.toValue = value
            circularProgressAnimation.fillMode = .forwards
            circularProgressAnimation.isRemovedOnCompletion = false
            foregroundLayer.add(circularProgressAnimation, forKey: "progressAnim")
        }
}
