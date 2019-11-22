//
//  AddressableMoyaProvider.swift
//  Pale
//
//  Created by Jose Gonzalez on 11/10/2019.
//  Copyright © 2019 OPEN input. All rights reserved.
//

import Foundation
import Moya


/// A protocol representing an addressable resource, useful when working with a set of providers.
public protocol Addressable {
    var baseURL: URL { get set }
}


/// A protocol representing a minimal interface for an AddressableMoyaProvider.
public protocol AddressableMoyaProviderType: Addressable, MoyaProviderType where Target == AddressableTarget<RelativeTarget> {
    associatedtype RelativeTarget: RelativeTargetType

    /// Designated request-making method. Returns a `Cancellable` token to cancel the request later.
    func request(_ target: RelativeTarget, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping Moya.Completion) -> Cancellable
}


/// Addressable request provider class. Provides support for dynamic base URLs + relative targets.
open class AddressableMoyaProvider<RelativeTarget: RelativeTargetType>: MoyaProvider<AddressableTarget<RelativeTarget>>, AddressableMoyaProviderType {
    public var baseURL: URL

    /// Initializes a provider.
    public init(baseURL: URL,
         endpointClosure: @escaping EndpointClosure = AddressableMoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping RequestClosure = AddressableMoyaProvider.defaultRequestMapping,
         stubClosure: @escaping StubClosure = AddressableMoyaProvider.neverStub,
         callbackQueue: DispatchQueue? = nil,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {

        self.baseURL = baseURL
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: plugins, trackInflights: trackInflights)
    }

    /// Designated request-making method. Returns a `Cancellable` token to cancel the request later.
    @discardableResult
    open func request(_ target: RelativeTarget, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Cancellable {
        self.request(AddressableTarget(baseURL: baseURL, relativeTarget: target), callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
}
