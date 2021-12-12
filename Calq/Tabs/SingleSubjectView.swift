import Charts
import UIKit
import CoreData

class SingleSubjectView: UIViewController, ChartViewDelegate  {
    
    @IBOutlet weak var yearSegment: UISegmentedControl!
    @IBOutlet weak var timeChart: LineChartView!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var yearSwitch: UISwitch!
    @IBOutlet weak var gradesButton: UIButton!
    
    var subject: UserSubject!
    var settings: AppSettings?
    
    var selectedYear = 1;
    var callback: (() -> Void)!;
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update()
    }
    
    func update() {
        self.settings = Util.getSettings()
        self.subject = Util.getSubject(self.subject.objectID)
        yearSwitch.isOn = Util.checkinactiveYears(Util.getinactiveYears(self.subject), self.selectedYear)
        
        let pastelColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)

            if(self.subject!.subjecttests == nil){
                setChart([])
                CircularProgress.setprogress(0.0, pastelColor, "/", "")
            }else {
                let allTests = self.subject.subjecttests!.allObjects as! [UserTest]
                let arr = allTests.filter{$0.year == self.selectedYear};
                yearSegment.selectedSegmentIndex = self.selectedYear - 1
                
                setChart(arr)
                CircularProgress.setprogress((Util.testAverage(arr)/15.0), pastelColor, String(Util.testAverage(arr)), "")
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.callback()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
        self.setup()

        subjectName.text = self.subject.name
        
        subjectName.textColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)
        self.yearSwitch.tintColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)
        
        if(self.subject.subjecttests?.count != 0){
            var tests = self.subject.subjecttests!.allObjects as! [UserTest]
            
            tests =  tests.sorted(by: ({$0.year > $1.year}))
            let year = Int(tests[0].year)
          
            yearSegment.selectedSegmentIndex = selectedYear + 1;
            self.selectedYear = year
        }else {
            yearSegment.selectedSegmentIndex = 0;
            self.selectedYear = 0
        }
    
        yearSegment.selectedSegmentTintColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)
        
    }
    
    // Switch changed
    @IBAction func switchChanged(_ sender: Any) {
        if(yearSwitch.isOn){
            _ = Util.removeYear(self.subject, self.selectedYear)
        } else{
            _ = Util.addYear(self.subject, self.selectedYear)
        }
    }
    
   // Segemnt changed
    @IBAction func indexChanged(_ sender: Any) {
        self.selectedYear = self.yearSegment.selectedSegmentIndex + 1;
        self.update()
    }
    
    //MARK: Create Time Chart
    func setChart(_ tests: [UserTest]) {
        if (self.subject == nil) {return;}
        if(tests.count == 0){
            self.timeChart.data = nil
        return
        }
        
        var lineEntries: [ChartDataEntry] = []
        
        for i in 0..<tests.count {
            lineEntries.append(ChartDataEntry(
                x:Double(i),
                y: Double(tests[i].grade)
            ))
        }
        
        let lineChartSet = LineChartDataSet(entries: lineEntries)
        lineChartSet.mode =  settings!.smoothGraphs ? .cubicBezier : .linear;

        
        let pastelColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)
        lineChartSet.colors = [ pastelColor]
        
        var bigCol = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!),
        smallCol = bigCol,
            hue: CGFloat = 0, sat: CGFloat = 0, bright: CGFloat = 0, alpha: CGFloat = 0;
        
        bigCol.getHue(&hue, saturation: &sat, brightness: &bright, alpha: &alpha)
        smallCol  = UIColor(hue: (hue+0.5).truncatingRemainder(dividingBy: 1.0), saturation: sat, brightness: bright, alpha: alpha)
        
        lineChartSet.circleColors = tests.map{$0.big ? bigCol : smallCol}
        lineChartSet.circleRadius = CGFloat(4)
        lineChartSet.circleHoleColor = UIColor.label
        lineChartSet.circleHoleRadius = CGFloat(0.0)
        lineChartSet.drawCirclesEnabled = true
        lineChartSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartSet.drawVerticalHighlightIndicatorEnabled = false
        lineChartSet.label = nil
        lineChartSet.lineWidth = CGFloat(4)
   
        let data = LineChartData(dataSet: lineChartSet)
        data.setDrawValues(false)
        self.timeChart.data = data
        
        if (tests.count > 0) {
            self.timeChart.xAxis.axisMinimum = -0.5;
            self.timeChart.xAxis.axisMaximum = Double(tests.count) - 0.5
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        self.timeChart.xAxis.valueFormatter =
        IndexAxisValueFormatter(values:tests.map({t in return formatter.string(from: t.date!)}))
    }
    
    //MARK: Setup Charts
    func setup() {
        self.timeChart.noDataText = NoDataText
        self.timeChart.xAxis.drawAxisLineEnabled = false
        self.timeChart.xAxis.drawGridLinesEnabled = false
        self.timeChart.xAxis.labelPosition = .bottom
        self.timeChart.xAxis.drawLabelsEnabled = false
        
        self.timeChart.rightAxis.drawLabelsEnabled = false
        self.timeChart.rightAxis.drawZeroLineEnabled = false
        self.timeChart.rightAxis.drawAxisLineEnabled = false
        self.timeChart.rightAxis.drawGridLinesBehindDataEnabled = false
        
        self.timeChart.legend.enabled = false
        self.timeChart.pinchZoomEnabled = false
        self.timeChart.doubleTapToZoomEnabled = false
        self.timeChart.scaleXEnabled = false
        self.timeChart.scaleYEnabled = false
        self.timeChart.rightAxis.enabled = false
        
        self.timeChart.leftAxis.axisMinimum = 0
        self.timeChart.leftAxis.axisMaximum = 15
        self.timeChart.leftAxis.gridLineWidth = CGFloat(1.5)
        self.timeChart.leftAxis.gridLineDashLengths = [4,1]
        self.timeChart.leftAxis.drawGridLinesEnabled = true
        self.timeChart.leftAxis.gridColor = .systemGray4
        self.timeChart.leftAxis.drawGridLinesBehindDataEnabled = true
    }

    @IBAction func navigateToGrades(_ sender: Any) {
        let newView = storyboard?.getView("gradeTableView") as! gradeTableView
        newView.subject = self.subject;
        self.present(newView, animated: true)
    }
}
