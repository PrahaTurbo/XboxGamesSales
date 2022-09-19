//
//  UIHelper.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import UIKit

enum UIHelper {
    
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 10
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - minimumItemSpacing
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 90)
        
        return flowLayout
    }
    
    static func createOneRowFlowLayout() -> UICollectionViewFlowLayout {
        let padding: CGFloat = 10

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: 300, height: 169)
        
        return flowLayout
    }
}
