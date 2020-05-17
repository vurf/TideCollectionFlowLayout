//
//  TideViewController.swift
//  TideExample
//
//  Created by i.varfolomeev on 16/05/2020.
//  Copyright © 2020 i.varfolomeev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class TideViewController: UIViewController {
    
    // UI
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = TideCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = InfiniteCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.register(TideCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.infiniteDataSource = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    private lazy var contentView: TideContentView = {
        let view = TideContentView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewLayout.itemSize = view.bounds.size
    }
}

// MARK: - InfiniteCollectionViewDataSource

extension TideViewController: InfiniteCollectionViewDataSource {
    func numberOfItems(_ collectionView: UICollectionView) -> Int {
        return 20
    }
    
    func cellForItem(_ collectionView: UICollectionView, dequeue: IndexPath, usable: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: dequeue) as! TideCollectionViewCell
        cell.configure(usable)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TideViewController: UICollectionViewDelegate { }
