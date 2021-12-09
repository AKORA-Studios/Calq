import UIKit
import CoreData

class SubjectSelectView:   ViewController, UITableViewDelegate,UITableViewDataSource{
    var models = [Section]()
    var settings: AppSettings?
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        self.navigationItem.title = "Note hinzufügen"
        update()
      
        if #available(iOS 15.0, *) {
            let appearence =  UITabBarAppearance()
            appearence.configureWithDefaultBackground()
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearence
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
    
    func navigateSubject(_ subject: UserSubject){
        let newView = storyboard?.getView("AddViewController") as! AddViewController
        
        newView.title = subject.name
        newView.subject = subject;
        
        self.present(newView, animated: true)
    }
    
    func configure(){
        var arr: [SettingsOptionType] = []
        let subjectArr = Util.getAllSubjects()
        
        for i in 0..<(subjectArr.count) {
            arr.append(
                .staticCell(
                    model:
                        SettingsOption(
                            title: subjectArr[i].name!,
                            subtitle: "",
                            icon: subjectArr[i].lk ? UIImage(systemName: "bookmark.fill") :  UIImage(systemName: "bookmark"),
                            iconBackgroundColor: settings!.colorfulCharts ? Util.getPastelColorByIndex(i) : UIColor.init(hexString: subjectArr[i].color!)
                        ){
                            self.navigateSubject(subjectArr[i])
                        })
            )
        }
        
        models.append(Section(title: "", options: arr))
        var arr2: [SettingsOptionType] = []
        arr2.append(
            .staticCell(
                model:
                    SettingsOption(
                        title: "Neuer Kurs",
                        subtitle: "",
                        icon: UIImage(systemName: "plus"),
                        iconBackgroundColor: .systemGreen
                    ){
                        self.navigateAddSubject()
                    })
        )
        models.append(Section(title: "", options: arr2))
    }
    
    func navigateAddSubject(){
        let newView = storyboard?.getView("NewSubjectView") as! NewSubjectView
        newView.callback = {
            self.update();
        }
        self.navigationController?.present(newView, animated: true)
    }

    @IBAction func navigateToPredictView(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "sub")
         let newView = storyboard?.getView("PredictView") as! PredictView
         self.navigationController?.present(newView, animated: true)
    }
    
}
