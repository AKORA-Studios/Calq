import UIKit
import CoreData
import WidgetKit

class AddViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var impactView: UIView!
    @IBOutlet weak var gradeName: UITextField!
    @IBOutlet weak var gradeTypeSelect: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pointSlider: UISlider!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pointViewer: UILabel!
    @IBOutlet weak var yearSegment: UISegmentedControl!
    
    var bigGrade: Bool = false
    var selectedYear: Int = 1
    var subject: UserSubject?
    
    @IBAction func addNewGrade(_ sender: Any) {
        let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        
        let name = gradeName.text?.count == 0 ? "Neue Note" : gradeName.text
       
        if(Util.checkString(name!)){
            self.present(nameCharctersAlert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {nameCharctersAlert.dismiss(animated: true, completion: nil)})
        } else {
            
        let newTest = UserTest(context: CoreDataStack.shared.managedObjectContext)
        newTest.name = name
        newTest.grade =  Int16(pointSlider.value)
        newTest.date = datePicker.date
        newTest.big = bigGrade
        newTest.year = Int16(selectedYear)
        
        self.subject!.addToSubjecttests(newTest)
        try! CoreDataStack.shared.managedObjectContext.save()
        WidgetCenter.shared.reloadAllTimelines()
        
        self.dismiss(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var year: Int = 1
        
        if(self.subject?.subjecttests?.count != 0){
        var tests = self.subject!.subjecttests!.allObjects as! [UserTest]
        tests =  tests.sorted(by: ({$0.year > $1.year}))
        year = Int(tests[0].year)
        }
                         
        self.selectedYear = year
        self.yearSegment.selectedSegmentIndex = year - 1
        super.viewWillAppear(true)
        update()
    }
    
    override func viewDidLoad() {
        scrollView.delegate = self
        gradeName.delegate = self
        super.viewDidLoad()
        scrollView.isDirectionalLockEnabled = false
        
        self.navigationItem.title = "Note hinzufügen"
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(backButtonPressed))
        
        gradeName.delegate = self
        pointViewer.text = "9"
        pointSlider.value = 9.0
              
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        self.scrollView.contentSize = contentRect.size
        
        let size =  CGSize(width: self.view.frame.width, height: scrollView.contentSize.height)
        scrollView.contentSize = size
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)) )
        self.view.addGestureRecognizer(tapGesture)
        update()
        
        if #available(iOS 15.0, *) {
            let appearence =  UINavigationBarAppearance()
            appearence.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
          gradeName.resignFirstResponder()
      }
    
    @objc func backButtonPressed(_ sender:UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    
    func update(){
        setImpactSegemnts()
        self.subject = Util.getSubject(self.subject!.objectID)
        
        addButton.backgroundColor = .accentColor
        gradeTypeSelect.selectedSegmentTintColor = UIColor.init(hexString: self.subject!.color!)
        yearSegment.selectedSegmentTintColor = UIColor.init(hexString: self.subject!.color!)
        pointSlider.tintColor = UIColor.init(hexString: self.subject!.color!)
        
        if(Util.getSettings()!.colorfulCharts) {
        gradeTypeSelect.selectedSegmentTintColor = Util.getPastelColorByIndex(self.subject!.name!)
        yearSegment.selectedSegmentTintColor = Util.getPastelColorByIndex(self.subject!.name!)
        pointSlider.tintColor = Util.getPastelColorByIndex(self.subject!.name!)
        }
        setImpactSegemnts()
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch yearSegment.selectedSegmentIndex{
        case 0:
            selectedYear = 1
        case 1:
            selectedYear = 2
        case 2:
            selectedYear = 3
        case 3:
            selectedYear = 4
        default:
            selectedYear = 1
        }
        update()
    }
    
    @IBAction func gradeTypeChanged(_ sender: Any) {
        switch gradeTypeSelect.selectedSegmentIndex{
        case 0:
            bigGrade = false
        case 1:
            bigGrade = true
        default:
            bigGrade = false
        }
        update()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.value =  round(sender.value)
        pointViewer.text = String(Int(pointSlider.value))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gradeName.resignFirstResponder()
        return true
    }
    
    func setImpactSegemnts(){
        impactView.subviews.forEach({$0.removeFromSuperview()})
        
        let width = impactView.frame.width / 15
        impactView.frame = CGRect(x: impactView.frame.minX, y: impactView.frame.minY, width: CGFloat(width * 15), height: impactView.frame.height)
        var num: Double = 0.0
        let colors: [ImpactEntry] = self.subject != nil ? generateColors() : []
        impactView.backgroundColor = .clear
        
        for i in 1...15 {
            let text = UILabel()
            let gradeText = UILabel()
            let view = UIView()
            
            if(i == 1){
                view.layer.cornerRadius = 5.0
                view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
            if(i == 15) {
                view.layer.cornerRadius = 5.0
                view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            }
    
            let labelHeight = impactView.frame.height / 3
            let viewHeight = 2 * impactView.frame.height / 3
            if(self.subject == nil) { view.backgroundColor = .systemGray5} else { view.backgroundColor = (colors[i - 1]).0}
            
            view.frame = CGRect(x: num, y: 0, width: width, height: viewHeight)
            text.frame = CGRect(x: num, y: 0, width: width, height: viewHeight)
            gradeText.frame = CGRect(x: num, y: viewHeight, width: width, height: labelHeight)
            
            text.text = "\(i)"
            text.textAlignment = .center
            text.adjustsFontSizeToFitWidth = true
            text.textColor = .systemGray6
            
            gradeText.text = ""
            if(self.subject != nil)  {
                gradeText.text = (colors[i - 1]).1
                
                if((colors[i - 1]).1 != ""){
                    let stroke = UIView()
                    stroke.frame = CGRect(x: num, y: 20, width: 1, height: impactView.frame.height - 20.0 )
                    stroke.backgroundColor = view.backgroundColor
                    impactView.addSubview(stroke)
                }
            }
            gradeText.textAlignment = .center
            gradeText.adjustsFontSizeToFitWidth = true
            gradeText.textColor = .systemGray2
            
            impactView.addSubview(view)
            impactView.addSubview(text)
            impactView.addSubview(gradeText)
           
            num += width
        }
    }
    
    typealias ImpactEntry = (UIColor, String)
    
    func generateColors()-> [ImpactEntry]{
        var arr : [ImpactEntry] = []
        var none: Bool = false
        
        if(self.subject!.subjecttests?.count == 0 ) {none = true}
        var tests = self.subject!.subjecttests!.allObjects as! [UserTest]
        tests = tests.filter{Int($0.year) == selectedYear}
        if (tests.count == 0) {none = true}
        
        if(none){
            for _ in 1...15 {arr.append(ImpactEntry(.systemGray5, ""))}
            return arr
        }
        
        //calculation old grade
        var divider = 2.0
        let big =  Util.testAverage(tests.filter{$0.big})
        if(tests.filter{$0.big}.count == 0) {divider = 1}
        
        let small = Util.testAverage(tests.filter{!$0.big})
        if(tests.filter{!$0.big}.count == 0) {divider = 1}
        
        let averageOld: Int = Int((big + small)/divider)
        
        
        var worseLast: Int = 99
        var betterLast: Int = 99
        var sameLast: Int = 99
        //calculation new grade
        for i in 1...15 {
            divider = 2.0
            var newAverage: Int = 0
            
            if(gradeTypeSelect.selectedSegmentIndex == 0){ //small
                var gradeArr = tests.filter{!$0.big}.map{Int($0.grade)}
                gradeArr.append(i)
                let newSmall = Util.average(gradeArr)
                
                if(tests.filter{$0.big}.count == 0) {divider = 1}
                newAverage = Int(round((big + newSmall)/divider))
                
            }else { //big
                var gradeArr = tests.filter{$0.big}.map{Int($0.grade)}
                gradeArr.append(i)
                let newBig = Util.average(gradeArr)
                
                if(tests.filter{!$0.big}.count == 0) {divider = 1}
                newAverage = Int(round((newBig + small)/divider))
            }
            
            var str = "\(newAverage)"
            //push colors
            if(averageOld > newAverage){
                if(worseLast == newAverage) {str = ""}
                arr.append(ImpactEntry(.systemRed, str))
                worseLast = newAverage
                
            } else if(newAverage > averageOld ){
                if(betterLast == newAverage) {str = ""}
                arr.append(ImpactEntry(.systemGreen, str))
                betterLast = newAverage
            }
            else {
                if( sameLast == averageOld) {str = ""}
                sameLast = averageOld
                arr.append(ImpactEntry(.systemGray4, str))
            }
        }
        return  arr
    }
}
