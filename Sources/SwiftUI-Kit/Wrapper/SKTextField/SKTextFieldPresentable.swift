//
//  SKTextFieldPresentable.swift
//  SwiftUI-Kit
//
//  Created by 최윤진 on 4/10/26.
//

import SwiftUI

struct SKTextFieldPresentable: UIViewRepresentable {
    @Binding var text: String
    let axis: Axis
    let placeholder: String
    let accessibilityLabel: String?
    let focusBinding: Binding<Bool>?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> SKTextFieldContainer {
        let container = SKTextFieldContainer(axis: axis)

        if let uiTextField = container.uiTextField {
            uiTextField.delegate = context.coordinator
            uiTextField.addTarget(
                context.coordinator,
                action: #selector(Coordinator.textFieldDidChange(_:)),
                for: .editingChanged
            )
            uiTextField.font = UIFont.preferredFont(forTextStyle: .body)
            uiTextField.backgroundColor = .clear
            uiTextField.textColor = .label
            uiTextField.tintColor = .tintColor
            uiTextField.borderStyle = .none
            uiTextField.autocorrectionType = .no
            uiTextField.setContentCompressionResistancePriority(
                .defaultLow,
                for: .horizontal
            )
            uiTextField.setContentHuggingPriority(
                .defaultLow,
                for: .horizontal
            )
        }

        if let uiTextView = container.uiTextView {
            uiTextView.delegate = context.coordinator
            uiTextView.font = UIFont.preferredFont(forTextStyle: .body)
            uiTextView.backgroundColor = .clear
            uiTextView.textColor = .label
            uiTextView.tintColor = .tintColor
            uiTextView.textContainer.lineFragmentPadding = 0
            uiTextView.textContainer.widthTracksTextView = true
            uiTextView.textContainer.lineBreakMode = .byWordWrapping
            uiTextView.textContainerInset = .zero
            uiTextView.isScrollEnabled = false
            uiTextView.autocorrectionType = .no
            uiTextView.setContentCompressionResistancePriority(
                .defaultLow,
                for: .horizontal
            )
            uiTextView.setContentHuggingPriority(
                .defaultLow,
                for: .horizontal
            )
        }

        context.coordinator.applyConfiguration(to: container)
        context.coordinator.applyText(to: container)

        return container
    }

    func updateUIView(
        _ uiView: SKTextFieldContainer,
        context: Context
    ) {
        context.coordinator.parent = self
        context.coordinator.applyConfiguration(to: uiView)
        context.coordinator.applyText(to: uiView)

        DispatchQueue.main.async {
            context.coordinator.syncFocus(in: uiView)

            if let uiTextView = uiView.uiTextView {
                uiTextView.invalidateIntrinsicContentSize()
                uiView.invalidateTextViewIntrinsicContentSize()
            }
        }
    }
}

extension SKTextFieldPresentable {

    final class Coordinator: NSObject, UITextFieldDelegate, UITextViewDelegate {
        var parent: SKTextFieldPresentable

        private weak var scrollView: UIScrollView?
        private var offsetObservation: NSKeyValueObservation?
        private var trackedOffset: CGPoint?
        private var isRestoringOffset = false
        private var isShowingPlaceholder = false

        init(_ parent: SKTextFieldPresentable) {
            self.parent = parent
        }

        @objc
        func textFieldDidChange(_ uiTextField: UITextField) {
            parent.text = uiTextField.text ?? ""
        }

        func textFieldDidBeginEditing(_ uiTextField: UITextField) {
            if let focusBinding = parent.focusBinding, !focusBinding.wrappedValue {
                focusBinding.wrappedValue = true
            }
        }

        func textFieldDidEndEditing(_ uiTextField: UITextField) {
            if let focusBinding = parent.focusBinding, focusBinding.wrappedValue {
                focusBinding.wrappedValue = false
            }
        }

        func textViewShouldBeginEditing(_ uiTextView: UITextView) -> Bool {
            startTrackingOffset(for: uiTextView)
            return true
        }

        func textViewDidBeginEditing(_ uiTextView: UITextView) {
            if isShowingPlaceholder {
                uiTextView.text = nil
                uiTextView.textColor = .label
                isShowingPlaceholder = false
            }

            if let focusBinding = parent.focusBinding, !focusBinding.wrappedValue {
                focusBinding.wrappedValue = true
            }

            restoreOffsetIfNeeded()

            DispatchQueue.main.async { [weak self] in
                self?.restoreOffsetIfNeeded()
                uiTextView.invalidateIntrinsicContentSize()
                uiTextView.superview?.invalidateIntrinsicContentSize()
            }
        }

