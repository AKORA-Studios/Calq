import UIKit

class GradeCell: UITableViewCell {
    static let identifier = "GradeCell"
    
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
    
    private let sublabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .systemGray4
        label.textAlignment = .right
        return label
    }()
    
    private let pointLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(sublabel)
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
        
        sublabel.frame = CGRect(x: 25+iconContainer.frame.size.width - 15, y: 0, width: contentView.frame.size.width-20-iconContainer.frame.size.width, height: contentView.frame.size.height)
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        sublabel.text = nil
        pointLabel.text = nil
        iconContainer.backgroundColor = nil
    }
    
    public func configure(with model: GradeOption){
        label.text =  model.title.count > 23 ? String(model.title.prefix(21)) + "..." : model.title
        sublabel.text =  model.subtitle != nil ? model.subtitle : ""
        pointLabel.text = model.points != nil ? model.points : "0"
        iconContainer.backgroundColor = model.iconBackgroundColor
        if(!(model.hideIcon)) {iconContainer.backgroundColor = UIColor.clear}
        
        if(model.hideArrow) {self.accessoryType = .none }
    }
}
