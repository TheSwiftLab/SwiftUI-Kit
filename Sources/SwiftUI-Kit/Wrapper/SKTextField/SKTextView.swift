//
//  SKTextView.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/20/26.
//

import UIKit

final class SKTextView: UITextView {
    var onHardwareSubmit: (() -> Void)?

    // 하드웨어 키보드의 엔터키 입력을 먼저 감지해 onbSubmit 처리 여부를 판단한다.
    override func pressesBegan(
        _ uiPresses: Set<UIPress>,
        with uiPressesEvent: UIPressesEvent?
    ) {
        if handleHardwareSubmitIfNeeded(for: uiPresses) {
            return
        }

        super.pressesBegan(
            uiPresses,
            with: uiPressesEvent
        )
    }

    // onSubmit 동작을 실행한 뒤 포커스를 해제한다.
    func triggerHardwareSubmit() {
        onHardwareSubmit?()
        resignFirstResponder()
    }

    // 전달된 키 입력이 onSubmit로 처리되어야 하는 경우 즉시 동작을 수행한다.
    private func handleHardwareSubmitIfNeeded(
        for uiPresses: Set<UIPress>
    ) -> Bool {
        guard onHardwareSubmit != nil else {
            return false
        }

        guard uiPresses.contains(
            where: isUnmodifiedReturnKeyPress
        ) else {
            return false
        }

        triggerHardwareSubmit()
        return true
    }

    // 수정 키 없이 눌린 Return 키인지 판별한다.
    private func isUnmodifiedReturnKeyPress(
        _ uiPress: UIPress
    ) -> Bool {
        guard let uiKey = uiPress.key else {
            return false
        }

        let submitModifierFlags: UIKeyModifierFlags = [
            .alternate,
            .command,
            .control,
            .shift
        ]

        guard uiKey.modifierFlags
            .intersection(submitModifierFlags)
            .isEmpty else { return false }

        let ignoringModifiers = uiKey.charactersIgnoringModifiers
        return
            ignoringModifiers == "\r" ||
            ignoringModifiers == "\n"
    }
}
