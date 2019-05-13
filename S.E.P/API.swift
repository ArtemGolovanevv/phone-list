//
//  API.swift
//  S.E.P
//
//  Created by Artem Golovanev on 11.05.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//
import Foundation
import UIKit

class APIManager {
    let stubDataURL = "https://api.jsonbin.io/b/5cd59f114c004c0eb4964898"
    func getPhones(completion: @escaping (_ phonesArray: [DataModel]?, _ error: Error?) -> Void) {
        getJSONFromURL(urlString: stubDataURL) { (data, error) in
            guard let data = data, error == nil else {
                print("Failed to get data")
                return completion(nil, error)
            }
            self.createPhonesObject(json: data, completion: { (phones, error) in
                if let error = error {
                    print("Failed to convert data")
                    return completion(nil, error)
                }
                return completion(phones, nil)
            })
        }
    }

    private func getJSONFromURL(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error: Cannot create URL from string")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["secret-key": "$2a$10$cdHW5sCGM3Zq/3xhPYJkjewt.LAiMIX3zA8wnYxZ7ypuuBUWkli.e"]
        let session = URLSession.init(configuration: config)
        session.dataTask(with: urlRequest) { (data, response, error) in
            if (response != nil) {
                print(response as Any)
            }
            let dispatch = DispatchQueue(label: "Phones Queues", qos: .utility, attributes: .concurrent)
            dispatch.async {
                guard error == nil else {
                    print("Error calling api")
                    return completion(nil, error)
                }
                guard let responseData = data else {
                    print("Data is nil")
                    return completion(nil, error)
                }
                completion(responseData, nil)
            }
        }
        .resume()
    }

    private func createPhonesObject(json: Data, completion: @escaping (_ data: [DataModel]?, _ error: Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let phones = try decoder.decode([DataModel].self, from: json)
            return completion(phones, nil)
            }
        catch let error {
            print("Error creating current phone object from JSON because: \(error.localizedDescription)")
            return completion(nil, error)
        }
    }
}

extension APIManager {

    internal func uploadPhones( phonesArray: [DataModel]) -> Bool {
        var isUploaded = Bool()
        let urlstr = "https://jsonplaceholder.typicode.com/posts"
        guard let url = URL(string: urlstr) else {
            print("Error: Cannot read URL from string")
            isUploaded = false
            return isUploaded
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let uploadData = try? JSONEncoder().encode(phonesArray) else {
            print("Error: Cannot convert data")
            isUploaded = false
            return isUploaded
        }
        let session = URLSession.shared
        session.uploadTask(with: request, from: uploadData) { data, response, error in
            let dispatch = DispatchQueue(label: "Upload Data", qos: .background, attributes: .concurrent)
            dispatch.async {
                if let error = error {
                    print ("error: \(error)")
                    isUploaded = false
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        isUploaded = false
                        return
                }
                if let mimeType = response.mimeType,
                    mimeType == "application/json",
                    let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print ("got data: \(dataString)")
                }
            }
        }
        .resume()
        isUploaded = true
        return isUploaded
    }
}


