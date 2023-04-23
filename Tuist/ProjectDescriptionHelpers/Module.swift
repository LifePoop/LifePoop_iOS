//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public enum Module: String {
    case app
    case common
    case coordinator
    case data
    case domain
    case presentation
    
    public var name: String {
        return rawValue.capitalized
    }
    
    public var path: String {
        return "Projects/\(name)"
    }
}
