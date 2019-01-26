//
//  ZoomInOutTransition.swift
//  MasonryStyleLayout
//
//  Created by 酒井文也 on 2019/01/26.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocol

//
protocol ZoomInOutTransitionProtocol {
    func transitionCollectionView() -> UICollectionView
}

//
protocol ZoomInOutTransitionWaterfallGridViewProtocol {
    func snapShotForTransition() -> UIView
}

class ZoomInOutTransition: NSObject {

    private let animationScale: CGFloat = 0.5
    
    // トランジションの秒数
    private let durationTime: TimeInterval = 0.28

    // トランジションの方向に関する設定
    var targetDirection: DirectionType = .push

    // トランジションの方向に関する定義
    enum DirectionType {
        case push
        case pop
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ZoomInOutTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return durationTime
    }

    // アニメーションの実装を定義する
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // コンテキストを元にViewのインスタンスを取得する
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }

        // アニメーションの実体となるContainerViewを作成する
        let container = transitionContext.containerView

        // Pushの画面遷移の場合
        if targetDirection == .push {

            guard let toView = toVC.view else {
                return
            }
            container.addSubview(toView)
            toView.isHidden = true

            let fromCollectionView = (fromVC as! ZoomInOutTransitionProtocol).transitionCollectionView()
            let indexPath = fromCollectionView.fromPageIndexPath()
            print("aaaa", indexPath)
            let gridView = fromCollectionView.cellForItem(at: indexPath)
            let leftUpperPoint = gridView!.convert(CGPoint.zero, to: toView)

            let snapShot = (gridView as! ZoomInOutTransitionWaterfallGridViewProtocol).snapShotForTransition()
            snapShot.transform = CGAffineTransform(scaleX: animationScale, y: animationScale)

            container.addSubview(snapShot)
            
            toView.isHidden = false
            toView.alpha = 0
            toView.transform = (snapShot.transform)
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.size.width, height: toView.frame.size.height)
            let whiteViewContainer = UIView(frame: UIScreen.main.bounds)
            whiteViewContainer.backgroundColor = UIColor.white
            container.addSubview(snapShot)
            container.insertSubview(whiteViewContainer, belowSubview: toView)
            
            UIView.animate(withDuration: durationTime, animations: {
                snapShot.transform = CGAffineTransform.identity
                snapShot.frame = CGRect(x: leftUpperPoint.x, y: leftUpperPoint.y, width: (snapShot.frame.size.width), height: (snapShot.frame.size.height))
                toView.transform = CGAffineTransform.identity
                toView.frame = CGRect(x: 0, y: 0, width: toView.frame.size.width, height: toView.frame.size.height)
                toView.alpha = 1
            }, completion:{finished in
                if finished {
                    snapShot.removeFromSuperview()
                    whiteViewContainer.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
            })
            
            
        // Popの画面遷移の場合
        } else if targetDirection == .pop {
            
        }
    }
}
