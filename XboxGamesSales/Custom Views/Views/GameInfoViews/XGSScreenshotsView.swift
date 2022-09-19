//
//  XGSScreenshotsView.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 11.09.2022.
//

import UIKit

protocol XGSScreenshotsViewDelegate: AnyObject {
    func didTapImage(urlString: String)
}

class XGSScreenshotsView: UIView {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    var screenshotUrls = [String]()
    
    var deal: Deal
    
    weak var delegate: XGSScreenshotsViewDelegate!
    
    init(deal: Deal, delegate: XGSScreenshotsViewDelegate) {
        self.deal = deal
        self.delegate = delegate
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureBackgroundView()
        configureCollectionView()
        configureDataSource()
    }
    
    private func configureBackgroundView() {
        layer.cornerRadius = 10
        backgroundColor = K.Colors.cardColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: UIHelper.createOneRowFlowLayout())
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: ScreenshotCell.reuseID)
        
        collectionView.pinToEdges(of: self)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, screenshotUrl in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotCell.reuseID, for: indexPath) as? ScreenshotCell else {
                return UICollectionViewCell()
            }
            
            let url = screenshotUrl + "?w=1280&h=720&q=70"
            cell.set(screenshotUrl: url)
            return cell
        }
    }
    
    func updateUI(with screenshotUrls: [String]) {
        self.screenshotUrls = screenshotUrls
        
        if self.screenshotUrls.isEmpty {
            let message = "Скриншотов нет"
            DispatchQueue.main.async { self.showEmptyStateView(with: message) }
            return
        }
        
        updateData(on: self.screenshotUrls)
    }
    
    private func updateData(on screenshotUrls: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(screenshotUrls)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension XGSScreenshotsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let screenshotUrl = screenshotUrls[indexPath.item]
        delegate.didTapImage(urlString: screenshotUrl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
}
