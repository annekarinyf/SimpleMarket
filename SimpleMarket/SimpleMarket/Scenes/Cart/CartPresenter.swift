//
//  CartPresenter.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol CartPresenterProtocol {
    var title: String { get }
    var numberOfRows: Int { get }
    func getOrderItem(for index: Int) -> OrderItem?
    func sumOrderItemQuantity(_ orderItem: OrderItem?, at index: Int)
    func reduceOrderItemQuantity(_ orderItem: OrderItem?, at index: Int)
    func didTapDone()
    func finishOrder()
    func updateCart()
}

class CartPresenter {
    private weak var coordinator: CartCoordinatorProtocol?
    weak var view: CartViewProtocol?

    private let logger = Logger()
    private let cartManager: CartManagerProtocol
    private var orderItems = [OrderItem]()

    init(
        coordinator: CartCoordinatorProtocol? = nil,
        cartManager: CartManagerProtocol = CartManager()
    ) {
        self.coordinator = coordinator
        self.cartManager = cartManager
    }

    deinit {
        logger.info("CartPresenter deinitialized")
    }
}

// MARK: - CartPresenterProtocol
extension CartPresenter: CartPresenterProtocol {
    var title: String {
        Strings.cart
    }

    var numberOfRows: Int {
        orderItems.count
    }

    var totalCart: String {
        let cart = cartManager.getCart()
        let value = cart?.total ?? 0
        return "\(Strings.total): \(value.toCurrencyFormat())"
    }

    func getOrderItem(for index: Int) -> OrderItem? {
        guard orderItems.indices.contains(index) else {
            return nil
        }
        return orderItems[index]
    }

    func sumOrderItemQuantity(_ orderItem: OrderItem?, at index: Int) {
        guard let orderItem = orderItem else {
            return
        }
        cartManager.sumQuantity(from: orderItem)
        updateCart()
    }

    func reduceOrderItemQuantity(_ orderItem: OrderItem?, at index: Int) {
        guard let orderItem = orderItem else {
            return
        }
        cartManager.reduceQuantity(from: orderItem)
        view?.reloadTableView()
        updateCart()
    }

    func updateCart() {
        orderItems = cartManager.getOrderItems()
        view?.updateTotalCart(total: totalCart)
        view?.reloadTableView()
    }

    func didTapDone() {
        cartManager.saveCart()
        coordinator?.finish()
    }

    func finishOrder() {
        cartManager.finishOrder()
        coordinator?.showFinishOrderAlert()
    }
}
