//
//  NetworkResource.swift
//  dustAlert-MVVM
//
//  Created by 이주상 on 2023/04/13.
//

import Foundation

struct NetworkResource<T: Decodable> {
    var baseUrl: String
    var params: [String: String]
    var header: [String: String]
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: baseUrl)!
        let queryItems = params.map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = queryItems
        var request = URLRequest(url: urlComponents.url!)
        header.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    init(baseUrl: String, params: [String: String] = [:], header: [String: String] = [:]) {
        self.baseUrl = baseUrl
        self.params = params
        self.header = header
    }
}
