//
//  GameService.swift
//  Belote
//
//  Created by Sitora Guliamova on 27.05.2022.
//

import Foundation

protocol GameServiceProtocol {
    func startSession(completion: @escaping (Bool) -> Void)
    func closeSession(completion: @escaping (Bool) -> Void)
    func initializeGame(completion: @escaping (Belote?) -> Void)
    func applyMove(action: ActionType, actionFound: (Bool) -> (), completion: @escaping (Belote?) -> ())
    func getGameTrackingData(completion: @escaping (GameTrackingData?) -> ())
}

final class GameService: GameServiceProtocol {
    private let manager: HTTPManager
    private let webService: BeloteWebService
    private let service: BeloteService
    
    private var codeSession: String?
    
    var actions: [Int: ActionType] = [:]
    var legalActions: [Int] = []
    
    init() {
        self.manager = HTTPManager()
        self.webService = BeloteWebService(manager: self.manager)
        self.service = BeloteService(webService: self.webService)
    }
    
    private func findAction(action: ActionType) -> Int? {
        for item in self.actions {
            if item.value == action {
                return legalActions.contains(item.key) ? item.key : nil
            }
        }
        return nil
    }
    
    func startSession(completion: @escaping (Bool) -> Void) {
        service.startSession { [weak self] result in
            switch result {
            case .success(let resp):
                self?.codeSession = resp.code
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func closeSession(completion: @escaping (Bool) -> Void) {
        guard let codeSession = codeSession else { return }

        service.closeSession(code: codeSession) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func initializeGame(completion: @escaping (Belote?) -> Void) {
        guard let codeSession = codeSession else { return }
        
        service.initializeGame(code: codeSession) { [weak self] result in
            switch result {
            case .success(let resp):
                self?.actions = resp.actions
                self?.legalActions = resp.legalActions
                completion(resp)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func applyMove(action: ActionType, actionFound: (Bool) -> (), completion: @escaping (Belote?) -> ()) {
        guard let codeSession = codeSession,
               let actionIndex = findAction(action: action)
        else {
            actionFound(false)
            return
        }
        
        actionFound(true)
        
        service.applyMove(code: codeSession, action: actionIndex) { [weak self] result in
            switch result {
            case .success(let resp):
                self?.actions = resp.actions
                self?.legalActions = resp.legalActions
                completion(resp)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func getGameTrackingData(completion: @escaping (GameTrackingData?) -> ()) {
        guard let codeSession = codeSession else { return }
        
        service.getGameTrackingData(code: codeSession) { result in
            switch result {
            case .success(let resp):
                completion(resp)
            case .failure:
                completion(nil)
            }
        }
    }
}
