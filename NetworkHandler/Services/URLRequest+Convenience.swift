//
//  URLRequest+Convenience.swift
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
    
    init<T: Encodable>(url: URL, method: HttpMethod, useHeaders headers: Headers = .standard, params: T) {
        self.init(url: url)
        httpMethod = method.rawValue
        try! httpBody = JSONEncoder().encode(params)
        switch headers {
        case .standard:
            addValue("application/json", forHTTPHeaderField: "Content-Type")
            addValue("application/json", forHTTPHeaderField: "Accept")
        case .image:
            addValue("image/png", forHTTPHeaderField: "Content-Type")
            addValue("application/json", forHTTPHeaderField: "Accept")
            timeoutInterval = 1200
        case .video:
            addValue("application/json", forHTTPHeaderField: "Content-Type")
            addValue("application/json", forHTTPHeaderField: "Accept")
            timeoutInterval = 1200
        case .none: break
        }
    }
}

class ApiRequest<T, P> {
  
  var method: HTTPMethod
  var url: String
  var header: HTTPHeaders
  var param: Parameters?
  var encoding: ParameterEncoding
  
  required internal init(url: String,
                         method: HTTPMethod = .get,
                         header: [String: String]? = nil,
                         param: [String: Any]? = nil,
                         encoding: ParameterEncoding = URLEncoding.default) {
    self.url = url
    self.method = method
    
    self.header = header ?? [:]
    //additional headers
    //self.header["Content-Type"] = "application/json"
    //self.header["Content-Type"] = "application/x-www-form-urlencoded"

    self.param = param
    self.encoding = encoding
  }
  
    static func signedRequest<H, P:Encodable>(url: String,
                            method: HTTPMethod = .get,
                            header: H? = nil,
                            paramModel: P? = nil,
                            encoding: ParameterEncoding = JSONEncoding.default)
    -> ApiRequest {
      var header = header
      if header == nil {
        header = [:]
        header?["Content-Type"] = "application/json"
      }
      header?["Authorization"] = "Bearer \(UserPreferences.get()?.sessionToken ?? "")"
      header?["os"] = "ios"
      header?["locale"] = "\(Utility.selectedLanguage)"
      return ApiRequest(url: url, method: method, header: header,
                        param: paramModel?.dic, encoding: encoding)
  }
  
  static func unsignedRequest<>(url: String,
                              method: HTTPMethod = .get,
                              header: [String: String]? = nil,
                              paramModel: Encodable? = nil,
                              encoding: ParameterEncoding = JSONEncoding.default)
    -> ApiRequest {
    
      var header = header
      if header == nil {
       header = [:]
       header?["Content-Type"] = "application/json"
      }
      return ApiRequest(url: url, method: method, header: header,
                        param: paramModel?.dic, encoding: encoding)
  }
}


