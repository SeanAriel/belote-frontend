//
//  SessionCodeWebTransformer.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

final class SessionWebTransformer {
    func transform(_ webModel: SessionCodeWebResponse) -> SessionCode {
        SessionCode(code: webModel.session_code)
    }

    func transform(_ webError: BeloteWebServiceError) -> BeloteServiceError {
        switch webError {
        case .commonError: return .commonError
        }
    }
}
