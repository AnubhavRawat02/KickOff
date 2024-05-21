//
//  URLSessionExtension.swift
//  KickOff
//
//  Created by Anubhav Rawat on 11/05/24.
//

import Foundation

extension URLSession{
    
    enum CustomError: Error{
        case invalidURL, invalidData
    }
    
    func asyncRequest<T: Codable>(urlString: String, encodingObj: T.Type, httpMethod: String, headers: [String: String]?, body: [String: String]?, queryParams: [String: String]?) async throws -> T{
        
        if urlString.contains(Constants.getTodayFixtures()){
            print("this is url string: \(urlString)")
        }
        
        
        var paramsURLString = urlString
        
        if let queryParams = queryParams{
            paramsURLString = "\(paramsURLString)?"
            for (key, value) in queryParams{
                paramsURLString = "\(paramsURLString)\(key)=\(value)"
            }
        }
        
        guard let url = URL(string: paramsURLString) else {
            throw CustomError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod
        if let headers = headers{
            for (key, value) in headers{
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if urlString.contains(Constants.getDetailFixtureByID()){
            print("sending reqeuest")
        }
        
        let (data, response) = try await data(for: urlRequest)
        
        
        if urlString.contains(Constants.getTodayFixtures()){
            if let dataString = String(data: data, encoding: .utf8){
                print("got the data")
//                print(dataString)
            }else{
                print("data string empty")
            }
        }
        
        let result = try JSONDecoder().decode(encodingObj, from: data)
        
        return result
        
    }
}
