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
    
    var pointColor = UIColor.blue
    var lineColor = UIColor.systemGray3
    var markAxes: [Double] = []
    
    var lineWidth: Double = 3.0
    var pointWidth: Double = 4.0
    var drawPoints: Bool = true
    var axeColor: UIColor = .systemGray4

    public func clearView(){
        self.subviews.forEach({$0.removeFromSuperview()})
        self.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
    
    public func drawChart(_ max: Double, _ markAxes: [Double] = []){
        self.maxXValue = max
        self.markAxes = markAxes
        clearView()
        self.backgroundColor = .clear
        
        if(Util.getAllSubjects().count == 0){
            let centerPoint =  CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
            let label = UILabel()
            label.frame = self.frame
            label.text = "Keine Daten vorhanden"
            label.textAlignment = .center
            label.center = centerPoint
            label.adjustsFontSizeToFitWidth = true
            return self.addSubview(label)
        }
        drawAxes()
        
        if(markAxes.count != 0){
            for axe in markAxes {
                let xValue = ((( axe  * 100.0) / maxXValue) *  self.frame.width - 30.0) / 100
                drawMarkAxes(xValue)
            }
        }
    }
    
    public func addDataSet(_ values: [ChartEntry], _ color: UIColor){
        var points: [CGPoint] = []
        //create points
            for value in values  {
            points.append(createPoint(value.0, value.1))
            }
    
            // draw line between points
            for i in 0..<points.count{
                if(i + 1 == points.count) {continue}
                let point = points[i]
                let newPoint = points[i + 1]
                drawLine(point, newPoint, color)
                }
            
            // draw points
        if(self.drawPoints)   {  for point in points{drawPoint(point, color)   }}
    }
    
    private func drawLine(_ newPoint: CGPoint, _ oldPoint: CGPoint, _ color: UIColor){
        let freeform = UIBezierPath()
        freeform.move(to: CGPoint(x: oldPoint.x + 2, y: oldPoint.y + 2))
        freeform.addLine(to: CGPoint(x: newPoint.x + 2, y: newPoint.y + 2))
        freeform.close()
  
        let layer =  CAShapeLayer()
        layer.path = freeform.cgPath
        layer.strokeColor = color.cgColor
        layer.lineWidth = self.lineWidth
        self.layer.addSublayer(layer)
    }
    
    private  func createPoint(_ x: Double,_ y: Double) -> CGPoint{
        let width = self.frame.width - 25.0
        let xValue = ((( x  * 100.0) / maxXValue) * width) / 100

        let yValue = (self.frame.height - ((y * 100 / maxYValue)) * self.frame.height / 100) + 2
       
        return CGPoint(x: xValue + 17, y: yValue)
    }
    
    private func drawPoint(_ Point: CGPoint,_ color: UIColor){
        let path = UIBezierPath(ovalIn: CGRect(x: Point.x, y: Point.y, width: self.pointWidth, height: self.pointWidth))
        let layer =  CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        self.layer.addSublayer(layer)
    }
    
    private func drawAxes(){
        let yAxis = UIView()
        yAxis.frame = CGRect(x: 17.0, y: 0.0, width: 1.0, height: self.frame.height)
        yAxis.backgroundColor = .systemGray4
        self.addSubview(yAxis)
   
        let zeroLineValue = (self.frame.maxY - self.frame.origin.y)
    
        drawAxe(0.0, "15")
        drawAxe(((500/15) * zeroLineValue) / 100, "10")
        drawAxe(((1000/15) * zeroLineValue) / 100, "5")
        drawAxe((self.frame.height - 5.0), "0")
    }
    
    private func drawMarkAxes(_ value: Double){
        let Axe = UIView()
        Axe.frame = CGRect(x: value, y: 0.0, width: 1.0, height: self.frame.height)
        Axe.backgroundColor = axeColor
        self.addSubview(Axe)
    }
    
    private  func drawAxe(_ height: Double, _ title: String){
        let line3 = UIView()
        line3.frame = CGRect(x: 15.0, y: CGFloat(height + 5.0), width: self.frame.width - 20, height: 1.0)
        line3.backgroundColor = axeColor
        self.addSubview(line3)
        let label3 = UILabel()
        label3.frame = CGRect(x: 0.0, y: height , width: 15.0, height: 15.0)
        label3.text = title
        label3.adjustsFontSizeToFitWidth = true
        label3.textColor = axeColor
        self.addSubview(label3)
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
}
