//
//  SwipableTableViewCell.swift
//  SwipableCell
//
//  Created by TomoyaOnishi on 2014/10/12.
//  Copyright (c) 2014年 TomoyaOnishi. All rights reserved.
//

import UIKit

class SwipableTableViewCell: UITableViewCell {

    
    @IBOutlet weak var swipeViewMarginRight: NSLayoutConstraint!
    @IBOutlet weak var swipeView: UIView!
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var tableView: UITableView {
        
        return self.superview?.superview as UITableView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPan:")
        self.panGestureRecognizer.delegate = self
        self.swipeView.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    
    var trackingCount = 0
    var trackingTranslation = CGPointZero
    var allowsSwipe = false
    
    
    func didPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            let translation = CGPoint(x: -self.swipeViewMarginRight.constant, y: 0.0)
            self.panGestureRecognizer.setTranslation(translation, inView: self.swipeView)
        case .Changed:
            let translation = self.panGestureRecognizer.translationInView(self.swipeView)
            
            // 最初の数回のtranslationを別途保持してスワイプの角度を計算し、
            // TableViewのスクロールなのかセルのスワイプなのかを判断する
            self.trackingCount++
            self.trackingTranslation.x += translation.x
            self.trackingTranslation.y += translation.y
            if trackingCount == 3 {
                self.allowsSwipe = self.allowsSwipeWithTranslation(self.trackingTranslation)
            }
            
            if self.allowsSwipe {
                self.tableView.scrollEnabled = false
                let translation = self.panGestureRecognizer.translationInView(self.swipeView)
                self.swipeViewMarginRight.constant = -translation.x
            }
        case .Cancelled:
            fallthrough
        case .Ended:
            self.trackingCount = 0
            self.allowsSwipe = false
            self.trackingTranslation = CGPointZero
            self.tableView.scrollEnabled = true
        default:
            break
        }
    }
    
    
    func allowsSwipeWithTranslation(translation: CGPoint) -> Bool {
        // スワイプの角度を計算して判断する
        let slope: CGFloat = abs(translation.y) / abs(translation.x)
        let radian: CGFloat = atan(slope)
        let angle = radian * 180 / CGFloat(M_PI)
        
        if angle >= 0 && angle <= 30 {
            
            return true
        }
        
        return false
    }
    
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
