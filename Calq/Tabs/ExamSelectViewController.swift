import UIKit
import CoreData
import WidgetKit

class ExamSelectView: ViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        return table
    }()
  
    var callback: (() -> Void)!;
    var subjects: [UserSubject]!
    var examtype: Int = 1
    var models = [Section]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.models = [];
        self.configure();
        self.tableView.reloadData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Prüfungsfachauswahl"
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "《 Zurück", style: .plain, target: self, action: #selector(backButtonPressed))
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        self.models = [];
        self.configure();
        self.tableView.reloadData();
        
        if #available(iOS 15.0, *) {
            let appearence =  UINavigationBarAppearance()
            appearence.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        }
    }
    
    @objc func backButtonPressed(_ sender:UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Table Setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return models[section].options.count}
    
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
        case .gradeCell(let model):
            model.selectHandler()
        }
    }
    
    func navigateBacktoExamView(_ id: NSManagedObjectID){
        let subject = Util.getSubject(id)
        let allSubjects = Util.getAllExamSubjects()
        
        let oldSub = allSubjects.filter{$0.examtype == Int16(examtype)}
        if(oldSub.count != 0){
            oldSub[0].exampoints = 0
            oldSub[0].examtype = 0
        }
        
        subject?.examtype = Int16(examtype)
        subject?.exampoints = 0;
        
        try! CoreDataStack.shared.managedObjectContext.save()
        WidgetCenter.shared.reloadAllTimelines()
        
        self.dismiss(animated: true, completion: ({
            self.callback();
        }))
    }
    
    func deleteExam(){
        Util.deleteExam(self.examtype)
        self.dismiss(animated: true, completion: ({
            self.callback();
        }))
    }
    
    func configure(){
        var arr: [SettingsOptionType] = []
        let subjectArr = self.subjects.sorted(by: {$0.name! < $1.name! })
    
            for sub in subjectArr {
                if(sub.examtype != 0 ){ continue}
                let color = Util.getSettings()!.colorfulCharts ? Util.getPastelColorByIndex(sub.name!) : UIColor.init(hexString: sub.color!)
                
                arr.append(
                    .staticCell(
                        model:
                            SettingsOption(
                                title: sub.name!,
                                subtitle: "",
                                icon: sub.lk ? UIImage(systemName: "bookmark.fill") :  UIImage(systemName: "bookmark"),
                                iconBackgroundColor: color
                            ){
                                self.navigateBacktoExamView(sub.objectID)
                            })
                )
            }
        
        let oldSub = Util.getAllExamSubjects().filter{$0.examtype == Int16(self.examtype)}
        if(oldSub.count != 0){
            arr.append(.staticCell(model: SettingsOption(
                title: "Prüfung löschen",
                subtitle: "",
                icon: UIImage(systemName: "xmark.bin.fill"),
                iconBackgroundColor:  UIColor.red
            ){
                self.deleteExam()
            }
                ))
        }
            models.append(Section(title: "Wähle einen Kurs als Prüfungsfach", options: arr))
    }
}
