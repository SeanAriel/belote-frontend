//
//  CloseSessionWebTransformer.swift
//  Belote
//
//  Created by Sitora Guliamova on 29.05.2022.
//

import Foundation

final class CloseSessionWebTransformer {
    func transform(_ webModel: CloseSessionWebResponse) -> CloseSession {
        CloseSession(message: webModel.message)
    }

    func transform(_ webError: BeloteWebServiceError) -> BeloteServiceError {
        switch webError {
        case .commonError: return .commonError
        }
    }
}
