//
//  RepoModel.swift
//  GitSearch
//
//  Created by 박의서 on 2023/06/26.
//

import Foundation

struct RepoModel : Codable{
    let id,starCount: Int
    let name, fullName: String
    
    enum CodingKeys: String,CodingKey {
        case id,name
        case starCount = "stargazers_count"
        case fullName = "full_name"
    }
}
