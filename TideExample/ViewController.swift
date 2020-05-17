//
//  ViewController.swift
//  TideExample
//
//  Created by i.varfolomeev on 16/05/2020.
//  Copyright © 2020 i.varfolomeev. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 23)
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 200, height: 50))
        }
    }

    @objc private func buttonDidTap() {
        let viewController = TideViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

