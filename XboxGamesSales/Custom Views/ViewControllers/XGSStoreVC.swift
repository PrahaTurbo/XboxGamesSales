//
//  XGSStoreVC.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 29.08.2022.
//

import UIKit

class XGSStoreVC: XGSDataLoadingVC {
    
    enum Section {
        case main
    }
    
    var deals = [Deal]()
    var page = 1
    var lastPageNumber = 0
    var isLoadingMoreDeals = false
    var moreDealsAvailable = true
    var exchangeRate: Double = 1.0
    var region: Region
    var currencySymbol: String {
        return AppSettingsManager.shared.convertToRubles ? K.CurrencySymbols.rubles : region.currencySymbol
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Deal>!
    var refreshControl = UIRefreshControl()

    init(region: Region) {
        self.region = region
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLastPageNumber()
        configureViewController()
        configureCollectionView()
        configureRefreshControl()
        configureDataSource()
        getDeals()
    }
    
    private func configureViewController() {
        view.backgroundColor = K.Colors.backgroundColor
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = K.Colors.backgroundColor
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        collectionView.register(GoldDealCell.self, forCellWithReuseIdentifier: GoldDealCell.reuseID)
        collectionView.register(DefaultDealCell.self, forCellWithReuseIdentifier: DefaultDealCell.reuseID)
        
        collectionView.pinToEdges(of: view)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, deal in
            var cell = DealCell()
            
            if deal.discountWithGold {
                guard let goldDealcell = collectionView.dequeueReusableCell(withReuseIdentifier: GoldDealCell.reuseID, for: indexPath) as? GoldDealCell else {
                    return UICollectionViewCell()
                }
                
                cell = goldDealcell
            } else {
                guard let orinaryDealCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultDealCell.reuseID, for: indexPath) as? DefaultDealCell else {
                    return UICollectionViewCell()
                }
                
                cell = orinaryDealCell
            }
                        
            cell.set(deal: deal, currencySymbol: self.currencySymbol, exchangeRate: self.exchangeRate)
            return cell
        }
    }
    
    private func updateUI(with deals: [Deal]) {
        if lastPageNumber != 0 {
            moreDealsAvailable = lastPageNumber > page
        }
        
        self.deals.append(contentsOf: deals)
        
        if self.deals.isEmpty {
            let message = "В этом регионе скидок сейчас нет 😔"
            DispatchQueue.main.async { self.view.showEmptyStateView(with: message) }
            return
        }
        
        updateData(on: self.deals)
    }
    
    private func getDeals() {
        isLoadingMoreDeals = true
        
        if page == 1 && !refreshControl.isRefreshing {
            showLoadingView()
        }
        
        NetworkManager.shared.getDeals(region: region, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            DispatchQueue.main.async { self.refreshControl.endRefreshing() }
            
            switch result {
            case .success(let deals):
                self.updateUI(with: deals)

            case .failure(let error):
                self.presentXGSAlert(title: "О нет!", message: error.localizedDescription, buttonTitle: "Повторить")
            }
            
            self.isLoadingMoreDeals = false
        }
    }
    
    private func getLastPageNumber() {
        NetworkManager.shared.getLastPageNumber(region: region) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let lastPageNumber):
                self.lastPageNumber = lastPageNumber
                
            case .failure(let error):
                self.presentXGSAlert(title: "О нет!", message: error.localizedDescription, buttonTitle: "Повторить")
            }
        }
    }
    
    private func updateData(on deals: [Deal]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Deal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(deals)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func handleRefreshControl() {
        deals.removeAll()
        page = 1
        getDeals()
    }
}


extension XGSStoreVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == deals.count - 10 {
            guard moreDealsAvailable, !isLoadingMoreDeals else { return }
            page += 1
            getDeals()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deal = deals[indexPath.item]
        let destinationVC = GameInfoVC(deal: deal, currencySymbol: currencySymbol, exchangeRate: exchangeRate)
        let navigationController = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DealCell {
            cell.alpha = 0.5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DealCell {
            cell.alpha = 1
        }
    }
}


extension XGSStoreVC: XGSAlertVCDelegate {
    func didTapActionButton() {
        if lastPageNumber == 0 {
            getLastPageNumber()
        } else {
            getDeals()
        }
    }
}


