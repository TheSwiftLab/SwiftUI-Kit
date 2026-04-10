//
//  SampleSKTextFieldComponents.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/10/26.
//

import SwiftUI
import SwiftUI_Kit

struct SampleSKTextFieldBoolFocusSection: View {
    @Binding var horizontalText: String
    @Binding var verticalText: String
    
    let sectionTitle: String
    let horizontalTitle: String
    let verticalTitle: String
    let horizontalFocus: FocusState<Bool>.Binding
    let verticalFocus: FocusState<Bool>.Binding
    let constructor: (Binding<String>, Axis) -> SKTextField<Text>
    
    var body: some View {
        Section(sectionTitle) {
            SampleSKTextFieldBlock(
                text: $horizontalText,
                title: horizontalTitle,
                axisDescription: "axis: .horizontal / 한 줄 입력",
                field: {
                    constructor($horizontalText, .horizontal)
                        .focused(horizontalFocus)
                }
            )
            
            SampleSKTextFieldBlock(
                text: $verticalText,
                title: verticalTitle,
                axisDescription: "axis: .vertical / 여러 줄 입력",
                field: {
                    constructor($verticalText, .vertical)
                        .focused(verticalFocus)
                }
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("한 줄 입력 포커스 상태: \(horizontalFocus.wrappedValue ? "활성" : "비활성")")
                Text("여러 줄 입력 포커스 상태: \(verticalFocus.wrappedValue ? "활성" : "비활성")")
            }
            
            SampleSKTextFieldActionButtonRow(
                primaryTitle: "한 줄 입력 포커스",
                primaryAction: {
                    horizontalFocus.wrappedValue = true
                },
                secondaryTitle: "여러 줄 입력 포커스",
                secondaryAction: {
                    verticalFocus.wrappedValue = true
                }
            )
            
            Button("포커스 해제") {
                horizontalFocus.wrappedValue = false
                verticalFocus.wrappedValue = false
            }
        }
    }
}

struct SampleSKTextFieldEqualsFocusSection: View {
    @Binding var horizontalText: String
    @Binding var verticalText: String
    
    let sectionTitle: String
    let horizontalTitle: String
    let verticalTitle: String
    let focus: FocusState<SampleSKTextFieldFocusField?>.Binding
    let constructor: (Binding<String>, Axis) -> SKTextField<Text>
    
    var body: some View {
        Section(sectionTitle) {
            SampleSKTextFieldBlock(
                text: $horizontalText,
                title: horizontalTitle,
                axisDescription: "axis: .horizontal / equals: .singleLine",
                field: {
                    constructor($horizontalText, .horizontal)
                        .focused(focus, equals: .singleLine)
                }
            )
            
            SampleSKTextFieldBlock(
                text: $verticalText,
                title: verticalTitle,
                axisDescription: "axis: .vertical / equals: .multiLine",
                field: {
                    constructor($verticalText, .vertical)
                        .focused(focus, equals: .multiLine)
                }
            )
            
            Text("현재 포커스 값: \(focusLabel)")
            
            SampleSKTextFieldActionButtonRow(
                primaryTitle: "한 줄 입력 포커스",
                primaryAction: {
                    focus.wrappedValue = .singleLine
                },
                secondaryTitle: "여러 줄 입력 포커스",
                secondaryAction: {
                    focus.wrappedValue = .multiLine
                }
            )
            
            Button("포커스 해제") {
                focus.wrappedValue = nil
            }
        }
    }
    
    private var focusLabel: String {
        switch focus.wrappedValue {
        case .singleLine:
            return ".singleLine"
        case .multiLine:
            return ".multiLine"
        case nil:
            return "nil"
        }
    }
}

private struct SampleSKTextFieldBlock<Field: View>: View {
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

private struct SampleSKTextFieldActionButtonRow: View {
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
