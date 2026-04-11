//
//  SampleSKTextFieldComponents.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/10/26.
//

import SwiftUI
import SwiftUI_Kit

struct SampleSKTextFieldBlock<Field: View>: View {
    @Binding var text: String
    
    let title: String
    let axisDescription: String
    @ViewBuilder let field: () -> Field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(axisDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
            field()
            Text("입력 값: \(text.isEmpty ? "비어 있음" : text)")
                .font(.caption)
                .foregroundStyle(.secondary)
            SampleSKTextFieldActionButtonRow(
                primaryTitle: "예시 입력",
                primaryAction: {
                    text = "\(title) 예시"
                },
                secondaryTitle: "지우기",
                secondaryAction: {
                    text = ""
                }
            )
        }
    }
}

struct SampleSKTextFieldActionButtonRow: View {
    let primaryTitle: String
    let primaryAction: () -> Void
    let secondaryTitle: String
    let secondaryAction: () -> Void
    
    var body: some View {
        HStack {
            Button(primaryTitle, action: primaryAction)
            Button(secondaryTitle, action: secondaryAction)
        }
        .buttonStyle(.bordered)
    }
}

enum SampleSKTextFieldFocusField: Hashable {
    case singleLine
    case multiLine
}
