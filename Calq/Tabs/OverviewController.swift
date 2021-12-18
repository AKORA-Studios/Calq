import UIKit
import Charts
import CoreData

class OverviewController:  ViewController, ChartViewDelegate {

    @IBOutlet weak var halfyearChart: CalqYearBarChartView!
    @IBOutlet weak var barChart: BarChart!
    @IBOutlet weak var timeChart: LineChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pointChart: CircularProgressView!
    @IBOutlet weak var gradeChart: CircularProgressView!
    
    var settings: AppSettings?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        update()
    }
    
    func update() {
        self.settings = Util.getSettings()
        
        barChart.drawChart(Util.getAllSubjects())
        if(Util.getAllSubjects().count != 0){
            barChart.drawAverageLine(Util.generalAverage())
        }
        
        halfyearChart.drawChart()
        setTimeChart()
        
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
    }
}
