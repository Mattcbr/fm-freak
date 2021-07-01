//
//  BasePresenter.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class BasePresenter<T: BaseView> {
    private(set) public var baseView: T?
    
    /**
     This binds the view and the presenter
     */
    open func attachView (_ view: BaseView) {
        baseView = view as? T
    }
    
    /**
     This un-binds the view and the presenter
     */
    open func detachView() {
        baseView = nil
    }
}
