//
//  SKTextFieldLocalizedStorage.swift
//  SwiftUI-Kit
//
//  Created by 최윤진 on 4/10/26.
//

import SwiftUI

private struct SKTextFieldLocalizedStorage {
    let key: String
    let tableName: String?
    let bundle: Bundle?
}

extension Text {
    var skResolvedString: String? {
        guard let storage = localizedStorage else {
            return nil
        }
        
        let bundle = storage.bundle ?? .main

        return bundle.localizedString(
            forKey: storage.key,
            value: storage.key,
            table: storage.tableName
        )
    }
    
    private var localizedStorage: SKTextFieldLocalizedStorage? {
        let mirror = Mirror(reflecting: self)
        guard let storage = mirror.children.first(where: { $0.label == "storage" })?.value else {
            return nil
        }
        
        let storageMirror = Mirror(reflecting: storage)
        guard let anyTextStorage = storageMirror.children.first?.value else {
            return nil
        }
        
        let anyTextStorageMirror = Mirror(reflecting: anyTextStorage)
        guard let localizedStringKey = anyTextStorageMirror.children.first(
            where: { $0.label == "key" }
        )?.value as? LocalizedStringKey else {
            return nil
        }
        
        guard let key = localizedStringKey.skKey else {
            return nil
        }
        
        let tableName = anyTextStorageMirror.children.first(
            where: { $0.label == "table" }
        )?.value as? String
        let bundle = anyTextStorageMirror.children.first(
            where: { $0.label == "bundle" }
        )?.value as? Bundle
        
        return SKTextFieldLocalizedStorage(
            key: key,
            tableName: tableName,
            bundle: bundle
        )
    }
}

extension LocalizedStringKey {
    var skKey: String? {
        Mirror(reflecting: self).children.first(
            where: { $0.label == "key" }
        )?.value as? String
    }
    
    var skResolvedString: String? {
        guard let skKey else { return nil }
        
        return Bundle.main.localizedString(
            forKey: skKey,
            value: skKey,
            table: nil
        )
    }
}
