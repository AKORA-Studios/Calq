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
         drawAxes()
        
        let width = (self.frame.width - 20.0) / 4.0
        var num = 20.0
        let spacer = Double(( 20 * width ) / 100)
        let barwidth = width - spacer
        
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
        yAxis.backgroundColor = .systemGray5
        self.addSubview(yAxis)
        
        let zeroLineValue = (self.frame.maxY - self.frame.origin.y)
        //15 line
        let line1 = UIView()
        line1.frame = CGRect(x: 15.0, y: 0.0 + 5, width: self.frame.width - 20, height: 1.0)
        line1.backgroundColor = .systemGray5
        self.addSubview(line1)
        let label1 = UILabel()
        label1.frame = CGRect(x: 0.0, y: 0.0 , width: 15.0, height: 15.0)
        label1.text = "15"
        label1.adjustsFontSizeToFitWidth = true
        label1.textColor = .systemGray5
        self.addSubview(label1)
        
        //10 line
        let line2 = UIView()
        line2.frame = CGRect(x: 15.0, y: ((500/15)*zeroLineValue)/100 + 5, width: self.frame.width - 20, height: 1.0)
        line2.backgroundColor = .systemGray5
        self.addSubview(line2)
        let label2 = UILabel()
        label2.frame = CGRect(x: 0.0, y: ((500/15)*zeroLineValue)/100 , width: 15.0, height: 15.0)
        label2.text = "10"
        label2.adjustsFontSizeToFitWidth = true
        label2.textColor = .systemGray5
        self.addSubview(label2)
        
        //5 line
        let line3 = UIView()
        line3.frame = CGRect(x: 15.0, y: ((1000/15)*zeroLineValue)/100 + 5, width: self.frame.width - 20, height: 1.0)
        line3.backgroundColor = .systemGray5
        self.addSubview(line3)
        let label3 = UILabel()
        label3.frame = CGRect(x: 0.0, y: ((1000/15)*zeroLineValue)/100 , width: 15.0, height: 15.0)
        label3.text = "5"
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
