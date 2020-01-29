//
//  UIView+KeyboardLayoutGuide.swift
//  ALSKeyboardLayoutGuide
//
//  Created by 李凌峰 on 2020/1/29.
//

import UIKit

extension UIView {

    private enum AssociatedKeys {
        static var keyboardLayoutGuide = 0 as UInt8
        static var observation = 0 as UInt8
    }

    private var observation: NSKeyValueObservation? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.observation) as? NSKeyValueObservation
        }

        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.observation,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    open var keyboardLayoutGuide: UILayoutGuide {
        if let layoutGuide = objc_getAssociatedObject(self, &AssociatedKeys.keyboardLayoutGuide) as? UILayoutGuide {
            return layoutGuide
        } else {
            let layoutGuide = UILayoutGuide()
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.keyboardLayoutGuide,
                                     layoutGuide,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            addLayoutGuide(layoutGuide)
            layoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            layoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            layoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            let heightConstraint = layoutGuide.heightAnchor.constraint(equalToConstant: 0.0)
            heightConstraint.isActive = true

            observation = ALSKeyboard.shared.observe(\.userInfo, options: [.initial, .new]) { [weak self] (_, change) in
                guard let userInfo = change.newValue else {
                    return
                }

                let constant: CGFloat
                if let keyboardFrame = userInfo?.endFrame {
                    let screenBounds = UIApplication.shared.keyWindow?.bounds ?? UIScreen.main.bounds
                    constant = max(0.0, screenBounds.height - keyboardFrame.minY)
                } else {
                    constant = 0.0
                }

                guard heightConstraint.constant != constant else {
                    return
                }

                heightConstraint.constant = constant

                if let animationDuration = userInfo?.animationDuration,
                    let animationCurve = userInfo?.animationCurve,
                    UIApplication.shared.applicationState == .active {
                    let options = UIView.AnimationOptions(rawValue: animationCurve)
                    UIView.animate(withDuration: animationDuration, delay: 0.0, options: options, animations: {
                        self?.layoutIfNeeded()
                    }, completion: nil)
                } else {
                    self?.layoutIfNeeded()
                }
            }

            return layoutGuide
        }
    }

}
