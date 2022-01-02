import UIKit
import CoreData

class SubjectTableView: ViewController, UITableViewDelegate, UITableViewDataSource{
    var models = [Section2]()
    var settings: AppSettings?
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HalfyearCell.self, forCellReuseIdentifier: HalfyearCell.identifier)
        return table
    }()
    
    let demoAlert = UIAlertController(title: "Info", message: "Du musst 40 Halbjahre einbringen :3 Behalte hier einen Überblick", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        demoAlert.addAction(UIAlertAction(title: "Oki", style: .default, handler: nil))
        self.navigationItem.title = "Alle Kurse"
        update()
      
        if #available(iOS 15.0, *) {
            let appearence =  UITabBarAppearance()
            appearence.configureWithDefaultBackground()
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearence
            
            let appearence2 =  UINavigationBarAppearance()
            appearence2.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence2
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update()
    }
    
    func update() {
        self.settings = Util.getSettings()
        self.models = [];
        configure();
        self.tableView.reloadData();
    }
    
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
            
        case .yearCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HalfyearCell.identifier, for: indexpath) as? HalfyearCell else {
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
        case .yearCell(model: let model):
            model.selectHandler()
        case .gradeCell(let model):
            model.selectHandler()
        }
    }
    
    func navigateSubject(_ subject: UserSubject){
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "SingleSubjectView") as! SingleSubjectView
        
        newView.title = subject.name
        newView.subject = subject;
        newView.callback = { self.update();}
        
        let navController = UINavigationController(rootViewController: newView)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func configure(){
        var arr: [SettingsOptionType2] = []
        let subjects = Util.getAllSubjects()
        
            for sub in subjects {
                let str = (Util.averageString(sub))
                let subAverage = Util.getSubjectAverage(sub)
                let color = settings!.colorfulCharts ? Util.getPastelColorByIndex(sub.name!) : UIColor.init(hexString: sub.color!)
           
                arr.append(
                    .yearCell(
                        model:
                            YearOption(
                                title: sub.name!,
                                subtitle: str,
                                points: String(format: "%.0f", round(subAverage)),
                                iconBackgroundColor: color,
                                inactive: sub.inactiveYears
                            ){
                                self.navigateSubject(sub)
                            })
                )
            }
            let title = subjects.count == 0 ? "Du hast noch keine Kurse hinzugefügt" : ""
            models.append(Section2(title: title, options: arr))
        
        if(subjects.count != 0){
            let inactives = Util.calcInactiveYearsCount()
            let halfyears = subjects.count * 4
 
            models.append( Section2(title: "", options: [.yearCell(model: YearOption(title: "\(halfyears - inactives) von \(halfyears) aktiv", subtitle: "", points: "∑", iconBackgroundColor: .accentColor, inactive: "", selectHandler: {
                self.present(self.demoAlert, animated: true, completion: nil)
            }))]))
        }
    }
}
