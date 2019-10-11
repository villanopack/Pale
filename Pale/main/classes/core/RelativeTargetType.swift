//
//  RelativeTargetType.swift
//  Pale
//
//  Created by Jose Gonzalez on 11/10/2019.
//  Copyright © 2019 OPEN input. All rights reserved.
//

import Foundation
import Moya


/// The protocol used to define the specifications necessary for a `AddressableMoyaProvider`.
public protocol RelativeTargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Moya.Method { get }

    /// Provides stub data for use in testing.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: Task { get }

    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}


/// Default values
public extension RelativeTargetType {
    var method: Moya.Method { return .get }
    var sampleData: Data { return Data() }
    var validate: Bool { return false }
    var headers: [String: String]? { return nil }
}
