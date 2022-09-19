//
//  MainVC.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 06.09.2022.
//

import UIKit
import Parchment

class MainVC: UIViewController, XGSAlertVCDelegate {
    
    let regions: [Region] = [.argentina, .turkey]
    
    var storeVCs = [XGSStoreVC]()
    let pagingVC = PagingViewController()
    var settingsButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configurePagingVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AppSettingsManager.shared.convertToRubles {
            getExchangeRate()
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = K.Colors.backgroundColor
        
        settingsButton = UIBarButtonItem(image: K.SFSymblos.rubles, menu: generatePullDownMenu())
        settingsButton.tintColor = K.Colors.tintColor
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func configurePagingVC() {
        addChild(pagingVC)
        pagingVC.didMove(toParent: self)
        
        view.addSubview(pagingVC.view)
        pagingVC.dataSource = self
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        pagingVC.backgroundColor = K.Colors.backgroundColor
        pagingVC.menuBackgroundColor = K.Colors.backgroundColor
        pagingVC.selectedBackgroundColor = K.Colors.backgroundColor
        
        pagingVC.indicatorColor = K.Colors.tintColor
        pagingVC.indicatorOptions = .visible(height: 3, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        pagingVC.menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
        
        pagingVC.textColor = .secondaryLabel
        pagingVC.selectedTextColor = .label
        
        pagingVC.borderColor = K.Colors.cardColor
        pagingVC.borderOptions = .visible(height: 1, zIndex: Int.max - 1, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                
        NSLayoutConstraint.activate([
            pagingVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateUI(with exchangeRate: ExchangeRate) {
        DispatchQueue.main.async {
            self.settingsButton.menu = self.generatePullDownMenu()
        }

        for storeVC in storeVCs {
            switch storeVC.region {
            case .argentina:
                storeVC.exchangeRate = exchangeRate.rates.ARS
            case .turkey:
                storeVC.exchangeRate = exchangeRate.rates.TRY
            }

            DispatchQueue.main.async {
                storeVC.collectionView.reloadData()
            }
        }
    }
    
    private func generatePullDownMenu() -> UIMenu {
        let rublesAction = UIAction(title: "Цены в рублях", state:  AppSettingsManager.shared.convertToRubles ? .on : .off) { _ in
            self.getExchangeRate()
        }
        
        let originalCurrencyAction = UIAction(title: "Цены в валюте региона", state:  AppSettingsManager.shared.convertToRubles ? .off : .on) { _ in
            AppSettingsManager.shared.convertToRubles = false
            self.settingsButton.menu = self.generatePullDownMenu()
            
            for storeVC in self.storeVCs {
                storeVC.collectionView.reloadData()
            }
        }
        
        let menu = UIMenu(title: "Конвертация в рубли по данным сервиса exchangerate.host", children: [rublesAction, originalCurrencyAction])
        
        return menu
    }
    
    private func getExchangeRate() {
        NetworkManager.shared.getExchangeRate { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let exchangeRate):
                AppSettingsManager.shared.convertToRubles = true
                self.updateUI(with: exchangeRate)
                
            case .failure(let error):
                AppSettingsManager.shared.convertToRubles = false
                self.presentXGSAlert(title: "О нет!", message: error.localizedDescription, buttonTitle: "Окей")
            }
        }
    }
}

extension MainVC: PagingViewControllerDataSource {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return regions.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let storeVC = XGSStoreVC(region: regions[index])
        storeVCs.append(storeVC)
        
        return storeVC
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: regions[index].rawValue)
    }
}
