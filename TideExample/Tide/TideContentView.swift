//
//  TideContentView.swift
//  TideExample
//
//  Created by i.varfolomeev on 16/05/2020.
//  Copyright © 2020 i.varfolomeev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class TideContentView: UIView {
    
    // UI
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.text = "Have a Good Day"
        return label
    }()
    private lazy var bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        [createButtonView(), createButtonView(), createButtonView(), createButtonView()].forEach {
            stack.addArrangedSubview($0)
        }
        
        return stack
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
    
    // MARK: - Private
    
    func setUp() {
        backgroundColor = .clear
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(100)
        }
    }
    
    private func createButtonView() -> UIView {
        let buttonView = UIView()
        buttonView.snp.makeConstraints { $0.size.equalTo(60) }
        buttonView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        buttonView.layer.cornerRadius = 30
        buttonView.layer.masksToBounds = true
        return buttonView
    }
    
    // MARK: - HitTest
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self {
            return nil
        }
        
        return view
    }
}
