//
//  filterButton.swift
//  Streamify
//
//  Created by youngkyun park on 3/24/25.
//

import UIKit

final class FilterButton: BaseView {

    let filterButton = ActionButton()

    
    override func configureHierarchy() {
        addSubview(filterButton)
      
    }
    
    override func configureLayout() {
        
        filterButton.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
            
    }
    
    override func configureView() {
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .setStreamifyColor(.baseWhite)
        config.baseBackgroundColor = .clear
        config.buttonSize = .large
        config.cornerStyle = .capsule

        config.attributedTitle = updateTitle(for: .normal)
        
        // Configuration Update Handler for button state change
        filterButton.configurationUpdateHandler = { [weak self]  in
            guard let self = self else { return }
            config.attributedTitle = updateTitle(for: filterButton.state)
            
            switch $0.state {
            case .normal:
                config.baseForegroundColor = .setStreamifyColor(.primaryYellow)
            case .selected:
                config.baseForegroundColor = .setStreamifyColor(.baseLightGray)
            default:
                break
            }
            
            self.filterButton.configuration = config
        }

    }
        
    
    // Title Setting
    private func updateTitle(for state: UIControl.State) -> AttributedString {
        var titleContainer = AttributeContainer()
        titleContainer.font = .setStreamifyFont(.body_bold_16)
        
        switch state {
        case .normal:
            return AttributedString("Star ▲", attributes: titleContainer)
        case .selected:
            return AttributedString("Star ▼", attributes: titleContainer)
        default:
            return AttributedString("", attributes: titleContainer)
        }
    }

    

}
