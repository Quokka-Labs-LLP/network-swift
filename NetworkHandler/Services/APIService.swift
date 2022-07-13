//
//  APIService.swift
//  NetworkHandler
//
//  Created by Pavnish Kumar Rana on 05/07/22.
//

import Foundation

enum StandardServiceErrors: Error {
  case noResponseData
  case badStatusCode(Int)
  case requestCancelled
  case imageDataError
}

extension StandardServiceErrors: LocalizedError {
  var errorDescription: String? {
    switch self {
      case .badStatusCode(let code):
        return "Server response containted status code \(code)."
      case .imageDataError:
        return "Image data error."
      case .noResponseData:
        return "Server response pay load error."
      case .requestCancelled:
        return "Request was cancelled early."
    }
  }
}

protocol APIService {
  static func performRequest<Type: Codable>(
    _ request: ApiRequest, decodingTo type: Type.Type, expectedStatusCodes: [Int],
    completion: @escaping (Type?, Error?) -> Void)
  
    
  static func performUploadRequest<Type: Codable>(
    _ request: ApiRequest, uploadingData data: URL,
    decodingTo type: Type.Type, expectedStatusCodes: [Int],
    completion: @escaping (Type?, Error?) -> Void)
  
  static func performVideoUploadRequest<Type: Codable>(
    _ request: ApiRequest, uploadingData data: URL,
    decodingTo type: Type.Type, expectedStatusCodes: [Int],
    completion: @escaping (Type?, Error?) -> Void)
}

