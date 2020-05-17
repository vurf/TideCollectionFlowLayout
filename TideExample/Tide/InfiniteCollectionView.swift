//
//  InfiniteCollectionView.swift
//  TideExample
//
//  Created by i.varfolomeev on 17/05/2020.
//  Copyright © 2020 i.varfolomeev. All rights reserved.
//

import Foundation
import UIKit

protocol InfiniteCollectionViewDataSource: AnyObject {
    func numberOfItems(_ collectionView: UICollectionView) -> Int
    func cellForItem(_ collectionView: UICollectionView, dequeue: IndexPath, usable: IndexPath) -> UICollectionViewCell
}

final class InfiniteCollectionView: UICollectionView {
    
    // Dependencies
    weak var infiniteDataSource: InfiniteCollectionViewDataSource?
    
    // Models
    private var indexOffset = 0
    private var cellSize: CGSize = .zero
    private var padding: CGFloat = .zero
    
    private var totalContentWidth: CGFloat {
        let numberOfCells = infiniteDataSource?.numberOfItems(self) ?? 0
        return CGFloat(numberOfCells) * (cellSize.width + padding)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCellSizes()
        setUpCenterIfNeeded()
    }
    
    // MARK: - Public
    
    var visibleIndexPath: IndexPath {
        let visibleIndex = indexPathsForVisibleItems[0]
        let usableRow = correctedIndex(visibleIndex.row - indexOffset)
        let usableIndexPath = IndexPath(row: usableRow, section: 0)
        return usableIndexPath
    }
    
    // MARK: - Private
    
    private func setUp() {
        dataSource = self
        updateCellSizes()
    }
    
    private func updateCellSizes() {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        cellSize = flowLayout.itemSize
        padding = flowLayout.minimumInteritemSpacing
    }
    
    private func setUpCenterIfNeeded() {
        let currentOffset = contentOffset
        let contentWidth = totalContentWidth
        
        // Calculate the centre of content X position offset and the current distance from that centre point
        let centerOffsetX: CGFloat = (3 * contentWidth - bounds.size.width) / 2
        let distFromCentre = centerOffsetX - currentOffset.x
        
        if (abs(distFromCentre) > (contentWidth / 4)) {
            // Total cells (including partial cells) from centre
            let cellcount = distFromCentre/(cellSize.width + padding)
            
            // Amount of cells to shift (whole number) - conditional statement due to nature of +ve or -ve cellcount
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
            
            // Amount left over to correct for
            let offsetCorrection = (abs(cellcount).truncatingRemainder(dividingBy: 1)) * (cellSize.width + padding)
            
            // Scroll back to the centre of the view, offset by the correction to ensure it's not noticable
            if (contentOffset.x < centerOffsetX) {
                //left scrolling
                contentOffset = CGPoint(x: centerOffsetX - offsetCorrection, y: currentOffset.y)
            } else if (contentOffset.x > centerOffsetX) {
                //right scrolling
                contentOffset = CGPoint(x: centerOffsetX + offsetCorrection, y: currentOffset.y)
            }
            
            // Make content shift as per shiftCells
            indexOffset += correctedIndex(shiftCells)
            
            // Reload cells, due to data shift changes above
            reloadData()
        }
    }
    
    private func correctedIndex(_ indexToCorrect: Int) -> Int {
        if let numberOfCells = infiniteDataSource?.numberOfItems(self) {
            if indexToCorrect < numberOfCells && indexToCorrect >= 0 {
                return indexToCorrect
            } else {
                let countInIndex = CGFloat(indexToCorrect) / CGFloat(numberOfCells)
                let flooredValue = Int(floor(countInIndex))
                let offset = numberOfCells * flooredValue
                return indexToCorrect - offset
            }
        } else {
            return 0
        }
    }
}

// MARK: - UICollectionViewDataSource

extension InfiniteCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = infiniteDataSource?.numberOfItems(self) ?? 0
        return 3 * numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let usableRow = correctedIndex(indexPath.row - indexOffset)
        let usableIndexPath = IndexPath(row: usableRow, section: 0)
        return infiniteDataSource!.cellForItem(self, dequeue: indexPath, usable: usableIndexPath)
    }
}
