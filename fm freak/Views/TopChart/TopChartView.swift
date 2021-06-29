//
//  TopChartView.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import UIKit

protocol TopChartView: BaseView {
    func addNewAlbunsToArray(newAlbuns: [Album])
    func addNewImagesToDictionary(newImages: [String: UIImage])
}
