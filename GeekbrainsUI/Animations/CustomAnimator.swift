//
//  CustomAnimator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 27/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//


import UIKit

class CustomAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var duration : TimeInterval
    var isPresenting : Bool
    var originFrame : CGRect
    var imageURL : String
    
    
    public let CustomAnimatorTag = 99
    
    init(duration : TimeInterval, isPresenting : Bool, originFrame : CGRect, imageURL : String) {
        self.duration = duration
        self.isPresenting = isPresenting
        self.originFrame = originFrame
        self.imageURL = imageURL
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        let detailView = isPresenting ? toView : fromView
        
        toView.frame = isPresenting ?  CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        toView.alpha = isPresenting ? 0 : 1
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            detailView.alpha = self.isPresenting ? 1 : 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
        guard let artwork = detailView.viewWithTag(CustomAnimatorTag) as? UIImageView else { return }
        
        guard let url = URL(string: imageURL ) else {return}
        
        artwork.kf.setImage(with: url)
        artwork.alpha = 0
        
        
        let transitionImageView = UIImageView(frame: isPresenting ? originFrame : artwork.frame)
        transitionImageView.kf.setImage(with: url)
        
        container.addSubview(transitionImageView)
        
        UIView.animate(withDuration: duration, animations: {
            transitionImageView.frame = self.isPresenting ? artwork.frame : self.originFrame
            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            detailView.alpha = self.isPresenting ? 1 : 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionImageView.removeFromSuperview()
            artwork.alpha = 1
        })
        
        
    }// func animateTransition
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }//func transitionDuration
    
}//class CustomAnimator

