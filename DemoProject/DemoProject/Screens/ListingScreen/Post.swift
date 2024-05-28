//
//  Posts.swift
//  DemoProject
//
//  Created by sachin on 28/05/24.
//

import Foundation


struct Post: Codable, Hashable{
    let uuid = UUID()
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
//    public func hash(into hasher: inout Hasher) {
//        return hasher.combine(uuid)
//    }
    
    var userId: Int? = 0
    var id: Int? = 0
    var title: String? = ""
    var body: String? = ""
}
