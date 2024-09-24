//
//  SearchTransitionAnimator.swift
//  kidsnote_pre_project
//
//  Created by 방용식on 9/24/24.
//

import UIKit

class SearchTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration: TimeInterval = 0.4
    var isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }

            containerView.addSubview(toView)
            toView.frame = CGRect(x: 0, y: 44, width: containerView.frame.width, height: 0)
            toView.alpha = 0.0

            UIView.animate(withDuration: duration, animations: {
                toView.frame = containerView.frame
                toView.alpha = 1.0
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }

            UIView.animate(withDuration: duration, animations: {
                fromView.frame = CGRect(x: 0, y: 44, width: containerView.frame.width, height: 0)
                fromView.alpha = 0.0
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
}
