//
//  AddressableMoyaProvider.swift
//  Pale
//
//  Created by Jose Gonzalez on 11/10/2019.
//  Copyright © 2019 OPEN input. All rights reserved.
//

import Foundation
import Moya
import RxSwift


public extension Reactive where Base: AddressableMoyaProviderType {
    func request(_ token: Base.RelativeTarget, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        self.request(AddressableTarget(baseURL: base.baseURL, relativeTarget: token), callbackQueue: callbackQueue)
    }

    /// Designated request-making method with progress.
    func requestWithProgress(_ token: Base.RelativeTarget, callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        self.requestWithProgress(AddressableTarget(baseURL: base.baseURL, relativeTarget: token), callbackQueue: callbackQueue)
    }
}
