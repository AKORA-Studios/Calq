import Foundation
import UIKit

struct Section {
    let title: String
    let options: [SettingsOptionType]
}

struct Section2 {
    let title: String
    let options: [SettingsOptionType2]
}

enum SettingsOptionType{
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
    case gradeCell(model: GradeOption)
}

enum SettingsOptionType2{
    case gradeCell(model: GradeOption)
    case yearCell(model: YearOption)
    case staticCell(model: SettingsOption)
}

struct SettingsSwitchOption{
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    var isOn: Bool
    let selectHandler: (() -> Void)
    let switchHandler: (() -> Void)
}

struct SettingsOption{
    let title: String
    let subtitle: String?
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let selectHandler: (()-> Void)
}

struct GradeOption{
    let title: String
    let subtitle: String?
    let points: String?
    let iconBackgroundColor: UIColor
    let hideIcon: Bool
    let selectHandler: (()-> Void)
}

struct YearOption{
    let title: String
    let subtitle: String?
    let points: String?
    let iconBackgroundColor: UIColor
    let inactive: String?
    let selectHandler: (()-> Void)
}
