//
//  DataWrapper.swift
//  NetworkHandler
//
//  Created by Pavnish Kumar Rana on 05/07/22.
//

import Foundation

struct DataWrapper<DataType: Codable>: Codable {
    var data: DataType
}
