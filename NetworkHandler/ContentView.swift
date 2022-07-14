//
//  ContentView.swift
//  NetworkHandler
//
//  Created by Pavnish Kumar Rana on 05/07/22.
//

class Empty: Codable {}

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Standard") {
                standardRequest()
            }
            Button("Image") {
                imageRequest()
            }
            Button("Video") {
                videoRequest()
            }
        }
    }
    
    func standardRequest() {
        let request = ApiRequest.createRequest(url: URL(string: "http://3.109.22.217:8000/api/v1/users/upload-video")!, method: .post, header: nil, paramModel: TestRequest(name: "Test title2", testRequestDescription: "Test Body2"))
        SessionManager.performRequest(request, decodingTo: DataWrapper<Empty>.self, expectedStatusCodes: [200, 201]) { response, error in
            print("respose")
        }
    }
    
    func imageRequest() {
        guard let imageFilePath = Bundle.main.url(forResource: "image", withExtension: "png") else { return }
        let request = ApiRequest.createRequest(url: URL(string: "http://3.109.22.217:8000/api/v1/users/upload-images")!, method: .post, header: nil, paramModel: VideoRequest(video: imageFilePath.absoluteString))
        SessionManager.performUploadRequest(request, uploadingData: imageFilePath, decodingTo: DataWrapper<Empty>.self, expectedStatusCodes: [200]) { respose, error in
            print("")
        }
    }
    
    func videoRequest() {
        
        guard let videoFilePath = Bundle.main.url(forResource: "video", withExtension: "mp4") else { return }
        let request = ApiRequest.createRequest(url: URL(string: "http://3.109.22.217:8000/api/v1/users/upload-video")!, method: .post, header: nil, paramModel: VideoRequest(video: videoFilePath.absoluteString))
        SessionManager.performVideoUploadRequest(request, uploadingData: videoFilePath, decodingTo: DataWrapper<Empty>.self, expectedStatusCodes: [200]) { response, error in
            print("")
        }
    }
}

struct TestRequest: Codable {
    let name, testRequestDescription: String

    enum CodingKeys: String, CodingKey {
        case name
        case testRequestDescription = "description"
    }
}

struct VideoRequest: Codable {
    let video: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
