//
//  AddressableTarget.swift
//  Pale
//
//  Created by Jose Gonzalez on 11/10/2019.
//  Copyright © 2019 OPEN input. All rights reserved.
//

import Foundation
import Moya


public struct AddressableTarget<RelativeTarget: RelativeTargetType>: TargetType {
    public let baseURL: URL
    let relativeTarget: RelativeTarget

    public var path: String { return relativeTarget.path }
    public var method: Moya.Method { return relativeTarget.method }
    public var sampleData: Data { return relativeTarget.sampleData }
    public var task: Task { return relativeTarget.task }
    public var headers: [String: String]? { return relativeTarget.headers }

    public init(baseURL: URL, relativeTarget: RelativeTarget) {
        self.baseURL = baseURL
        self.relativeTarget = relativeTarget
    }
}
