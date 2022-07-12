//
//  SessionManager.swift
//  NetworkHandler
//
//  Created by Pavnish Kumar Rana on 05/07/22.
//

import Foundation
import Alamofire

class SessionManager: APIService {
    private static let defaultSession = URLSession(configuration: .default)
    private static var dataTask: URLSessionDataTask?
    
   
    static func checkCancelled(_ error: Error?) -> StandardServiceErrors? {
      if (error as NSError?)?.code == -999 {
        return StandardServiceErrors.requestCancelled
      }
      return nil
    }
    
    static func performRequest<Type>(_ request: URLRequest, decodingTo type: Type.Type, expectedStatusCodes: [Int], completion: @escaping (Type?, Error?) -> Void) where Type : Decodable, Type : Encodable {
        AF.request(request)
            .response(completionHandler: { (response) in
                if let error = checkCancelled(response.error) {
                    completion(nil, error)
                    return
                }
                
                if let error = response.response?.validate(expectedStatusCodes: expectedStatusCodes) {
                    completion(nil, error)
                    return
                }
                
                switch response.decodeData(to: type) {
                case .failure(let error):
                    completion(nil, error)
                case .success(let data):
                    completion(data, response.error)
                }
            })
    }
    
    static func performUploadRequest<Type>(_ request: URLRequest, uploadingData data: Data, decodingTo type: Type.Type, expectedStatusCodes: [Int], completion: @escaping (Type?, Error?) -> Void) where Type : Decodable, Type : Encodable {
        AF.upload(multipartFormData: { (multipart) in
            multipart.append(data, withName: "image", fileName: "someFile.jpg", mimeType: "image/jpeg")
        }, with: request)
        .uploadProgress(closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .downloadProgress(closure: { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        })
        .response { (response) in
            if let error = checkCancelled(response.error) {
                completion(nil, error)
                return
            }
            
            if let error = response.response?.validate(expectedStatusCodes: expectedStatusCodes) {
                completion(nil, error)
                return
            }
            
            switch response.decodeData(to: type) {
            case .failure(let error):
                completion(nil, error)
            case .success(let data):
                completion(data, response.error)
            }
        }
      }
    
    static func performVideoUploadRequest<Type>(_ request: URLRequest, uploadingData data: URL, decodingTo type: Type.Type, expectedStatusCodes: [Int], completion: @escaping (Type?, Error?) -> Void) where Type : Decodable, Type : Encodable {
        AF.upload(multipartFormData: { (multipart) in
            multipart.append(data, withName: "video", fileName: "someFile.mp4", mimeType: "image/jpeg")
        }, with: request)
        .uploadProgress(closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .downloadProgress(closure: { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        })
        .response { (response) in
            if let error = checkCancelled(response.error) {
                completion(nil, error)
                return
            }
            
            if let error = response.response?.validate(expectedStatusCodes: expectedStatusCodes) {
                completion(nil, error)
                return
            }
            
            switch response.decodeData(to: type) {
            case .failure(let error):
                completion(nil, error)
            case .success(let data):
                completion(data, response.error)
            }
        }
      }
}

extension DataResponse {
    
    func decodeData<Type: Codable>(to: Type.Type) ->Result<Type, Error> {
        guard let data = data else { return .failure(StandardServiceErrors.noResponseData) }
        do {
            let decodedData = try JSONDecoder().decode(Type.self, from: data)
            return .success(decodedData)
        } catch {
            print("ERROR - \(error)")
            return .failure(error)
        }
    }
}


extension HTTPURLResponse {
    func validate(expectedStatusCodes: [Int]) -> StandardServiceErrors? {
        if !expectedStatusCodes.contains(statusCode) {
            return StandardServiceErrors.badStatusCode(statusCode)
        }
        return nil
    }
    
   
}
