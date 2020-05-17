//
//  TideCollectionViewCell.swift
//  TideExample
//
//  Created by i.varfolomeev on 16/05/2020.
//  Copyright © 2020 i.varfolomeev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class TideCollectionViewCell: UICollectionViewCell {
    
    // UI
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - Public
    
    func configure(_ model: IndexPath) {
        label.text = "\(model)"
    }
    
    // MARK: - Private
    
    private func setUp() {
        contentView.backgroundColor = .green
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
