import UIKit
import CoreData

class ExamViewController: ViewController {
    @IBOutlet weak var Block1: UIProgressView!
    @IBOutlet weak var Block2: UIProgressView!
    @IBOutlet weak var block1Label: UILabel!
    @IBOutlet weak var block2Label: UILabel!
    
    @IBOutlet weak var P1Field: UIButton!
    @IBOutlet weak var P1Points: UILabel!
    @IBOutlet weak var P1Slider: UISlider!
    
    @IBOutlet weak var P2Field: UIButton!
    @IBOutlet weak var P2Points: UILabel!
    @IBOutlet weak var P2Slider: UISlider!
    
    @IBOutlet weak var P3Field: UIButton!
    @IBOutlet weak var P3Points: UILabel!
    @IBOutlet weak var P3Slider: UISlider!
    
    @IBOutlet weak var P4Field: UIButton!
    @IBOutlet weak var P4Points: UILabel!
    @IBOutlet weak var P4Slider: UISlider!
    
    @IBOutlet weak var P5Field: UIButton!
    @IBOutlet weak var P5Points: UILabel!
    @IBOutlet weak var P5Slider: UISlider!
    
    var examFields: [UIButton] = []
    var examLabels: [UILabel] = [ ]
    var examSliders: [UISlider] = []
    
    let errorAlert = UIAlertController(title: "Fehler qwq", message: "Du hast nicht genügend Fächer eingetragen", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad();
        examFields = [P1Field,P2Field,P3Field,P4Field,P5Field]
        examLabels = [P1Points,P2Points,P3Points,P4Points,P5Points]
        examSliders = [P1Slider,P2Slider,P3Slider,P4Slider,P5Slider]
        
        update()
        
        self.navigationItem.title = "Prüfungsübersicht"
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        for (i, label) in examLabels.enumerated() {
            label.text = String(Int(examSliders[i].value))
        }
        
        if #available(iOS 15.0, *) {
            let appearence =  UITabBarAppearance()
            appearence.configureWithDefaultBackground()
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearence
            
            let appearence3 =  UINavigationBarAppearance()
            appearence3.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence3
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        update()
    }
    
    func update() {
        let subjects = Util.getAllExamSubjects()
        if(subjects.count != 0){
            
            for sub in subjects.filter({$0.examtype > 0}) {
                let points = Float(Int(sub.exampoints))
                
                let slider = examSliders[Int(sub.examtype)-1],
                    field = examFields[Int(sub.examtype)-1],
                    label = examLabels[Int(sub.examtype)-1]
                
                field.backgroundColor = .accentColor//.systemGray3
                field.setTitle(sub.name, for: .normal)
                slider.setValue(points, animated: true)
                label.text = String(sub.exampoints)
            }
            
            for (i, _) in examFields.enumerated() {
                if(subjects.filter{$0.examtype == Int16(i+1)}.count != 0){continue}
                let slider = examSliders[i],
                    field = examFields[i],
                    label = examLabels[i]
                
                field.backgroundColor = .systemGray3
                field.setTitle("Prüfungsfach wählen", for: .normal)
                slider.setValue(Float(0), animated: true)
                label.text = "0"
            }
           //set everything to default values if there are no exam subjects selected
        }else {
            for (i, _) in examFields.enumerated() {
                if(subjects.filter{$0.examtype == Int16(i+1)}.count != 0){continue}
                let slider = examSliders[i],
                    field = examFields[i],
                    label = examLabels[i]
                
                field.backgroundColor = .systemGray3
                field.setTitle("Prüfungsfach wählen", for: .normal)
                slider.setValue(Float(0), animated: true)
                label.text = "0"
            }
        }
   
       setBlocks()
    }
    
    @IBAction func selectOne(_ sender: UIButton) {
        var exam: Int = 1
        
        if(sender == P2Field){
            exam = 2
        }else if(sender == P3Field){
            exam = 3
        }else if(sender == P4Field){
            exam = 4
        }else if(sender == P5Field){
            exam = 5
        }
        navigateExamSelect(exam)
    }
    
    func navigateExamSelect(_ num: Int){
        let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "ExamSelectView") as! ExamSelectView
        var subs = Util.getAllSubjects()
        
        let lktypes = subs.filter{$0.lk}.filter{$0.examtype != 0} 
        let gktypes = subs.filter{!$0.lk}.filter{$0.examtype != 0}
        
        if(num == 1   || num == 2){
            subs = subs.filter{$0.lk}.filter{$0.examtype == 0}
        } else {
            subs = subs.filter{!$0.lk}.filter{$0.examtype == 0}
        }
        
        if(lktypes.count == 2){}else if(gktypes.count == 3 ){}
        else if(subs.count == 0 && Util.getAllSubjects().filter{$0.examtype == num}.count == 0) {return  self.present(self.errorAlert, animated: true, completion: nil)}
        
        newView.examtype = num
        newView.subjects = subs
        newView.callback = {
            self.update();
        }
        let navController = UINavigationController(rootViewController: newView)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        var num =  String(Int(sender.value))
        var index: Int = 1
     
        for (i, slider ) in examSliders.enumerated() {
            if(sender == slider){
                index = i
            }
        }
      
        let activeLabel: UILabel = examLabels[index]
        let examtype: Int = index + 1
        let examSubjectArr = Util.getAllExamSubjects().filter{$0.examtype == Int16(examtype)}

        if(examSubjectArr.count == 0) {
            num = "0"
            sender.value = 0
            return
        }

        sender.value = round(sender.value)
        activeLabel.text = num
  
        Util.updateExampoints(examtype, Int(sender.value))
        update()
    }
    
    //MARK: Block Calc Stuff
    func generateBlockTwo() -> Int{
        var sum = 0;
        sum +=  Int(P1Slider.value) * 4
        sum +=  Int(P2Slider.value) * 4
        sum +=  Int(P3Slider.value) * 4
        sum +=  Int(P4Slider.value) * 4
        sum +=  Int(P5Slider.value) * 4
        return sum
    }
    
    func setBlocks(){
        let block1points = Util.generateBlockOne()
        if(block1points < 200){
            Block1.tintColor = .red
            block1Label.textColor = .red
        }else {
            Block1.tintColor = .accentColor
            block1Label.textColor = .accentColor
        }
        let posibleBlock1Points = Util.generatePossibleBlockOne()
        
        block1Label.text = "\(String(Int(block1points))) von \(String(Int(posibleBlock1Points)))"
        
        if(block1points == 0.0) {
            Block1.progress = 0.0
        }else {
            let points = ( 100.0 * block1points ) / posibleBlock1Points
            Block1.progress = Float( points / 100.0)
        }
        
        let block2points = generateBlockTwo()
        let possibleblock2points  = 5 * (15 * 4)
        block2Label.text = "\(String(block2points)) von \(String(possibleblock2points))"
        
        if(block2points == 0) {
            Block2.progress = 0.0
        }else {
            let points = ( 100.0 * Double(block2points) ) / Double(possibleblock2points)
            Block2.progress = Float( points / 100.0)
        }
    }
}
