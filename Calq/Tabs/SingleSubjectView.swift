import Charts
import UIKit
import CoreData

class SingleSubjectView: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearSegment: UISegmentedControl!
    @IBOutlet weak var timeChart: LineChartView!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var yearSwitch: UISwitch!
    
    var models = [Section]()
    var subject: UserSubject!
    var settings: AppSettings?
    
    let formatter = DateFormatter()
    var selectedYear = 1;
    var callback: (() -> Void)!;
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update()
    }
    
    func update() {
        self.settings = Util.getSettings()
        self.models = [];
        self.subject = Util.getSubject(self.subject.objectID)
        yearSwitch.isOn = Util.checkinactiveYears(Util.getinactiveYears(self.subject), self.selectedYear)
        configure();
        self.tableView.reloadData();
        
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
        
        tableView.register(GradeCell.self, forCellReuseIdentifier: GradeCell.identifier)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.formatter.dateFormat = "dd.MM"
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
        
        scrollView.contentSize = CGSize(
            width: scrollView.visibleSize.width,
            height: scrollView.visibleSize.height + tableView.visibleSize.height //- 200
        )
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
        
        self.timeChart.xAxis.valueFormatter =
        IndexAxisValueFormatter(values:tests.map({t in return self.formatter.string(from: t.date!)}))
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
    
    //MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return models[section].options.count}
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell{
        let model = models[indexpath.section].options[indexpath.row]
        
        switch model.self{
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexpath) as? SettingsCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingsCell.identifier, for: indexpath) as? SwitchSettingsCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .gradeCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GradeCell.identifier, for: indexpath) as? GradeCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self{
        case .staticCell(let model):
            model.selectHandler()
        case .switchCell(let model):
            model.selectHandler()
        case .gradeCell(model: let model):
            model.selectHandler()
        }
    }
    
    func navigateGrade(test: UserTest){
        let newView = storyboard?.getView("editGradeView") as! editGradeView
        newView.title = test.name
        newView.subject = self.subject;
        
        newView.test = test;
        newView.callback = { (sub) in
            self.update();
        }
        
        self.present(newView, animated: true)
    }

    
    func configure(){
        if(self.subject.subjecttests == nil){  return models.append(
            Section(title: "Noten", options: [.gradeCell(model: GradeOption(title: "Keine Noten qwq",subtitle: "", points: " X", iconBackgroundColor: settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) : UIColor.init(hexString: self.subject.color!), hideIcon: false, selectHandler: {}))])
        )}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
   
        for i in 1...4 {
            var name = "";
            switch i {
                case 1: name = "Erstes";
                case 2: name = "Zweites";
                case 3: name = "Drittes";
                case 4: name = "Viertes";
                default:name = "Letztes";
            }
            var tests = self.subject.subjecttests!.allObjects as! [UserTest]
            tests =  tests.filter{$0.year == i};
            if (tests.count < 1) {continue;}
   
            models.append(
                Section(title: name + " Halbjahr",
                        options: tests.enumerated().map(
                            {(ind, t) in
                                return .gradeCell(
                                    model:
                                        GradeOption(
                                            title: t.name ?? "Unknown Name",
                                            subtitle: dateFormatter.string(from: t.date!),
                                            points: String(t.grade),
                                            iconBackgroundColor: settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) : UIColor.init(hexString: self.subject.color!),
                                            hideIcon: t.big
                                        ){self.navigateGrade(
                                            test:t
                                        )
                                        }
                                )}
                        )
                )
            )
        }
        
        models.append(Section(title: "Neu", options: [    .staticCell(model: SettingsOption(
            title: "Neue Note hinzufügen", subtitle: "",
            icon: UIImage(systemName: "doc.badge.plus"), iconBackgroundColor: .systemGreen )
                    {
                        let addView = self.storyboard?.getView("AddViewController") as! AddViewController;
                        addView.title = self.subject.name;
                        addView.subject = self.subject
                        
                        addView.callback = {
                            self.update();
                        }
                        
                        self.present(addView, animated: true)
                    })]))
    }
}


