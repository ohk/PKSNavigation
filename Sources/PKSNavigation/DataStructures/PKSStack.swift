//
//  PKSStack.swift
//
//
//  Created by Ömer Hamid Kamışlı on 7/5/24.
//

import Foundation

struct PKSStack<T> {
    private var items: [T] = []

    var count: Int {
        return items.count
    }

    var isEmpty: Bool {
        return items.isEmpty
    }

    mutating func push(_ item: T) {
        items.append(item)
    }

    @discardableResult
    mutating func pop() -> T? {
        return items.popLast()
    }

    func peek() -> T? {
        return items.last
    }

    mutating func clear() {
        items.removeAll()
    }
}
