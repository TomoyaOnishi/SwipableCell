import UIKit

class SwipableTableViewCell: UITableViewCell {

    @IBOutlet weak var swipeViewMarginRight: NSLayoutConstraint!
    @IBOutlet weak var swipeView: UIView!

    var panGestureRecognizer: UIPanGestureRecognizer!
    var tableView: UITableView? { return superview as? UITableView }

    override func awakeFromNib() {
        super.awakeFromNib()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        panGestureRecognizer.delegate = self
        swipeView.addGestureRecognizer(panGestureRecognizer)
    }

    var trackingCount = 0
    var trackingTranslation = CGPoint.zero
    var allowsSwipe = false

    @objc func didPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let translation = CGPoint(x: -self.swipeViewMarginRight.constant, y: 0.0)
            panGestureRecognizer.setTranslation(translation, in: swipeView)
        case .changed:
            let translation = panGestureRecognizer.translation(in: swipeView)
            trackingCount = trackingCount + 1
            trackingTranslation.x += translation.x
            trackingTranslation.y += translation.y
            if trackingCount == 3 {
                allowsSwipe = allowsSwipeWithTranslation(translation: trackingTranslation)
            }
            if self.allowsSwipe {
                tableView?.isScrollEnabled = false
                let translation = self.panGestureRecognizer.translation(in: swipeView)
                swipeView.transform = CGAffineTransform.identity.translatedBy(x: translation.x, y: 0.0)
                // If you want to modify the constraint directly.
                // swipeViewMarginRight.constant = translation.x
            }
        case .cancelled, .ended:
            UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                self.swipeView.transform = .identity
                // swipeViewMarginRight.constant = 0.0
            }, completion: { (_) in
                self.trackingCount = 0
                self.allowsSwipe = false
                self.trackingTranslation = CGPoint.zero
                self.tableView?.isScrollEnabled = true
            })
        default:
            break
        }
    }

    func allowsSwipeWithTranslation(translation: CGPoint) -> Bool {
        let slope: CGFloat = abs(translation.y) / abs(translation.x)
        let radian: CGFloat = atan(slope)
        let angle = radian * 180 / CGFloat(Double.pi)

        if angle >= 0 && angle <= 30 {
            return true
        }
        return false
    }

}

extension SwipableTableViewCell {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
