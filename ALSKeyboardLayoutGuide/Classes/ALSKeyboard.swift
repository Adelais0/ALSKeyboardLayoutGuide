//
//  ALSKeyboard.swift
//  ALSKeyboardLayoutGuide
//
//  Created by 李凌峰 on 2020/1/29.
//

import UIKit

open class ALSKeyboard: NSObject {

    public static let shared = ALSKeyboard()

    @objc dynamic open var userInfo: UserInfo? = nil

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged(_:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
    }

    @objc private func keyboardChanged(_ notification: Notification) {
        let userInfo = UserInfo(notification)
        let size = userInfo.endFrame?.size ?? .zero
        guard size != .zero else {
            return
        }
        self.userInfo = userInfo
    }

}

// MARK: - UserInfo

extension ALSKeyboard {

    open class UserInfo: NSObject {
        let beginFrame: CGRect?
        let endFrame: CGRect?
        let animationDuration: TimeInterval?
        let animationCurve: UInt?
        let isLocal: Bool?

        public init(_ notification: Notification) {
            let userInfo = notification.userInfo
            beginFrame = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            endFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            animationCurve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            isLocal = userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? Bool
        }
    }

}

// MARK: - Alternative to +load or +intialize
// Reference: http://jordansmith.io/handling-the-deprecation-of-initialize/

extension UIApplication {

    private static let runOnce: Void = {
        // Trigger lazy initialization.
        let _ = ALSKeyboard.shared
    }()

    open override var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }

}

