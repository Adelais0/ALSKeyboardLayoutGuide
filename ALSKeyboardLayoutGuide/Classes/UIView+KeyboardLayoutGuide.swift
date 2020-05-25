//
//  UIView+KeyboardLayoutGuide.swift
//  ALSKeyboardLayoutGuide
//
//  Created by 李凌峰 on 2020/1/29.
//

import UIKit

private extension ALSKeyboard.UserInfo {

    var overlayHeight: CGFloat {
        guard let endFrame = self.endFrame else {
            return 0.0
        }
        let offset: CGFloat = {
            if #available(iOS 13.0, *) {
                return 0.0
            } else {
                // iOS 12 + Slide Over情况下，键盘会少40pt，猜测是系统自动减去Slide Over的上下间距
                return 40.0
            }
        }()
        let screenHeight = UIScreen.main.bounds.height
        let overlayHeight: CGFloat
        if endFrame.maxY < screenHeight - offset { // iPad Keyboard：Undock, Split, Floating
            overlayHeight = 0.0
        } else {
            overlayHeight = max(screenHeight - endFrame.minY, 0.0)
        }
        return overlayHeight
    }

}

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
                guard let self = self, let userInfo = change.newValue else {
                    return
                }

                let constant = self.convertedOverlayedHeight(by: userInfo)
                guard heightConstraint.constant != constant else {
                    return
                }

                heightConstraint.constant = constant
                if let animationDuration = userInfo?.animationDuration,
                    let animationCurve = userInfo?.animationCurve,
                    UIApplication.shared.applicationState == .active {
                    let options = UIView.AnimationOptions(rawValue: animationCurve)
                    UIView.animate(withDuration: animationDuration, delay: 0.0, options: options, animations: {
                        self.layoutIfNeeded()
                    }, completion: nil)
                } else {
                    self.layoutIfNeeded()
                }
            }

            return layoutGuide
        }
    }

    func convertedOverlayedHeight(by userInfo: ALSKeyboard.UserInfo?) -> CGFloat {
        let screen = UIScreen.main
        let convertedRect = self.convert(self.bounds, to: screen.coordinateSpace)
        let overlayHeight: CGFloat?
        if convertedRect.minY < 0 { // when the view hasn't been displayed
            overlayHeight = userInfo?.overlayHeight
        } else {
            overlayHeight = (userInfo?.overlayHeight).map {
                max(0.0, $0 - max(screen.bounds.height - convertedRect.maxY, 0.0))
            }
        }
        return overlayHeight ?? 0.0
    }

}
