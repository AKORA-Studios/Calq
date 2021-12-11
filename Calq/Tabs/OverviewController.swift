import UIKit
import Charts
import CoreData

class OverviewController:  ViewController, ChartViewDelegate {
    
    @IBOutlet weak var barChart: CombinedChartView!
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
        
        setBarChart()
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
    
    //MARK: Create Bar Chart
    func setBarChart() {
        if(!checkChartData()){
            barChart.data = nil
            return;
        }
        let subjects = Util.getAllSubjects()
        
        var lineEntries : [ChartDataEntry] = []
        var barchartEntries: [BarChartDataEntry] = []
        
        var completeAvg = 0.0, avgCount = 0.0;
        for i in 0..<subjects.count {
            let subj = subjects[i]
            let tests = Util.filterTests(subjects[i]);
            
            var count = 0.0
            var subaverage = 0.0
            if(tests.count != 0 ){
                for e in 1...4 {
                    let yearTests = tests.filter{$0.year == Int16(e)}
                    if(yearTests.count == 0) {continue}
                    count += 1
                    subaverage += Util.testAverage(yearTests)
                }
                
                let average = subaverage / count
                completeAvg += subaverage / count
                avgCount += 1.0
                
                let barEntry = BarChartDataEntry(x: Double(i), y: Double(average), data: average)
                barchartEntries.append(barEntry)
            }
        }
        
        completeAvg /= avgCount;
        lineEntries.append(ChartDataEntry(x: -0.5, y: completeAvg));
        for i in 0..<(subjects.count) {
            lineEntries.append(ChartDataEntry(x:Double(i+1), y: completeAvg));
        }
        
        lineEntries.append(ChartDataEntry(x: Double(subjects.count) + 0.5, y: completeAvg));
        let lineChartSet = LineChartDataSet(entries: lineEntries)
        let barChartSet = BarChartDataSet(entries: barchartEntries)
        
        
        barChartSet.colors = settings!.colorfulCharts ? Util.pastelColors : subjects.map({UIColor.init(hexString: $0.color!)});
        
        lineChartSet.label = nil
        lineChartSet.colors = [ .systemBlue]
        lineChartSet.drawCirclesEnabled = false
        
        lineChartSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartSet.drawVerticalHighlightIndicatorEnabled = false
        
        let data = CombinedChartData()
        data.barData = BarChartData(dataSet: barChartSet)
        data.lineData = LineChartData(dataSet: lineChartSet)
        data.lineData.setDrawValues(false)
        
        self.barChart.data = data
        self.barChart.xAxis.axisMinimum = -0.5
        self.barChart.xAxis.axisMaximum = Double(subjects.count) - 0.5
        
        let arr = subjects.map{sub -> String in
            let str = sub.name!,
                index = str.index(str.startIndex, offsetBy: 3);
            return str[..<index].uppercased()
        };
        
        self.barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: arr)
        self.barChart.xAxis.setLabelCount(( subjects.count*2) + 1, force: false)
        //   barChart.animate(yAxisDuration: 0.6, easingOption: .easeInOutQuart)
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
        self.barChart.noDataText = NoDataText
        self.barChart.highlightFullBarEnabled = false;
        self.barChart.highlightPerTapEnabled = false;
        self.barChart.highlightPerDragEnabled = false;
        
        self.barChart.xAxis.drawAxisLineEnabled = true
        self.barChart.xAxis.drawGridLinesEnabled = false
        self.barChart.xAxis.labelPosition = .bottom
        self.barChart.xAxis.drawLabelsEnabled = true
        self.barChart.xAxis.avoidFirstLastClippingEnabled = true
        
        self.barChart.leftAxis.gridLineWidth = CGFloat(1.5)
        self.barChart.leftAxis.gridLineDashLengths = [4,1]
        self.barChart.leftAxis.drawGridLinesEnabled = true
        self.barChart.leftAxis.gridColor = .systemGray4
        
        self.barChart.leftAxis.axisMinimum = 0
        self.barChart.leftAxis.axisMaximum = 15
        self.barChart.leftAxis.drawZeroLineEnabled = false
        self.barChart.leftAxis.drawAxisLineEnabled = false
        self.barChart.leftAxis.drawGridLinesBehindDataEnabled = true
        self.barChart.leftAxis.drawLabelsEnabled = true
        self.barChart.leftAxis.setLabelCount(8, force: true)
        
        self.barChart.rightAxis.drawLabelsEnabled = false
        self.barChart.rightAxis.drawGridLinesEnabled = false
        self.barChart.rightAxis.drawZeroLineEnabled = false
        self.barChart.rightAxis.drawAxisLineEnabled = false
        self.barChart.rightAxis.drawGridLinesBehindDataEnabled = true
        
        self.barChart.legend.enabled = false
        
        self.barChart.drawValueAboveBarEnabled = true
        self.barChart.pinchZoomEnabled = false
        self.barChart.doubleTapToZoomEnabled = false
        
        self.barChart.scaleXEnabled = false
        self.barChart.scaleYEnabled = false
        
        
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
