//
//  BeloteWebService.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

protocol BeloteWebServiceProtocol {
    func initializeGame(code: String, completion: @escaping (Result<BeloteWebResponse, BeloteWebServiceError>) -> Void)
    func startSession(completion: @escaping (Result<SessionCodeWebResponse, BeloteWebServiceError>) -> Void)
    func applyMove(code: String, action: String, completion: @escaping (Result<BeloteWebResponse, BeloteWebServiceError>) -> Void)
    func getGameTrackingData(code: String, completion: @escaping (Result<GameTrackingDataWebResponse, BeloteWebServiceError>) -> Void)
    func closeSession(code: String, completion: @escaping (Result<CloseSessionWebResponse, BeloteWebServiceError>) -> Void)
}

enum BeloteWebServiceError: Error {
    case commonError
}

final class BeloteWebService: BeloteWebServiceProtocol {
    func closeSession(code: String, completion: @escaping (Result<CloseSessionWebResponse, BeloteWebServiceError>) -> Void) {
        self.manager.fetch(
            request: HTTPRequest.makeWithEmptyBodyQuery(
                method: .post,
                url: "\(TextUrl.url)/\(TextUrl.closeSession)/\(code)"),
            responseType: CloseSessionWebResponse.self,
            completion: {
                completion($0.mapError { _ in BeloteWebServiceError.commonError })
            })
    }
    
    
    func applyMove(code: String, action: String, completion: @escaping (Result<BeloteWebResponse, BeloteWebServiceError>) -> Void) {
        self.manager.fetch(
            request: HTTPRequest.makeWithEmptyBodyQuery(
                method: .post,
                url: "\(TextUrl.url)/\(TextUrl.applyMove)/\(code)/\(action)"),
            responseType: BeloteWebResponse.self,
            completion: {
                completion($0.mapError { _ in BeloteWebServiceError.commonError })
            })
    }
    
    func startSession(completion: @escaping (Result<SessionCodeWebResponse, BeloteWebServiceError>) -> Void) {
        self.manager.fetch(
            request: HTTPRequest.makeWithEmptyBodyQuery(
                method: .get,
                url: "\(TextUrl.url)/\(TextUrl.startSession)"),
            responseType: SessionCodeWebResponse.self,
            completion: {
                completion($0.mapError { _ in BeloteWebServiceError.commonError })
            })
    }
    
    func initializeGame(code: String, completion: @escaping (Result<BeloteWebResponse, BeloteWebServiceError>) -> Void) {
        self.manager.fetch(
            request: HTTPRequest.makeWithEmptyBodyQuery(
                method: .get,
                url: "\(TextUrl.url)/\(TextUrl.initializeGame)/\(code)"),
            responseType: BeloteWebResponse.self,
            completion: {
                completion($0.mapError { _ in BeloteWebServiceError.commonError })
            })
    }
    
    func getGameTrackingData(code: String, completion: @escaping (Result<GameTrackingDataWebResponse, BeloteWebServiceError>) -> Void) {
        self.manager.fetch(
            request: HTTPRequest.makeWithEmptyBodyQuery(
                method: .get,
                url: "\(TextUrl.url)/\(TextUrl.getGameTrackingData)/\(code)"),
            responseType: GameTrackingDataWebResponse.self,
            completion: {
                completion($0.mapError { _ in BeloteWebServiceError.commonError })
            })
    }
    
    init(manager: HTTPManagerProtocol) {
        self.manager = manager
    }

    
    
    // MARK: - Private

    private let manager: HTTPManagerProtocol
}

extension BeloteWebService {
    private struct TextUrl {
        static let url = "http://34.77.247.189:1337"
        static let initializeGame = "initialize_game"
        static let applyMove = "apply_move"
        static let startSession = "start_session"
        static let getGameTrackingData = "get_game_tracking_data"
        static let closeSession = "close_session"
    }
}
