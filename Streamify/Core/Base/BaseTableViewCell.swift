//
//  BaseTableViewCell.swift
//  Streamify
//
//  Created by youngkyun park on 3/20/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
        self.backgroundColor = .setStreamifyColor(.baseBlack)
    }


    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }

    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
