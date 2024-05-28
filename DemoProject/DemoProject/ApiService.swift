//
//  ApiService.swift
//  DemoProject
//
//  Created by sachin on 28/05/24.
//

import Foundation
import UIKit


class ApiService{
    
    static let shared = ApiService()
    
    private init(){}
    
    func fetchPosts(page: Int = 1, limit: Int = 20) async throws -> Result<[Post], NetworkError> {
        let urlStr = "\(Constants.postBaseApi)?_page=\(page)&_limit=\(limit)"
        guard let url = URL(string: urlStr) else {
            return .failure(.wrongUrl)
        }
        
        print("url string: \(urlStr)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return .failure(.badServerResponse)
        }
        
        do{
            let posts = try JSONDecoder().decode([Post].self, from: data)
            print("posts are \(posts)")
            return .success(posts)
        } catch{
            return .failure(.noData)
        }
    }
    
}


enum NetworkError : Error {
    case wrongUrl
    case noData
    case badServerResponse
}
    
