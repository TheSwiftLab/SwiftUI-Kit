//
//  SampleSKTextFieldSubmitLabelTabView.swift
//  SwiftUI-Kit
//
//  Created by opfic on 4/28/26.
//

import SwiftUI
import SwiftUI_Kit

struct SampleSKTextFieldSubmitLabelTabView: View {
    @State private var texts = [SampleSKTextFieldSubmitLabelItem.ID: String]()

    private let items = SampleSKTextFieldSubmitLabelItem.allCases

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(items) { item in
                        SampleSKTextFieldSubmitLabelRow(
                            item: item,
                            text: binding(for: item)
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("submitLabel")
        }
    }

    private func binding(
        for item: SampleSKTextFieldSubmitLabelItem
    ) -> Binding<String> {
        Binding(
            get: {
                texts[item.id, default: ""]
            },
            set: { newValue in
                texts[item.id] = newValue
            }
        )
    }
}

private struct SampleSKTextFieldSubmitLabelRow: View {
    let item: SampleSKTextFieldSubmitLabelItem
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(.headline)
            Text(item.code)
                .font(.caption)
                .foregroundStyle(.secondary)
            SKTextField(
                item.placeholder,
                text: $text
            )
            .submitLabel(item.submitLabel)
            Text("입력 값: \(text.isEmpty ? "비어 있음" : text)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private enum SampleSKTextFieldSubmitLabelItem: String, CaseIterable, Identifiable {
    case `continue`
    case done
    case go
    case join
    case next
    case `return`
    case route
    case search
    case send

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .continue:
            return "Continue"
        case .done:
            return "Done"
        case .go:
            return "Go"
        case .join:
            return "Join"
        case .next:
            return "Next"
        case .return:
            return "Return"
        case .route:
            return "Route"
        case .search:
            return "Search"
        case .send:
            return "Send"
        }
    }

    var code: String {
        ".submitLabel(.\(rawValue))"
    }

    var placeholder: String {
        "\(title) label"
    }

    var submitLabel: SubmitLabel {
        switch self {
        case .continue:
            return .continue
        case .done:
            return .done
        case .go:
            return .go
        case .join:
            return .join
        case .next:
            return .next
        case .return:
            return .return
        case .route:
            return .route
        case .search:
            return .search
        case .send:
            return .send
        }
    }
}
