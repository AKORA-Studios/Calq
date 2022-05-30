import UIKit

class HalfyearCell: UITableViewCell {
    static let identifier = "HalfyearCell"
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let pointLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    //Halfyear labels
    private let lab1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
    label.textColor = .systemGray4
        return label
    }()
    private let lab2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .systemGray4
        return label
    }()
    private let lab3: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .systemGray4
        return label
    }()
    private let lab4: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
       label.textColor = .systemGray4
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(lab1)
        contentView.addSubview(lab2)
        contentView.addSubview(lab3)
        contentView.addSubview(lab4)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(pointLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size : CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize: CGFloat = size/1.5
        
        pointLabel.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
        
        label.frame = CGRect(x: 25+iconContainer.frame.size.width, y: 0, width: contentView.frame.size.width-20-iconContainer.frame.size.width, height: contentView.frame.size.height)
        
        lab1.frame = CGRect(x: 25+iconContainer.frame.size.width - 105, y: 0, width: contentView.frame.size.width-20-iconContainer.frame.size.width, height: contentView.frame.size.height)
        lab2.frame = CGRect(x: 25+iconContainer.frame.size.width - 75, y: 0, width: contentView.frame.size.width-20-iconContainer.frame.size.width, height: contentView.frame.size.height)
        lab3.frame = CGRect(x: 25+iconContainer.frame.size.width - 45, y: 0, width: contentView.frame.size.width-20-iconContainer.frame.size.width, height: contentView.frame.size.height)
        lab4.frame = CGRect(x: 25+iconContainer.frame.size.width - 15, y: 0, width: contentView.frame.size.width-20-iconContainer.frame.size.width, height: contentView.frame.size.height)
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        lab1.text = nil
        lab2.text = nil
        lab3.text = nil
        lab4.text = nil
        pointLabel.text = nil
        iconContainer.backgroundColor = nil
        
        for label in [lab1,lab2,lab3,lab4]{
            label.textColor = .systemGray2
        }
    }
    
    public func configure(with model: YearOption){
        var array =  model.subtitle?.components(separatedBy: " ") ?? ["--","--","--","--"]
     
        while array.count <= 4 {
            array.append("")
        }
        
        label.text =  model.title.count > 23 ? String(model.title.prefix(21)) + "..." : model.title
        lab1.text =  array[0]
        lab2.text =  array[1]
        lab3.text =  array[2]
        lab4.text =  array[3]
        pointLabel.text = model.points != nil ? model.points : "0"
        iconContainer.backgroundColor = model.iconBackgroundColor
        
        /*if(model.points == "∑"){
            self.selectionStyle = .none
            self.accessoryType = .none
        }*/
        
        if((model.inactive) != nil){
            let labelArray = [lab1,lab2,lab3,lab4]
            for num in model.inactive!.components(separatedBy: " "){
                if(num == ""){continue}
                let number = (Int(num)) ?? 4
            
                let label: UILabel = labelArray[number - 1]
                label.textColor = .systemRed
            }
        }
    }
}
