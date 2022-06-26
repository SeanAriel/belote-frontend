//
//  GameViewController.swift
//  Belote
//
//  Created by Sitora Guliamova on 18.05.2022.
//

import UIKit
import SpriteKit

struct StrokeSynchronizer {
    var didApplyMove: Bool
    var didMoveCard: Bool
}

final class IPadGameViewController: UIViewController {
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var setupGameView: IPadSetupGameView!
    @IBOutlet private weak var helpButton: UIButton!
    @IBOutlet private weak var legalActionsView: LegalActionsView!
    @IBOutlet private weak var aiActionView: AiActionView!
    
    private let gameService: GameServiceProtocol = GameService()
    private let scene = SKScene(fileNamed: "GameScene") as? GameScene
    
    private var cardIsEnabled: Bool = false
    private var actionSecond: ActionType?
    
    private var belote: Belote? {
        didSet {
            guard let belote = belote, let action = belote.actions.first?.value else { return }
            switch action {
            case .launch:
                legalActionsView.legalActions = belote.legalActions.map { belote.actions[$0] }
                
                if let aiActionIndex = belote.aiActions.first {
                    let aiAction: ActionType? = belote.actions[aiActionIndex]
                    aiActionView.aiAction = aiAction
                }
                legalActionsView.isHidden = false
                aiActionView.isHidden = belote.aiActions.isEmpty
            default:
                aiActionView.title = "Contract"
                aiActionView.aiAction = .launch(name: belote.agreedUponContract)
            }
        }
    }
    
    private var isStartingSession: Bool? {
        didSet {
            if isStartingSession == true {
                initilizeGame {}
            }
        }
    }
    
    private var strokeSynchronizer =  StrokeSynchronizer(didApplyMove: false, didMoveCard: false) {
        didSet {
            if strokeSynchronizer.didApplyMove && strokeSynchronizer.didMoveCard {
                self.gaming()
                self.strokeSynchronizer.didMoveCard = false
                self.strokeSynchronizer.didApplyMove = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameView.delegate = self
        legalActionsView.delegate = self
        
        gameService.startSession { [weak self] result in
            self?.isStartingSession = result
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            guard let scene = scene else { return }
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            scene.gameDelegate = self
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
        helpButton.isHidden = false
        backgroundView.isHidden = true
    }
    
    private func initilizeGame(completion: @escaping () -> ()) {
        gameService.initializeGame { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.belote = result
                self?.scene?.deal = result?.wholeDeal
                completion()
            }
        }
    }
    
    private func gaming() {
        guard let belote = belote else { return }
        
        let cardsMoveAi: [ActionType?] = belote.aiActions.map { belote.actions[$0] }
        if cardsMoveAi.isEmpty {
            self.cardIsEnabled = true
        } else if cardsMoveAi.count == 1 {
            guard let action = cardsMoveAi.first else { return }
            scene?.moveToCard(action: action, complition: {
                self.cardIsEnabled = true
            })
        } else if cardsMoveAi.count == 2 {
            guard let actionFirst = cardsMoveAi.first, let actionSecond = cardsMoveAi.last else { return }
            scene?.moveToCard(action: actionFirst, complition: {
                self.actionSecond = actionSecond
            })
        }
    }
    
    @IBAction func didTapHelpButton(_ sender: Any) {
    }

    @IBAction func didTapMenuButton(_ sender: Any) {
    }
}

// MARK: - IPadSetupGameViewDelegate

extension IPadGameViewController: IPadSetupGameViewDelegate {
    func didTapContinueButton(_ view: IPadSetupGameView, difficulty: Int) {
        setupScene()
    }
}

// MARK: - LegalActionsViewDelegate

extension IPadGameViewController: LegalActionsViewDelegate {
    func didTapAction(_ view: LegalActionsView, action: ActionType) {
        gameService.applyMove(action: action) { result in
            legalActionsView.isHidden = result
        } completion: { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.belote = result
                self?.gaming()
            }
        }
    }
}

// MARK: - GameSceneDelegate

extension IPadGameViewController: GameSceneDelegate {
    func gameOver() {
        print("-----game over")
        gameService.getGameTrackingData { result in
            guard let result = result else { return }

            print(result.gameState)
            print(result.scorePerspective)
        }
        initilizeGame { [weak self] in
            self?.scene?.removeAllChildren()
            self?.scene?.restartGame()
        }
    }
    
    func didMoveCard(who: Who) {
        switch who {
        case .user:
            self.strokeSynchronizer.didMoveCard = true
        case .pc:
            if let actionSecond = actionSecond {
                scene?.moveToCard(action: actionSecond, complition: {
                    self.cardIsEnabled = true
                })
            }
            actionSecond = nil
        }
    }
    
    func didTapCard(_ scene: SKScene, card: CardType) -> Bool {
        var isEnabled: Bool = false
        
        gameService.applyMove(action: .game(cardType: card)) { result in
            isEnabled = result
        } completion: { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.belote = result
                self?.strokeSynchronizer.didApplyMove = true
            }
        }
        let result = self.cardIsEnabled && isEnabled
        self.cardIsEnabled = !isEnabled && self.cardIsEnabled
        return result
    }
}
