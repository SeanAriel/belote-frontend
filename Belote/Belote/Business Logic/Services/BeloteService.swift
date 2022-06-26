//
//  BeloteService.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

protocol BeloteServiceProtocol {
    func initializeGame(code: String, completion: @escaping (Result<Belote, BeloteServiceError>) -> Void)
    func startSession(completion: @escaping (Result<SessionCode, BeloteServiceError>) -> Void)
    func applyMove(code: String, action: Int, completion: @escaping (Result<Belote, BeloteServiceError>) -> Void)
    func getGameTrackingData(code: String, completion: @escaping (Result<GameTrackingData, BeloteServiceError>) -> Void)
    func closeSession(code: String, completion: @escaping (Result<CloseSession, BeloteServiceError>) -> Void)
}

enum BeloteServiceError: Error {
    case commonError
}

final class BeloteService: BeloteServiceProtocol {
    init(webService: BeloteWebServiceProtocol) {
        self.webService = webService
    }
    
    func startSession(completion: @escaping (Result<SessionCode, BeloteServiceError>) -> Void) {
        let transformer = SessionWebTransformer()
        webService.startSession { result in
            completion(result.map { transformer.transform($0) }.mapError { transformer.transform($0) })
        }
    }
    
    func initializeGame(code: String, completion: @escaping (Result<Belote, BeloteServiceError>) -> Void) {
        let transformer = BeloteWebTransformer()
        webService.initializeGame(code: code) { result in
            completion(result.map { transformer.transform($0) }.mapError { transformer.transform($0) })
        }
    }
    
    func applyMove(code: String, action: Int, completion: @escaping (Result<Belote, BeloteServiceError>) -> Void) {
        let transformer = BeloteWebTransformer()
        webService.applyMove(code: code, action: String(action)) { result in
            completion(result.map { transformer.transform($0) }.mapError { transformer.transform($0) })
        }
    }
    
    func getGameTrackingData(code: String, completion: @escaping (Result<GameTrackingData, BeloteServiceError>) -> Void) {
        let transformer = GameTrackingDataWebTransformer()
        webService.getGameTrackingData(code: code) { result in
            completion(result.map { transformer.transform($0) }.mapError { transformer.transform($0) })
        }
    }
    
    func closeSession(code: String, completion: @escaping (Result<CloseSession, BeloteServiceError>) -> Void) {
        let transformer = CloseSessionWebTransformer()
        webService.closeSession(code: code) { result in
            completion(result.map { transformer.transform($0) }.mapError { transformer.transform($0) })
        }
    }
    
    // MARK: - Private
    
    private let webService: BeloteWebServiceProtocol
}
