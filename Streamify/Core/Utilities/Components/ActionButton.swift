//
//  ActionButton.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

class ActionButton: UIButton {
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(title: String, image: UIImage.SFSymbol) {
        self.init()
        configureButton(title: title, image: image, subTitle: nil)
    }
    
    convenience init(title: String, subTitle: String) {
        self.init()
        configureButton(title: title, image: nil, subTitle: subTitle)
    }
    
    private func configureButton(title: String, image: UIImage.SFSymbol?, subTitle: String?) {
          var config = UIButton.Configuration.plain()
          config.baseForegroundColor = .setStreamifyColor(.baseWhite)
          config.baseBackgroundColor = .clear
          config.buttonSize = .large
          config.cornerStyle = .capsule

          // Title Setting
          var titleContainer = AttributeContainer()
        titleContainer.font = .setStreamifyFont(.body_regular_13)
          config.attributedTitle = AttributedString(title, attributes: titleContainer)
          
          // Image Setting
          if let image = image {
              config.image = .setSymbolConfiguration(image, .size_bold_18)
              config.imagePlacement = .top
              config.imagePadding = 8
          }
          
          // Subtitle Setting
          if let subTitle = subTitle {
              var subtitleContainer = AttributeContainer()
              subtitleContainer.font = .setStreamifyFont(.body_regular_13)
              config.attributedSubtitle = AttributedString(subTitle, attributes: subtitleContainer)
              config.titleAlignment = .center
              config.titlePadding = 8
          }

          configurationUpdateHandler = { [weak self] btn in
              switch btn.state {
              case .normal:
                  self?.configuration?.baseForegroundColor = .setStreamifyColor(.baseWhite)
              case .selected:
                  self?.configuration?.baseForegroundColor = .setStreamifyColor(.primaryYellow)
              default:
                  return
              }
          }

          configuration = config
      }

    // Subtitle 수정 메서드
    func updateSubtitle(_ newSubtitle: String) {
        
        guard var config = self.configuration else { return }

        var subtitleContainer = AttributeContainer()
        subtitleContainer.font = .setStreamifyFont(.body_regular_13)
        config.attributedSubtitle = AttributedString(newSubtitle, attributes: subtitleContainer)

        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
