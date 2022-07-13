//
//  ApiRequest.swift
//  NetworkHandler
//
//  Created by Pavnish Kumar Rana on 05/07/22.
//

import Foundation
import Alamofire

extension URLRequest {
    enum Headers {
        case standard
        case image
        case video
        case none
    }

    init(url: URL, method: HTTPMethod, useHeaders headers: Headers = .standard) {
        self.init(url: url)
        httpMethod = method.rawValue
        switch headers {
        case .standard:
            addValue("application/json", forHTTPHeaderField: "Content-Type")
            addValue("application/json", forHTTPHeaderField: "Accept")
        case .image:
            addValue("image/png", forHTTPHeaderField: "Content-Type")
            addValue("application/json", forHTTPHeaderField: "Accept")
            timeoutInterval = 1200
        case .video:
            addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            addValue("application/json", forHTTPHeaderField: "Accept")
            timeoutInterval = 1200
        case .none: break
        }
    }
}

class ApiRequest {

  var method: HTTPMethod
  var url: URL
  var header: [String: String]
  var param: Parameters?
  var encoding: ParameterEncoding

  required internal init(url: URL,
                         method: HTTPMethod,
                         header: [String: String]? = nil,
                         param: [String: Any]? = nil,
                         encoding: ParameterEncoding = URLEncoding.default) {
    self.url = url
    self.method = method

      self.header = header ?? ["Content-Type":"application/json"]
   // additional headers
   // self.header["Content-Type"] = "application/x-www-form-urlencoded"

    self.param = param
    self.encoding = encoding
  }

    static func createRequest(url: URL,
                            method: HTTPMethod = .get,
                            header: [String: String]? = nil,
                            paramModel: Encodable? = nil,
                            encoding: ParameterEncoding = JSONEncoding.default)
    -> ApiRequest {
      return ApiRequest(url: url, method: method, header: header,
                        param: paramModel?.dic, encoding: encoding)
  }
}


extension Encodable {
    var dic: [String: Any]? {
        if let data = try? JSONEncoder().encode(self) {
            let dic = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dic
        }
        return nil
    }
}
