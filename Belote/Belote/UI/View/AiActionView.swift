//
//  AiActionView.swift
//  Belote
//
//  Created by Sitora Guliamova on 11.06.2022.
//

import UIKit

class AiActionView: UIView, NibLoadable {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var aiAction: ActionType? {
        didSet {
            guard let action = aiAction else { return }
            stackView.removeFullyAllArrangedSubviews()
            stackView.addArrangedSubview(getButtonAction(action: action))
        }
    }
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    private func getButtonAction(action: ActionType) -> ActionButton {
        switch action {
        case .launch(let name):
            switch name {
            case .clubs, .diamonds, .hearts, .spades:
                return createSuitButton(name: name)
            case .sa, .ta, .pass:
                return createLabelButton(name: name)
            }
        case .game:
            return ActionButton()
        }
    }
    
    private func createSuitButton(name: ActionName) -> ActionButton {
        let button = ActionButton()
        button.actionName = name
        button.setBackgroundImage(UIImage(named: name.rawValue), for: .normal)
        button.aspectRatio()
        return button
    }
    
    private func createLabelButton(name: ActionName) -> ActionButton {
        let button = ActionButton()
        button.actionName = name
        button.setTitle(name.rawValue.replacingOccurrences(of: "_", with: " "), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.aspectRatio()
        return button
    }
}
