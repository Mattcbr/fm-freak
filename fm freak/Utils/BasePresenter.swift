//
//  BasePresenter.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class BasePresenter<T: BaseView> {
    private(set) public var baseView: T?
    
    open func attachView (_ view: BaseView) {
        baseView = view as? T
    }
    
    open func detachView() {
        baseView = nil
    }
}
