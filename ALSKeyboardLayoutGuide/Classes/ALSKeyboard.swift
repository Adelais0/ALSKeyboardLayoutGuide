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
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        userInfo = UserInfo(notification)
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        userInfo = UserInfo(notification)
    }

    @objc private func keyboardDidHide(_ notification: Notification) {
        userInfo = nil
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

