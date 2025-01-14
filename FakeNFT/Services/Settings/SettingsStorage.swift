//
//  SettingsStorage.swift
//  FakeNFT
//
//  Created by MacBook on 12.06.2023.
//

import Foundation

protocol SettingsStorageProtocol {
    func saveSorting(_ descriptor: SortDescriptor)
    func fetchSorting() -> SortDescriptor?
}

final class SettingsStorage: SettingsStorageProtocol {

    // MARK: - Properties
    private let storage = UserDefaults.standard
    private let sortingKey = "sortingKey"

    // MARK: - Methods
    func saveSorting(_ descriptor: SortDescriptor) {
        storage.set(descriptor.rawValue, forKey: sortingKey)
        print("save = \(descriptor.rawValue)")
    }

    func fetchSorting() -> SortDescriptor? {
        if let sortDescriptorRawValue = storage.object(forKey: sortingKey) as? String {
            if let sortDescriptor = SortDescriptor(rawValue: sortDescriptorRawValue) {
                print("read = \(sortDescriptor.rawValue)")
                return sortDescriptor
            }
        }
        return nil
    }
}
