//
//  SKTextFieldContainer.swift
//  SwiftUI-Kit
//
//  Created by 최윤진 on 4/10/26.
//

import SwiftUI

final class SKTextFieldContainer: UIView {
    let uiTextField: UITextField?
    let uiTextView: SKTextView?
    
    private let axis: Axis
    private var lastIntrinsicContentSize: CGSize?
    
    init(axis: Axis) {
        self.axis = axis
        
        if axis == .horizontal {
            uiTextField = UITextField()
            uiTextView = nil
        } else {
            uiTextField = nil
            uiTextView = SKTextView()
        }
        
        super.init(frame: .zero)
        backgroundColor = .clear
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override var intrinsicContentSize: CGSize {
        if let uiTextView {
            let width = bounds.width
            let resolvedWidth = 0 < width ? width : UIScreen.main.bounds.width
            let fittingSize = uiTextView.sizeThatFits(
                CGSize(
                    width: resolvedWidth,
                    height: .greatestFiniteMagnitude
                )
            )
            
            return CGSize(
                width: UIView.noIntrinsicMetric,
                height: max(
                    ceil(fittingSize.height),
                    UIFont.preferredFont(forTextStyle: .body).lineHeight
                )
            )
        }
        
        return uiTextField?.intrinsicContentSize ?? .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let uiTextView {
            let currentSize = bounds.size
            
            if let lastIntrinsicContentSize,
               currentSize.isApproximatelyEqual(
                to: lastIntrinsicContentSize,
                epsilon: 0.5
            ) {
                return
            }

            self.lastIntrinsicContentSize = currentSize
            uiTextView.invalidateIntrinsicContentSize()
            invalidateIntrinsicContentSize()
        }
    }
    
    func invalidateTextViewIntrinsicContentSize() {
        uiTextView?.invalidateIntrinsicContentSize()
        invalidateIntrinsicContentSize()
    }
    
    private func setupLayout() {
        let subview = axis == .horizontal ? uiTextField : uiTextView
        guard let subview else { return }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor),
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    var activeResponder: UIResponder? {
        if axis == .horizontal {
            return uiTextField
        }
        
        return uiTextView
    }
}

private extension CGSize {
    func isApproximatelyEqual(
        to other: CGSize,
        epsilon: CGFloat
    ) -> Bool {
        abs(width - other.width) <= epsilon
        && abs(height - other.height) <= epsilon
    }
}
