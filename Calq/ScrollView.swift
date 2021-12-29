import UIKit

class TestView: UIViewController, UIScrollViewDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        scrollView.delegate = self
        super.viewDidLoad()
        scrollView.isDirectionalLockEnabled = false
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        self.scrollView.contentSize = contentRect.size
        
        let size =  CGSize(width: self.view.frame.width, height: scrollView.contentSize.height)
        scrollView.contentSize = size
    }
}
