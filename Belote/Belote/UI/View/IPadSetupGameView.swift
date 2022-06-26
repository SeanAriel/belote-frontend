//
//  SetupGameView.swift
//  Belote
//
//  Created by Sitora Guliamova on 18.05.2022.
//

import UIKit

protocol IPadSetupGameViewDelegate: AnyObject {
    func didTapContinueButton(_ view: IPadSetupGameView, difficulty: Int)
}

enum Condition {
    case solo
    case multyplayer
    case selectionMode
    case start
}

class IPadSetupGameView: UIView, NibLoadable {
    @IBOutlet private weak var gameModeSelectionView: UIStackView!
    @IBOutlet private weak var soloGameDifficultySelectionView: UIStackView!
    @IBOutlet private weak var difficultySelectionSlider: UISlider!
    
    private var condition: Condition = .selectionMode {
        didSet {
            stateObserver()
        }
    }
    
    weak var delegate: IPadSetupGameViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
    }
    
    private func stateObserver() {
        switch condition {
        case .solo:
            gameModeSelectionView.isHidden = true
            soloGameDifficultySelectionView.isHidden = false
        case .multyplayer:
            break
        case .selectionMode:
            soloGameDifficultySelectionView.isHidden = true
            gameModeSelectionView.isHidden = false
        case .start:
            delegate?.didTapContinueButton(self, difficulty: Int(difficultySelectionSlider.value))
            self.isHidden = true
        }
    }
    
    @IBAction func didTapSoloGameButton(_ sender: Any) {
        condition = .solo
    }
    
    @IBAction func didTapMultyplayerButton(_ sender: Any) {
        condition = .multyplayer
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        condition = .selectionMode
    }

    @IBAction func didTapContinueButton(_ sender: Any) {
        condition = .start
    }
}
