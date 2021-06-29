//
//  TopChartPresenter.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class TopChartPresenter<T: TopChartView>: BasePresenter<T> {
    
    private let networkManager = NetworkManager.sharedInstance
    
    func requestAlbuns() {
        networkManager.makeHipHopRequest { [weak self] result in
            switch result {
            case .success(let albunsArray):
                if let albunsOnly = albunsArray.albums?.album {
                    self?.baseView?.addNewAlbunsToArray(newAlbuns: albunsOnly)
                }
            case .failure(let error):
                self?.baseView?.showError(error)
            }
        }
    }
    
}
