//
//  BarChartView.swift
//  TestBarChart
//
//  Created by Kiara on 11.12.21.
//

import UIKit

class BarChart: UIView {
    private var values: [UserSubject] = []
    
    private func clearView(){
        self.subviews.forEach({$0.removeFromSuperview()})
    }
    
    public func drawChart(_ values: [UserSubject], _ average: Double){
        self.values = values
        clearView()
        self.backgroundColor = .clear
        
        if(self.values.count == 0){
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
        
        let width = (self.frame.width - 20.0) / Double(values.count)
        var num = 20.0
        let spacer = Double(( 20 * width ) / 100)
        let barwidth = width - spacer
        
        //draw averageline
        let zeroLineValue = (self.frame.maxY - self.frame.origin.y)
        drawAxe((((15.0 - average) * 100/15)*zeroLineValue)/100, "⌀",.systemGray3)
        
        //create bars
        for i in 0..<self.values.count  {
            let subject = values[i]
            let value = Util.getSubjectAverage(subject)
            let color =  Util.getSettings()!.colorfulCharts ? Util.getPastelColorByIndex(i): UIColor.init(hexString: subject.color!)
            let yPosition = self.frame.maxY - self.frame.origin.y
            
            let text = UILabel()
            let view = UIView()
            view.backgroundColor = color
            
            let frameHeight = self.frame.height
            let barHeight = ((Double(value * 100 ) / 15) * self.frame.height) / 100 - 5
            let textheight = (Double((1 * 100 ) / 15) * self.frame.height) / 100
         
            view.frame = CGRect(x: num, y: yPosition, width: barwidth, height: (frameHeight-(frameHeight + barHeight)) )
            view.layer.cornerRadius = 5.0
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
        
            text.frame = CGRect(x: num + 1.0, y: yPosition, width: barwidth - 2.0, height: -textheight)
            text.text = String(format: "%.0f", round(value))
       
            text.textAlignment = .center
            text.adjustsFontSizeToFitWidth = true
            text.textColor = .black
            
            //Bar description
            let labelheight = 1.5 * Double(textheight)
            let barlabel = UILabel()
            barlabel.frame = CGRect(x: num, y: yPosition, width: barwidth, height: labelheight)
            barlabel.text = String(subject.name!.prefix(3)).uppercased()
            barlabel.adjustsFontSizeToFitWidth = true
            barlabel.textAlignment = .center
            
            //draw everything
            self.addSubview(view)
            self.addSubview(text)
            self.addSubview(barlabel)
            
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
        
        drawAxe(0, "15")
        drawAxe(((500/15)*zeroLineValue)/100, "10")
        drawAxe(((1000/15)*zeroLineValue)/100, "5")
    }
    
    func drawAxe(_ height: Double, _ title: String, _ color: UIColor = .systemGray5){
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
