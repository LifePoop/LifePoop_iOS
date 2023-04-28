//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by 김상혁 on 2023/04/23.
//

import ProjectDescription

public enum Module: String {
    case App
    case DesignSystem
    case Logger
    case Utils
    case SharedRepository
    case SharedUseCase
    
    public var name: String {
        return rawValue
    }
    
    public var path: String {
        return "Projects/\(name)"
    }
}

public extension Module {
    enum Features: String, CaseIterable {
        case Login
        
        private var name: String {
            return rawValue
        }
        
        private var basePath: String {
            return "Projects/Features/Feature\(name)"
        }
        
        // MARK: - Name
        
        public var containerName: String {
            return "Feature\(name)DIContainer"
        }
        
        public var repositoryName: String {
            return "Feature\(name)Repository"
        }
        
        public var useCaseName: String {
            return "Feature\(name)UseCase"
        }
        
        public var presentationName: String {
            return "Feature\(name)Presentation"
        }
        
        // MARK: - Path
        
        public var containerPath: String {
            return "\(basePath)/Feature\(name)DIContainer"
        }
        
        public var repositoryPath: String {
            return "\(basePath)/Feature\(name)Repository"
        }
        
        public var useCasePath: String {
            return "\(basePath)/Feature\(name)UseCase"
        }
        
        public var presentationPath: String {
            return "\(basePath)/Feature\(name)Presentation"
        }
    }
}

public extension Module {
    enum Core: String, CaseIterable {
        case CoreComponent
        case CoreDataMapper
        case CoreDIContainer
        case CoreDTO
        case CoreEntity
        case CoreError
        case CoreExtension
        case CoreNetworkService
        case CoreStorageService
        case CoreTarget
        
        public var name: String {
            return rawValue
        }
        
        private var basePath: String {
            return "Projects/Core"
        }
        
        public var path: String {
            return "\(basePath)/\(name)"
        }
    }
}
