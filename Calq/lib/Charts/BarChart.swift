//
//  BarChartView.swift
//  TestBarChart
//
//  Created by Akora on 11.12.21.
//

import UIKit

class CalqBarChartView: UIView {
    
    private var values: [UserSubject] = []
    
    private func clearView(){
        self.subviews.forEach({$0.removeFromSuperview()})
    }
    
    public func drawChart(_ values: [UserSubject]){
        self.values = values
        clearView()
        
        self.backgroundColor = .clear
        if(self.values.count == 0){
            let label = UILabel()
            label.frame = self.frame
            label.text = "Keine Daten vorhanden"
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            return self.addSubview(label)
        }
         drawAxes()
        
        let width = (self.frame.width - 20.0) / Double(values.count)
        var num = 20.0
        let spacer = Double(( 20 * width ) / 100)
        let barwidth = width - spacer
        
        //create bars
        for i in 0..<self.values.count  {
            let subject = values[i]
            let value = getSubjectAverage(subject)
            
            let text = UILabel()
            let view = UIView()
            
            let hei = ((Double(value * 100 ) / 15) * self.frame.height) / 100 - 5
            let textheight = (Double((1 * 100 ) / 15) * self.frame.height) / 100
            
            view.backgroundColor = Util.getSettings()!.colorfulCharts ? Util.getPastelColorByIndex(i): UIColor.init(hexString: subject.color!)
            
            let hi = self.frame.height
            view.frame = CGRect(x: num, y: (self.frame.maxY - self.frame.origin.y), width: barwidth, height: (hi-(hi + hei)) )
            
            view.layer.cornerRadius = 5.0
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            text.frame = CGRect(x: num, y: (self.frame.maxY - self.frame.origin.y), width: barwidth, height: -textheight)
            text.text = "\(value)"
            text.textAlignment = .center
            text.adjustsFontSizeToFitWidth = true
            text.textColor = .black
            
            //Bar description
            let labelheight = 1.5 * Double(textheight)
            let barlabel = UILabel()
            barlabel.frame = CGRect(x: num, y: (self.frame.maxY - self.frame.origin.y), width: barwidth, height: labelheight)
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
        let width = (self.frame.width - 20.0) / Double(values.count)
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
    
    private func getSubjectAverage(_ sub: UserSubject) -> Double{
        let tests = Util.filterTests(sub)
        if(tests.count == 0){return 0.0}
        
        var count = 0.0
        var subaverage = 0.0
        
        for e in 1...4 {
            let yearTests = tests.filter{$0.year == Int16(e)}
            if(yearTests.count == 0) {continue}
            count += 1
            subaverage += Util.testAverage(yearTests)
        }
        let average = subaverage / count
        return Double(String(format: "%.2f", average))!
    }
    
    public override init(frame: CGRect){
        print("help")
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
}
