import UIKit
import CoreData

class SingleSubjectView: UIViewController  {
    
    @IBOutlet weak var yearSegment: UISegmentedControl!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var yearSwitch: UISwitch!
    @IBOutlet weak var gradesButton: UIButton!
    @IBOutlet weak var yeartimeChart: LineChart!
    
    var subject: UserSubject!
    var settings: AppSettings?
    var selectedYear = 1;
    var pastelColor: UIColor?
    var callback: (() -> Void)!;
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.callback()
    }
    
    func update() {
        self.settings = Util.getSettings()
        self.subject = Util.getSubject(self.subject.objectID)
        yearSwitch.isOn = Util.checkinactiveYears(Util.getinactiveYears(self.subject), self.selectedYear)
        
        self.pastelColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)
        
            if(self.subject!.subjecttests == nil){
                CircularProgress.setprogress(0.0, self.pastelColor!, "/", "")
            } else {
                let allTests = self.subject.subjecttests!.allObjects as! [UserTest]
                let arr = allTests.filter{$0.year == self.selectedYear};
                yearSegment.selectedSegmentIndex = self.selectedYear - 1
            
                CircularProgress.setprogress((Util.testAverage(arr)/15.0), self.pastelColor!, String(Util.testAverage(arr)), "")
            }
        setYearChart()
        
        if(self.subject.subjecttests?.count == 0){
            gradesButton.isUserInteractionEnabled = false
            gradesButton.backgroundColor = .systemGray5
        } else {
            gradesButton.isUserInteractionEnabled = true
            gradesButton.backgroundColor = .accentColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()

        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.title = self.subject.name
        self.yearSwitch.tintColor = self.pastelColor
        
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
        yearSegment.selectedSegmentTintColor = self.pastelColor
        
        if #available(iOS 15.0, *) {
            let appearence =  UINavigationBarAppearance()
            appearence.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        }
    }
    
    @objc func backButtonPressed(_ sender:UIButton) {
       self.dismiss(animated: true, completion: nil)
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
    
    typealias ChartEntry = (Double, Double)

    func getHalfYearAxes(_ arr: [UserTest]) -> [Double]{
        var returnArr: [Double] = [0.0]

        let maxYear = arr.sorted(by: {$0.year > $1.year })[0].year
        let minYear = arr.sorted(by: {$0.year < $1.year })[0].year
        if(minYear == maxYear){ return returnArr}
        
        let minimumDate = (arr.sorted(by: {$0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970})[0].date?.timeIntervalSince1970)! / 1000
        
        for i in minYear...maxYear{
            let tests = arr.filter({$0.year == i})
            let maxDate = (tests.sorted(by: {$0.date!.timeIntervalSince1970 > $1.date!.timeIntervalSince1970})[0].date?.timeIntervalSince1970)! / 1000 - minimumDate
            
            if(i + 1 > maxYear) {continue}
            let testsNew = arr.filter({$0.year == i + 1})
            let minDate = (testsNew.sorted(by: {$0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970})[0].date?.timeIntervalSince1970)! / 1000 - minimumDate
     
            let date = ((maxDate + minDate) / 2) + 1000
            returnArr.append(date)
        }
        return returnArr.filter({$0 != 0.0})
    }
    
    func setYearChart(){
        let tests =  self.subject.subjecttests!.allObjects as! [UserTest]
        if(tests.count == 0){return yeartimeChart.drawChart( 10.0)}
        
        let maxDate = (tests.sorted(by: {$0.date!.timeIntervalSince1970 > $1.date!.timeIntervalSince1970})[0].date?.timeIntervalSince1970)! / 1000
        let minDate = (tests.sorted(by: {$0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970})[0].date?.timeIntervalSince1970)! / 1000
        
        var arr: [ChartEntry] = []
        for test in tests {
            let x =  (test.date!.timeIntervalSince1970 / 1000) - minDate
            arr.append((Double(x), Double(test.grade)))
        }
 
        let color =  settings!.colorfulCharts ? self.pastelColor! : UIColor.init(hexString: self.subject.color!)
     
        yeartimeChart.drawChart( maxDate - minDate, getHalfYearAxes(tests))
        yeartimeChart.addDataSet(arr.sorted(by: {$0.0 > $1.0}), color)
    }

    @IBAction func navigateToGrades(_ sender: Any) {
       let newView = self.storyboard?.instantiateViewController(withIdentifier: "gradeTableView") as! gradeTableView
        newView.subject = self.subject;
        newView.callback = {
            self.update()
        }
     
        let navController = UINavigationController(rootViewController: newView)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
}
