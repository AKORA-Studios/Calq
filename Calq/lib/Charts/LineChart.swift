//
//  LineChartView.swift
//  TestBarChart
//
//  Created by Kiara on 12.12.21.
//

import UIKit

class LineChart: UIView {
    typealias ChartEntry = (Double, Double)
    
    var maxYValue: Double = 15.0
    var maxXValue: Double = 100.0
    let values: [ChartEntry] = []
    var pointColor = UIColor.blue
    var lineColor = UIColor.systemGray3
    
    private var points: [CGPoint] = []

    private func clearView(){
        self.subviews.forEach({$0.removeFromSuperview()})
        self.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
    
    public func drawChart(_ values: [ChartEntry], _ max: Double){
        self.points = []
        self.maxXValue = max
        
        clearView()
        drawAxes()
        
        self.backgroundColor = .clear
        if(values.count == 0){return}
        
        //create points
        for i in 0..<values.count  {
            let value = values[i]
            points.append(createPoint(value.0, value.1))
        }
      
        // draw line between points
        for i in 0..<points.count{
            if(i + 1 == points.count) {continue}
            let point = points[i]
            let newPoint = points[i + 1]
            drawLine(point, newPoint)
            }
        
        // draw points
        for point in points{drawPoint(point)   }
    }
    
    private func drawLine(_ newPoint: CGPoint, _ oldPoint: CGPoint){
        let freeform = UIBezierPath()
        freeform.move(to: CGPoint(x: oldPoint.x + 2, y: oldPoint.y + 2))
        freeform.addLine(to: CGPoint(x: newPoint.x + 2, y: newPoint.y + 2))
        freeform.close()
  
        let layer =  CAShapeLayer()
        layer.path = freeform.cgPath
        layer.strokeColor = self.lineColor.cgColor
        layer.lineWidth = 3.0
        self.layer.addSublayer(layer)
    }
    
    private  func createPoint(_ x: Double,_ y: Double) -> CGPoint{
        let width = self.frame.width - 30.0
        let xValue = ((( x  * 100.0) / maxXValue) * width) / 100
        let yValue = (self.frame.height - ((y * 100 / maxYValue)) * self.frame.height / 100) + 2
       
        return CGPoint(x: xValue + 27, y: yValue)
        
    }
    
    private func drawPoint(_ Point: CGPoint){
        let path = UIBezierPath(ovalIn: CGRect(x: Point.x, y: Point.y, width: 4.0, height: 4.0))
        let layer =  CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = self.pointColor.cgColor
        self.layer.addSublayer(layer)
    }
    
    private func drawAxes(){
        let yAxis = UIView()
        yAxis.frame = CGRect(x: 17.0, y: 0.0, width: 1.0, height: self.frame.height)
        yAxis.backgroundColor = .systemGray3
        self.addSubview(yAxis)
   
        let zeroLineValue = (self.frame.maxY - self.frame.origin.y)
    
        drawAxe(0.0, "15")
        drawAxe(((500/15) * zeroLineValue) / 100, "10")
        drawAxe(((1000/15) * zeroLineValue) / 100, "5")
        drawAxe((self.frame.height - 5.0), "0")
    }
    
    private  func drawAxe(_ height: Double, _ title: String){
        let line3 = UIView()
        line3.frame = CGRect(x: 15.0, y: CGFloat(height + 5.0), width: self.frame.width - 20, height: 1.0)
        line3.backgroundColor = .systemGray5
        self.addSubview(line3)
        let label3 = UILabel()
        label3.frame = CGRect(x: 0.0, y: height , width: 15.0, height: 15.0)
        label3.text = title
        label3.adjustsFontSizeToFitWidth = true
        label3.textColor = .systemGray5
        self.addSubview(label3)
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
}
