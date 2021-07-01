//
//  BaseView.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

public protocol BaseView {
    /**
     This function should be called every time the view has an error to handle
     */
    func showError(_ error: Error?)
}
