import UIKit
import Charts
import CoreData

class OverviewController:  ViewController, ChartViewDelegate {

    @IBOutlet weak var barChartView: UIView!
    @IBOutlet weak var timeChart: LineChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pointChart: CircularProgressView!
    @IBOutlet weak var gradeChart: CircularProgressView!
    @IBOutlet weak var halfyearChart: BarChartView!
    
    var settings: AppSettings?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        update()
    }
    
    func update() {
        self.settings = Util.getSettings()
        
        setBarChart( Util.getAllSubjects())
        setTimeChart()
        sethalfyearChart()
        
        let grade = String(format: "%.2f",Util.grade(number: Util.generalAverage()))
        let subjects = Util.getAllSubjects()
        
        if (subjects.count > 0){
            let blocks = Util.generateBlockOne() + Util.generateBlockTwo()
            let blockGrade = Util.grade(number: Double(blocks * 15 / 900))
            
            gradeChart.setprogress(blocks/900, .accentColor, String(blockGrade), "⌀")
            pointChart.setprogress(Util.generalAverage()/15, .accentColor, String(format: "%.2f",Util.generalAverage()), grade)
        } else {
            gradeChart.setprogress(0.0, .accentColor, "0", "6.0")
            pointChart.setprogress(0.0, .accentColor, "0", "0.0")
        }
    }
    
    func getSubjectAverage(_ sub: UserSubject) -> Double{
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
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.navigationItem.title = "Übersicht"
        setupCharts();
        update()
        
        scrollView.contentSize = CGSize(
            width: scrollView.visibleSize.width,
            height: scrollView.visibleSize.height*1.4
        )
        
        if #available(iOS 15.0, *) {
            let appearence =  UITabBarAppearance()
            appearence.configureWithDefaultBackground()
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearence
        }
    }
    
    func setBarChart(_ subjects: [UserSubject]){
        barChartView.subviews.forEach({ $0.removeFromSuperview() })
        barChartView.backgroundColor = .clear
        
        if(subjects.count == 0){
            let label = UILabel()
            label.frame = barChartView.frame
            label.text = "Keine Daten vorhanden"
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            barChartView.addSubview(label)
            return
        }
        
        //barchart
        let width = (barChartView.frame.width - 20.0) / Double(subjects.count)
        var num = 20.0
        let spacer = Double(( 20 * width ) / 100)
        let barwidth = width - spacer
        
        //Y-Axis
        let yAxis = UIView()
        yAxis.frame = CGRect(x: 17.0, y: 0.0, width: 1.0, height: barChartView.frame.height)
        yAxis.backgroundColor = .systemGray5
        barChartView.addSubview(yAxis)
        
        let zeroLineValue = (barChartView.frame.maxY - barChartView.frame.origin.y)
        //15 line
        let line1 = UIView()
        line1.frame = CGRect(x: 15.0, y: 0.0 + 5, width: barChartView.frame.width - 20, height: 1.0)
        line1.backgroundColor = .systemGray5
        barChartView.addSubview(line1)
        let label1 = UILabel()
        label1.frame = CGRect(x: 0.0, y: 0.0 , width: 15.0, height: 15.0)
        label1.text = "15"
        label1.adjustsFontSizeToFitWidth = true
        label1.textColor = .systemGray5
        barChartView.addSubview(label1)
        
        //10 line
        let line2 = UIView()
        line2.frame = CGRect(x: 15.0, y: ((500/15)*zeroLineValue)/100 + 5, width: barChartView.frame.width - 20, height: 1.0)
        line2.backgroundColor = .systemGray5
        barChartView.addSubview(line2)
        let label2 = UILabel()
        label2.frame = CGRect(x: 0.0, y: ((500/15)*zeroLineValue)/100 , width: 15.0, height: 15.0)
        label2.text = "10"
        label2.adjustsFontSizeToFitWidth = true
        label2.textColor = .systemGray5
        barChartView.addSubview(label2)
        
        //5 line
        let line3 = UIView()
        line3.frame = CGRect(x: 15.0, y: ((1000/15)*zeroLineValue)/100 + 5, width: barChartView.frame.width - 20, height: 1.0)
        line3.backgroundColor = .systemGray5
        barChartView.addSubview(line3)
        let label3 = UILabel()
        label3.frame = CGRect(x: 0.0, y: ((1000/15)*zeroLineValue)/100 , width: 15.0, height: 15.0)
        label3.text = "5"
        label3.adjustsFontSizeToFitWidth = true
        label3.textColor = .systemGray5
        barChartView.addSubview(label3)
        
        //create bars
        for i in 0..<subjects.count  {
            let subject = subjects[i]
            let value =  getSubjectAverage(subject)
            
            let text = UILabel()
            let view = UIView()
            
            let hei = ((Double(value * 100 ) / 15) * barChartView.frame.height) / 100 - 5
            let textheight = (Double((1 * 100 ) / 15) * barChartView.frame.height) / 100 //labels with height of 1
            
            view.backgroundColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(i): UIColor.init(hexString: subject.color!)// .systemTeal
            
            let hi = barChartView.frame.height
            view.frame = CGRect(x: num, y: (barChartView.frame.maxY - barChartView.frame.origin.y), width: barwidth, height: (hi-(hi + hei)) )
            
            view.layer.cornerRadius = 5.0
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            text.frame = CGRect(x: num, y: (barChartView.frame.maxY - barChartView.frame.origin.y), width: barwidth, height: -textheight)
            text.text = "\(value)"
            text.textAlignment = .center
            text.adjustsFontSizeToFitWidth = true
            
            //Bar description
            let labelheight = 1.5 * Double(textheight)
            let barlabel = UILabel()
            barlabel.frame = CGRect(x: num, y: (barChartView.frame.maxY - barChartView.frame.origin.y), width: barwidth, height: labelheight)
            barlabel.text = String(subject.name!.prefix(3)).uppercased()
            barlabel.adjustsFontSizeToFitWidth = true
            barlabel.textAlignment = .center
            
            //draw everything
            barChartView.addSubview(view)
            barChartView.addSubview(text)
            barChartView.addSubview(barlabel)
            
            num += barwidth + spacer
        }
    }
    
    
    //MARK: Create Halfyear Bar Chart
    func sethalfyearChart(){
        if(!checkChartData()){
            halfyearChart.data = nil
            return;
        }
        
        var barchartEntries: [BarChartDataEntry] = []
        
        for i in 1...4 {
            let barEntry = BarChartDataEntry(x: Double(i), y: Util.generalAverage(i), data: Util.generalAverage(i))
            
            barchartEntries.append(barEntry)
        }
        
        let barChartSet = BarChartDataSet(entries: barchartEntries)
        barChartSet.colors = [UIColor.init(hexString: "428FE3")]
        
        self.halfyearChart.data = BarChartData(dataSet: barChartSet)
        self.halfyearChart.xAxis.axisMaximum = 4.5
        
        self.halfyearChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["1","2","3","4"])
        self.halfyearChart.animate(yAxisDuration: 0.6, easingOption: .easeInOutQuart)
    }
    
    
    //MARK: Create Time Chart
    func setTimeChart() {
        if(!checkChartData()){
            timeChart.data = nil
            return
        }
        
        let subjects = Util.getAllSubjects()
        
        do {
            let data = LineChartData()
            
            let minDate = try Util.calcMinDate()
            let maxDate = try Util.calcMaxDate()
            
            for subject in subjects {
                if(subject.subjecttests == nil) {continue}
                
                var lineEntries : [ChartDataEntry] = [];
                let Tests = (subject.subjecttests!.allObjects as! [UserTest])
                    .sorted{
                        $0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970
                    }
                
                var count = 0
                
                for test in Tests {
                    lineEntries.append(ChartDataEntry(
                        x: test.date!.timeIntervalSince(minDate),
                        y: Double(test.grade)
                    ))
                    count += 1
                }
                
                let colorful = settings!.colorfulCharts
                let lineChartSet = LineChartDataSet(entries: lineEntries)
                lineChartSet.mode = settings!.smoothGraphs ? .cubicBezier : .linear;
                lineChartSet.colors = colorful ? [Util.getPastelColorByIndex(subject.name!)] : [ UIColor.init(hexString: subject.color!)];
                
                lineChartSet.circleColors = colorful ? [Util.getPastelColorByIndex(subject.name!)] : [ UIColor.init(hexString: subject.color!)];
                lineChartSet.circleRadius = CGFloat(2)
                lineChartSet.circleHoleColor = .systemBackground
                
                lineChartSet.circleHoleRadius = CGFloat(1)
                lineChartSet.drawCirclesEnabled = false
                
                lineChartSet.drawHorizontalHighlightIndicatorEnabled = false
                lineChartSet.drawVerticalHighlightIndicatorEnabled = false
                lineChartSet.label = nil
                
                lineChartSet.lineWidth = CGFloat(2)
                data.addDataSet(lineChartSet)
            }
            
            data.setDrawValues(false)
            self.timeChart.data = data
            self.timeChart.xAxis.axisMinimum = 0
            self.timeChart.xAxis.axisMaximum = maxDate.timeIntervalSince(minDate)
        } catch {
            print("Something went wrong")
        }
    }
    
    // rounded bars: https://www.appcodezip.com/2021/03/rounded-bars-in-iOS-Charts.html
    //MARK: Setup Charts
    func setupCharts() {
        //MARK: Time Chart
        self.timeChart.noDataText = NoDataText
        self.timeChart.rightAxis.enabled = false;
        
        self.timeChart.xAxis.drawAxisLineEnabled = false
        self.timeChart.xAxis.drawGridLinesEnabled = false
        self.timeChart.xAxis.drawLabelsEnabled = false
        
        self.timeChart.leftAxis.axisMinimum = 0
        self.timeChart.leftAxis.axisMaximum = 16
        
        self.timeChart.rightAxis.drawLabelsEnabled = false
        self.timeChart.rightAxis.drawZeroLineEnabled = false
        self.timeChart.rightAxis.drawAxisLineEnabled = false
        self.timeChart.rightAxis.drawGridLinesBehindDataEnabled = false
        
        self.timeChart.legend.enabled = false
        self.timeChart.pinchZoomEnabled = false
        self.timeChart.doubleTapToZoomEnabled = false
        self.timeChart.scaleXEnabled = false
        self.timeChart.scaleYEnabled = false
        
        self.timeChart.leftAxis.gridLineWidth = CGFloat(1.5)
        self.timeChart.leftAxis.gridLineDashLengths = [4,1]
        self.timeChart.leftAxis.drawGridLinesEnabled = true
        self.timeChart.leftAxis.gridColor = .systemGray4
        self.timeChart.leftAxis.drawGridLinesBehindDataEnabled = true
        
        //MARK: Halfyear Chart
        self.halfyearChart.noDataText = NoDataText
        self.halfyearChart.highlightFullBarEnabled = false;
        self.halfyearChart.highlightPerTapEnabled = false;
        self.halfyearChart.highlightPerDragEnabled = false;
        
        self.halfyearChart.xAxis.drawAxisLineEnabled = false
        self.halfyearChart.xAxis.drawGridLinesEnabled = false
        self.halfyearChart.rightAxis.drawZeroLineEnabled = false
        self.halfyearChart.xAxis.labelPosition = .bottom
        self.halfyearChart.xAxis.drawLabelsEnabled = true
        self.halfyearChart.xAxis.avoidFirstLastClippingEnabled = true
        
        self.halfyearChart.leftAxis.gridLineWidth = CGFloat(1.5)
        self.halfyearChart.leftAxis.gridLineDashLengths = [4,1]
        self.halfyearChart.leftAxis.drawGridLinesEnabled = true
        self.halfyearChart.leftAxis.gridColor = .systemGray4
        
        self.halfyearChart.leftAxis.axisMinimum = 0
        self.halfyearChart.leftAxis.axisMaximum = 15
        self.halfyearChart.leftAxis.drawZeroLineEnabled = false
        self.halfyearChart.leftAxis.drawAxisLineEnabled = true
        self.halfyearChart.leftAxis.drawGridLinesBehindDataEnabled = true
        self.halfyearChart.leftAxis.drawLabelsEnabled = true
        
        self.halfyearChart.rightAxis.drawLabelsEnabled = false
        self.halfyearChart.rightAxis.drawGridLinesEnabled = false
        self.halfyearChart.rightAxis.drawZeroLineEnabled = false
        self.halfyearChart.rightAxis.drawAxisLineEnabled = false
        self.halfyearChart.rightAxis.drawGridLinesBehindDataEnabled = true
        
        self.halfyearChart.legend.enabled = false
        self.halfyearChart.xAxis.drawLabelsEnabled = false
        self.halfyearChart.drawValueAboveBarEnabled = true
        self.halfyearChart.pinchZoomEnabled = false
        self.halfyearChart.doubleTapToZoomEnabled = false
        
        self.halfyearChart.scaleXEnabled = false
        self.halfyearChart.scaleYEnabled = false
    }
}
