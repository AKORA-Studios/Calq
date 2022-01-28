//
//  BarChartView.swift
//  TestBarChart
//
//  Created by Kiara on 11.12.21.
//

import UIKit

class CalqYearBarChartView: UIView {
    
    private func clearView(){
        self.subviews.forEach({$0.removeFromSuperview()})
    }
    
    public func drawChart(){
        clearView()
        self.backgroundColor = .clear
        
        var values: [Double] = []
        for i in 1...4  {
            let value = Double(String(format: "%.2f", Util.generalAverage(i)))!
            if(value != 0.0){
                values.append(value)
            }
        }
        
        if(values.count == 0){
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
        
        let width = (self.frame.width - 20.0) / 4.0
        var num = 20.0
        let spacer = Double(( 20 * width ) / 100)
        let barwidth = width - spacer
        
        var count = 0.0
        var grades = 0.0
        for i in 1...4  {
            let value = Double(String(format: "%.2f", Util.generalAverage(i)))!
            if(value != 0){
                count += 1
                grades += value
            }
        }
        
        //draw averageline
        let average = grades / count
        let zeroLineValue = (self.frame.maxY - self.frame.origin.y)
        drawAxe((((15.0 - average) * 100/15)*zeroLineValue)/100, "⌀",.systemGray3)
        
        //create bars
        for i in 1...4  {
            let value = Double(String(format: "%.2f", Util.generalAverage(i)))!
            
            let text = UILabel()
            let view = UIView()
            
            var hei = ((Double(value * 100 ) / 15) * self.frame.height) / 100 - 5
            if(value == 0){hei = 0.0}
            let textheight = (Double((2 * 100 ) / 15) * self.frame.height) / 100
            
            view.backgroundColor = .accentColor
            
            let hi = self.frame.height
            view.frame = CGRect(x: num, y: (self.frame.maxY - self.frame.origin.y), width: barwidth, height: (hi-(hi + hei)) )
            
            view.layer.cornerRadius = 5.0
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            text.frame = CGRect(x: num, y: (self.frame.maxY - self.frame.origin.y), width: barwidth, height: -textheight)
            text.text = "\(value)"
            text.textAlignment = .center
            text.adjustsFontSizeToFitWidth = true
            text.textColor = .black
            
            //draw everything
            self.addSubview(view)
            self.addSubview(text)
            num += barwidth + spacer
        }
    }
    
    private func drawAxes(){
        //Y-Axis
        let yAxis = UIView()
        yAxis.frame = CGRect(x: 17.0, y: 0.0, width: 1.0, height: self.frame.height)
        yAxis.backgroundColor = .systemGray4
        self.addSubview(yAxis)
        
        let zeroLineValue = (self.frame.maxY - self.frame.origin.y)
        drawAxe(0, "15")
        drawAxe(((500/15)*zeroLineValue)/100, "10")
        drawAxe(((1000/15)*zeroLineValue)/100, "5")
    }
    
    func drawAxe(_ height: Double, _ title: String, _ color: UIColor = .systemGray4){
            let line3 = UIView()
            line3.frame = CGRect(x: 15.0, y: CGFloat(height + 5.0), width: self.frame.width - 20, height: 1.0)
            line3.backgroundColor = color
            self.addSubview(line3)
     
        let label3 = UILabel()
        label3.frame = CGRect(x: 0.0, y: height , width: 15.0, height: 15.0)
        label3.text = title
        label3.adjustsFontSizeToFitWidth = true
        label3.textColor = color
        self.addSubview(label3)
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
}
