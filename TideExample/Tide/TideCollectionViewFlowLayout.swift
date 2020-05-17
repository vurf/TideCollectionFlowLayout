//
//  TideCollectionViewFlowLayout.swift
//  TideExample
//
//  Created by i.varfolomeev on 16/05/2020.
//  Copyright © 2020 i.varfolomeev. All rights reserved.
//

import Foundation
import UIKit

final class TideCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // Models
    private let cornerRadiusFactor: CGFloat // [100;500]
    private let scaleFactor: CGFloat // (1;0)
    private let negativeLeftBound: CGFloat // [-1;X]
    private let negativeRightBound: CGFloat // [X;0]
    private let positiveLeftBound: CGFloat // [0;X]
    private let positiveRightBound: CGFloat // [X;1]
    
    // MARK: - Init
    
    init(scaleFactor: CGFloat = 0.9, cornerRadiusFactor: CGFloat = 500) {
        self.cornerRadiusFactor = cornerRadiusFactor
        self.scaleFactor = scaleFactor
        self.negativeLeftBound = -scaleFactor
        self.negativeRightBound = scaleFactor - 1
        self.positiveLeftBound = 1 - scaleFactor
        self.positiveRightBound = scaleFactor
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        return attributes.map(transformLayoutAttributes)
    }
    
    // MARK: - Private
    
    private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else {
            return attributes
        }
        
        let width = collectionView.frame.width
        let itemOffset = attributes.center.x - collectionView.contentOffset.x
        let middleOffset = (itemOffset / width) - 0.5
        change(collectionView: collectionView, attributes: attributes, middleOffset: middleOffset)
        return attributes
    }
    
    private func change(collectionView: UICollectionView, attributes: UICollectionViewLayoutAttributes, middleOffset: CGFloat) {
        let scaleFactor = calculateScaleFactor(on: middleOffset)
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        attributes.transform = scaleTransform
        
        if let cell = collectionView.cellForItem(at: attributes.indexPath) {
            let cornerRadius = cornerRadiusFactor * (1 - scaleFactor)
            cell.layer.cornerRadius = cornerRadius
            cell.layer.masksToBounds = true
        }
    }
    
    private func calculateScaleFactor(on middleOffset: CGFloat) -> CGFloat {
        switch middleOffset {
        case (-1...negativeLeftBound):
            return abs(middleOffset)
        case (negativeRightBound...0), (0...positiveLeftBound):
            return 1 - abs(middleOffset)
        case (positiveRightBound...1):
            return middleOffset
        default:
            return scaleFactor
        }
    }
}
