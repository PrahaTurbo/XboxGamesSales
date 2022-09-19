//
//  XGSImageViewerVC.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 16.09.2022.
//

import UIKit

class XGSImageViewerVC: XGSDataLoadingVC {
    
    var imageScrollView = XGSImageScrollView()
    var closeButton = UIButton()
    
    var imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadImage(fromURL: imageUrl)
        configureBackgroundView()
        configureImageScrollView()
        configureCloseButton()
    }
    
    private func configureBackgroundView() {
        view.backgroundColor = .black
    }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        closeButton.setImage(K.SFSymblos.xmark, for: .normal)
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor)
        ])
    }

    private func configureImageScrollView() {
        imageScrollView = XGSImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.pinToEdges(of: view)
    }
    
    private func downloadImage(fromURL urlString: String?) {
        guard let urlString = urlString else { return }
        
        showLoadingView()
        activityIndicator.color = .white
                
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] image in
            guard let self = self else { return }
            guard let image = image else { return }
    
            self.dismissLoadingView()
            
            DispatchQueue.main.async {
                self.activityIndicator.style = .medium
                self.imageScrollView.set(image: image)
            }
        }
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
