import UIKit
import CoreData
import WidgetKit

class SetupSubject: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var SubjectTitle: UITextField!
    @IBOutlet weak var editGradesButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var colorDisplay: UIButton!
    @IBOutlet weak var subjectTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var colorChanger: UIButton!
    let colorPicker = UIColorPickerViewController()
    let deleteAlert = UIAlertController(title: "Möchtest du das Fach wirklich löschen?", message: "Auch alle Noten darin werden unwiederuflich gelöscht", preferredStyle: .alert)
    
    var subject: UserSubject!
    var deleted = false;
    var callback: (() -> Void)!;
    
    override func viewDidAppear(_ animated: Bool) {
        update()
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if (!self.deleted) {self.saveValues();}
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        SubjectTitle.text = self.title
        
        colorPicker.delegate =  self
        colorPicker.supportsAlpha = false
        SubjectTitle.delegate = self
        
        deleteAlert.addAction(UIAlertAction(title: "Nein", style: .default, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Löschen", style: .destructive, handler: {action in
            CoreDataStack.shared.managedObjectContext.delete(self.subject)
            self.deleted = true;

            self.dismiss(animated: true, completion: nil)
        }))
        
        colorPicker.selectedColor = UIColor.init(hexString: subject.color)
        colorDisplay.backgroundColor = UIColor.init(hexString: subject.color)
        subjectTypeSegment.selectedSegmentIndex = self.subject.lk ? 0 : 1
        
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "《 Zurück", style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.title = "Kurs bearbeiten"
        
        if #available(iOS 15.0, *) {
            let appearence =  UINavigationBarAppearance()
            appearence.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)) )
        self.view.addGestureRecognizer(tapGesture)
        view.backgroundColor = self.traitCollection.userInterfaceStyle == .light ? .white : .black
        update()
    }
    
    func update(){
        self.subject = Util.getSubject(self.subject.objectID)
        
        if(self.subject.subjecttests?.count == 0){
            editGradesButton.isUserInteractionEnabled = false
            editGradesButton.backgroundColor = .systemGray5
        } else {
            editGradesButton.isUserInteractionEnabled = true
            editGradesButton.backgroundColor = .accentColor
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        callback()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
          SubjectTitle.resignFirstResponder()
      }
    
    @objc func backButtonPressed(_ sender:UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteSubject(_ sender: Any) {
        self.present(deleteAlert, animated: true)
    }
    
    @IBAction func colorPalette(_ sender: UIButton) {
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func editGrades(_ sender: Any) {
        let newView = storyboard?.getView("gradeTableView") as! gradeTableView
        newView.subject = self.subject;
        newView.callback = {}
        self.navigationController?.pushViewController(newView, animated: true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorDisplay.backgroundColor = viewController.selectedColor
        self.saveValues()
        viewController.dismiss(animated: true, completion: nil)
        self.saveValues();
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { self.saveValues();}
   
    @IBAction func typeChanged(_ sender: UISegmentedControl) { self.saveValues();}
    
    func saveValues() {
        let name = SubjectTitle.text == "" ?  "Neuer Kurs" : SubjectTitle.text
        
        let context = CoreDataStack.shared.managedObjectContext
        self.subject.color = colorDisplay.backgroundColor?.toHexString() ?? "ffffff"
        
        self.subject.name = Util.replaceString(name!)
        self.subject.lk = subjectTypeSegment.selectedSegmentIndex == 1 ? false : true

        try! context.save()
        WidgetCenter.shared.reloadAllTimelines()
        update()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SubjectTitle.resignFirstResponder()
        return true
    }
}

extension SetupSubject: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorDisplay.backgroundColor =  viewController.selectedColor
    }
}
