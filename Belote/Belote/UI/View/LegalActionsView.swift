//
//  LegalActionsView.swift
//  Belote
//
//  Created by Sitora Guliamova on 30.05.2022.
//

import UIKit

protocol LegalActionsViewDelegate: AnyObject {
    func didTapAction(_ view: LegalActionsView, action: ActionType)
}

class LegalActionsView: UIView, NibLoadable {
    @IBOutlet private weak var stackView: UIStackView!
    
    var axis: NSLayoutConstraint.Axis {
        get { stackView.axis }
        set { stackView.axis = newValue }
    }
    var legalActions: [ActionType?]? {
        didSet {
            guard let legalActions = legalActions else { return }
            stackView.removeFullyAllArrangedSubviews()
            legalActions.forEach {
                stackView.addArrangedSubview(getButtonAction(action: $0))
            }
        }
    }
    
    weak var delegate: LegalActionsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    private func getButtonAction(action: ActionType?) -> ActionButton {
        switch action {
        case .launch(let name):
            switch name {
            case .clubs, .diamonds, .hearts, .spades:
                return createSuitButton(name: name)
            case .sa, .ta, .pass:
                return createLabelButton(name: name)
            }
        default:
            return ActionButton()
        }
    }
    
    private func createSuitButton(name: ActionName) -> ActionButton {
        let button = ActionButton()
        button.actionName = name
        button.setBackgroundImage(UIImage(named: name.rawValue), for: .normal)
        button.aspectRatio()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }
    
    private func createLabelButton(name: ActionName) -> ActionButton {
        let button = ActionButton()
        button.actionName = name
        button.setTitle(name.rawValue.replacingOccurrences(of: "_", with: " "), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.aspectRatio()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }
    
    @objc private func didTapButton(_ sender: ActionButton) {
        guard let actionName = sender.actionName else { return }
        delegate?.didTapAction(self, action: .launch(name: actionName))
    }
}

class ActionButton: UIButton {
    var actionName: ActionName?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
