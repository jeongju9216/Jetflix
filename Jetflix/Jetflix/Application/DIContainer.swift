//
//  DIContainer.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/22.
//

import Foundation

final class DIContainer {
    static var shared = DIContainer()
    
    private init() { }
    
    private var dependencies: [String: Any] = [:]

    func register<T>(type: T.Type, service: Any) {
        dependencies["\(type)"] = service
    }

    func resolve<T>(type: T.Type) -> T {
        let key = "\(type)"
        let dependency = dependencies[key] as? T

        precondition(dependency != nil, "\(key) Dependency가 없음")

        return dependency!
    }
}

@propertyWrapper
class Dependency<T> {
    
    let wrappedValue: T
    
    init() {
        self.wrappedValue = DIContainer.shared.resolve(type: T.self)
    }
}
