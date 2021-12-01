import UIKit

class SwitchSettingsCell: UITableViewCell {
    static let identifier = "SwitchSettingsCell"
    public var callback: (() -> Void)?
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
     let settingsSwitch: UISwitch = {
        let settingsSwitch = UISwitch()
        settingsSwitch.onTintColor = UIColor.accentColor

        return settingsSwitch
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(settingsSwitch)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size : CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize: CGFloat = size/1.5
        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
        
        label.frame = CGRect(x: 25+iconContainer.frame.size.width, y: 0, width: contentView.frame.size.width-20-iconContainer.frame.size.width, height: contentView.frame.size.height)
        
        settingsSwitch.sizeToFit()
        settingsSwitch.frame = CGRect(x: contentView.frame.size.width-settingsSwitch.frame.size.width-20,
                                      y:(contentView.frame.size.height-settingsSwitch.frame.size.height)/2,
                                      width: settingsSwitch.frame.size.width, height: settingsSwitch.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
        settingsSwitch.isOn = false
    }
    
    public func configure(with model: SettingsSwitchOption){
        label.text =  model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        settingsSwitch.setOn(model.isOn, animated: true)
        callback = model.switchHandler
    }
}
