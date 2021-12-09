import UIKit
import CoreData
import WidgetKit

class PredictSelect: ViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        return table
    }()
  
    var models = [Section]()
    var callback: (() -> Void)!;
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.models = [];
        self.configure();
        self.tableView.reloadData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Kursauswahl"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        self.models = [];
        self.configure();
        self.tableView.reloadData();
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
        UserDefaults.standard.set(id.uriRepresentation().absoluteString, forKey: "sub")
        
        self.dismiss(animated: true, completion: ({
            self.callback();
        }))
    }
    
    func configure(){
        var arr: [SettingsOptionType] = []
        let subjectArr = Util.getAllSubjects().sorted(by: {$0.name! < $1.name! })
    
            for sub in subjectArr {
                if(sub.examtype != 0 ){ continue}
                arr.append(
                    .staticCell(
                        model:
                            SettingsOption(
                                title: sub.name!,
                                subtitle: "",
                                icon: sub.lk ? UIImage(systemName: "bookmark.fill") :  UIImage(systemName: "bookmark"),
                                iconBackgroundColor:  UIColor.accentColor
                            ){
                                self.navigateBacktoExamView(sub.objectID)
                            })
                )
            }
            models.append(Section(title: "Wähle einen Kurs", options: arr))
    }
}