        func textViewDidChange(_ uiTextView: UITextView) {
            stopTrackingOffset()
            parent.text = uiTextView.text
            isShowingPlaceholder = false
            uiTextView.invalidateIntrinsicContentSize()
            uiTextView.superview?.invalidateIntrinsicContentSize()
        }

        func textViewDidEndEditing(_ uiTextView: UITextView) {
            if let focusBinding = parent.focusBinding, focusBinding.wrappedValue {
                focusBinding.wrappedValue = false
            }

            stopTrackingOffset()
            applyPlaceholderIfNeeded(to: uiTextView)
            uiTextView.invalidateIntrinsicContentSize()
            uiTextView.superview?.invalidateIntrinsicContentSize()
        }

        func applyConfiguration(to container: SKTextFieldContainer) {
            container.uiTextField?.accessibilityLabel = parent.accessibilityLabel
            container.uiTextView?.accessibilityLabel = parent.accessibilityLabel

            if let uiTextField = container.uiTextField {
                applyPlaceholder(to: uiTextField)
            }

            if let uiTextView = container.uiTextView {
                applyPlaceholderIfNeeded(to: uiTextView)
            }
        }

        func applyText(to container: SKTextFieldContainer) {
            if let uiTextField = container.uiTextField,
               uiTextField.text != parent.text {
                uiTextField.text = parent.text
            }

            if let uiTextView = container.uiTextView {
                if !isShowingPlaceholder && uiTextView.text != parent.text {
                    uiTextView.text = parent.text
                    isShowingPlaceholder = false
                }

                applyPlaceholderIfNeeded(to: uiTextView)
            }
        }

        func applyPlaceholder(to uiTextField: UITextField) {
            guard !parent.placeholder.isEmpty else {
                uiTextField.attributedPlaceholder = nil
                return
            }

            uiTextField.attributedPlaceholder = NSAttributedString(
                string: parent.placeholder,
                attributes: [
                    .foregroundColor: UIColor.placeholderText
                ]
            )
        }

        func applyPlaceholderIfNeeded(to uiTextView: UITextView) {
            if parent.text.isEmpty && !uiTextView.isFirstResponder && !parent.placeholder.isEmpty {
                uiTextView.text = parent.placeholder
                uiTextView.textColor = .placeholderText
                isShowingPlaceholder = true
            } else if isShowingPlaceholder {
                uiTextView.text = parent.text
                uiTextView.textColor = .label
                isShowingPlaceholder = false
            }
        }

        func syncFocus(in container: SKTextFieldContainer) {
            guard let focusBinding = parent.focusBinding else { return }
            guard let activeResponder = container.activeResponder else { return }

            if focusBinding.wrappedValue {
                if !activeResponder.isFirstResponder {
                    if let uiTextView = activeResponder as? UITextView {
                        startTrackingOffset(for: uiTextView)
                    }

                    activeResponder.becomeFirstResponder()
                }
            } else if activeResponder.isFirstResponder {
                activeResponder.resignFirstResponder()
            }
        }

        func startTrackingOffset(for uiTextView: UITextView) {
            stopObservingOffset()
            scrollView = uiTextView.enclosingScrollView
            trackedOffset = scrollView?.contentOffset
            observeOffsetIfNeeded()
        }

        func restoreOffsetIfNeeded() {
            guard let scrollView, let trackedOffset else { return }

            if scrollView.contentOffset != trackedOffset {
                isRestoringOffset = true
                scrollView.setContentOffset(trackedOffset, animated: false)
                isRestoringOffset = false
            }
        }

        func observeOffsetIfNeeded() {
            guard let scrollView else { return }

            offsetObservation = scrollView.observe(
                \.contentOffset,
                 options: [.new]
            ) { [weak self] scrollView, _ in
                DispatchQueue.main.async {
                    self?.handleOffsetChange(in: scrollView)
                }
            }
        }

        func handleOffsetChange(in scrollView: UIScrollView) {
            guard let trackedOffset else {
                stopObservingOffset()
                return
            }

            if scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating {
                stopTrackingOffset()
                return
            }

            if isRestoringOffset {
                return
            }

            if scrollView.contentOffset != trackedOffset {
                restoreOffsetIfNeeded()
            }
        }

        func stopObservingOffset() {
            offsetObservation?.invalidate()
            offsetObservation = nil
        }

        func stopTrackingOffset() {
            stopObservingOffset()
            scrollView = nil
            trackedOffset = nil
        }
    }
}

private extension UIView {
    var enclosingScrollView: UIScrollView? {
        var currentSuperview = superview
        
        while let view = currentSuperview {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
            
            currentSuperview = view.superview
        }
        
        return nil
    }
}
