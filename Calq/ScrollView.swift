import UIKit

class ScrollView: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(
            width: scrollView.visibleSize.width,
            height: scrollView.visibleSize.height*1.5
        )
    }



}
