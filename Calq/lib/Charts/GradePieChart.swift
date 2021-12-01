import Foundation
import Charts

class GradePieView: PieChartView {
    
    public func updateData() {
        if(!checkChartData()){
            self.data = nil
            return
        }
        
        let grade = String(format: "%.2f",Util.grade(number: Util.generalAverage())),
            average = Util.generalAverage()
        if ( average == 99.9) {return;}

        let PieChartSet = PieChartDataSet(entries: [
            .init(value: average),
            .init(value: 15.0-average)
        ] as [PieChartDataEntry], label: nil)
        
        PieChartSet.selectionShift = 0
        PieChartSet.colors = [  UIColor.accentColor, .clear]
        PieChartSet.drawValuesEnabled = false

        self.data = PieChartData(dataSet: PieChartSet)
        self.centerText = grade

        //Text Formatting
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center

        let firstAttributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 25.0), .foregroundColor: UIColor.accentColor, .paragraphStyle: titleParagraphStyle]
        let secondAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor.accentColor, .paragraphStyle: titleParagraphStyle]
        let firstString = NSMutableAttributedString(string: "\(grade)\n", attributes: firstAttributes)
        let secondString = NSAttributedString(string: String(format: "%.2f", average), attributes: secondAttributes)
        firstString.append(secondString)

        self.centerAttributedText = firstString
        self.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
    
    private func setupChart() {
        self.legend.enabled = false
        self.transparentCircleColor = .systemBackground
        self.holeColor = .systemBackground
        self.isUserInteractionEnabled = false
        self.noDataText = NoDataText
        self.backgroundColor = .systemBackground

        self.updateData();
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setupChart()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupChart()
    }
    
}
