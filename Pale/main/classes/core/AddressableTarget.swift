//
//  AddressableTarget.swift
//  Pale
//
//  Created by Jose Gonzalez on 11/10/2019.
//  Copyright © 2019 OPEN input. All rights reserved.
//

import Foundation
import Moya


/// Internal struct used to bridge between `RelativeTarget`s and `Target`s.
public struct AddressableTarget<RelativeTarget: RelativeTargetType>: TargetType {
    public let baseURL: URL
    let relativeTarget: RelativeTarget

    public var path: String { relativeTarget.path }
    public var method: Moya.Method { relativeTarget.method }
    public var sampleData: Data { relativeTarget.sampleData }
    public var task: Task { relativeTarget.task }
    public var headers: [String: String]? { relativeTarget.headers }

    init(baseURL: URL, relativeTarget: RelativeTarget) {
        self.baseURL = baseURL
        self.relativeTarget = relativeTarget
    }
}
