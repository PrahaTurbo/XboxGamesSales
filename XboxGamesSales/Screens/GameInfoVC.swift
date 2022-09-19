//
//  GameInfoVC.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 09.09.2022.
//

import UIKit
import SafariServices

class GameInfoVC: UIViewController, XGSAlertVCDelegate {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var headerView: XGSHeaderView!
    var pricesView: XGSPricesView!
    var screenshotsView: XGSScreenshotsView!
    
    var gameInfo: GameInfo!
    var deal: Deal
    var currencySymbol: String
    var exchangeRate: Double
    
    init(deal: Deal, currencySymbol: String, exchangeRate: Double) {
        self.deal = deal
        self.currencySymbol = currencySymbol
        self.exchangeRate = exchangeRate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGameInfo()
        configureViewController()
        configureScrollView()
        configureUIElements()
        layoutUI()
    }
    
    private func configureViewController() {
        view.backgroundColor = K.Colors.backgroundColor
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func configureUIElements() {
        headerView = XGSHeaderView(deal: deal)
        pricesView = XGSPricesView(deal: deal, currencySymbol: currencySymbol, exchangeRate: exchangeRate, delegate: self)
        screenshotsView = XGSScreenshotsView(deal: deal, delegate: self)
    }
    
    private func layoutUI() {
        contentView.addSubviews(headerView, pricesView, screenshotsView)

        let padding: CGFloat = 10
        let sectionsPadding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 140),
            
            pricesView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: sectionsPadding),
            pricesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            pricesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            pricesView.heightAnchor.constraint(equalToConstant: 64),
            
            screenshotsView.topAnchor.constraint(equalTo: pricesView.bottomAnchor, constant: sectionsPadding),
            screenshotsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            screenshotsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            screenshotsView.heightAnchor.constraint(equalToConstant: 189)
        ])
    }
    
    private func getGameInfo() {
        NetworkManager.shared.getGameInfo(from: deal.url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let gameInfo):
                self.gameInfo = gameInfo
                self.screenshotsView.updateUI(with: gameInfo.screenshotUrls)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

extension GameInfoVC: XGSPricesViewDelegate {
    
    func didTapStoreButton() {
        guard let storeUrl = gameInfo?.storeUrl, let url = URL(string: storeUrl) else {
            presentXGSAlert(title: "Упс!", message: "Не удалось открыть Microsoft Store.", buttonTitle: "Жаль")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        
        present(safariVC, animated: true)
    }
}

extension GameInfoVC: XGSScreenshotsViewDelegate {
    
    func didTapImage(urlString: String) {
        let destinationVC = XGSImageViewerVC(imageUrl: urlString)
        destinationVC.modalPresentationStyle = .fullScreen
        destinationVC.modalTransitionStyle = .crossDissolve
        present(destinationVC, animated: true)
    }
}
