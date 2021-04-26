//
//  OrdersWidgetEntryViewModel.swift
//  OrdersWidgetExtension
//
//  Created by Kariny on 26/04/21.
//

import Foundation

protocol OrdersViewModelProtocol {
    var orders: [Order] { get }
}

final class OrdersViewModel: OrdersViewModelProtocol {
    private let entry: SimpleEntry

    init(entry: SimpleEntry) {
        self.entry = entry
    }

    var orders: [Order] {
        entry.orders
    }
}
