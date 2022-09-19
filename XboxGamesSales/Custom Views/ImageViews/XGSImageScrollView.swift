//
//  XGSImageScrollView.swift
//  XboxGamesSales
//
//  Created by Артем Ластович on 16.09.2022.
//

import UIKit

class XGSImageScrollView: UIScrollView {

    var imageZoomView = UIImageView()
    var zoomingTap = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureScrollView()
        configureZoomingTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: UIImage) {
        imageZoomView = UIImageView(image: image)
        self.addSubview(imageZoomView)
        
        configureImage(imageSize: image.size)
    }
        
    private func configureScrollView() {
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = .fast
    }
    
    private func configureZoomingTap() {
        zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
    }

    private func configureImage(imageSize: CGSize) {
        self.contentSize = imageSize
        
        setCurrentMaxAndMinZoomScale()
        zoomScale = minimumZoomScale
        
        imageZoomView.addGestureRecognizer(zoomingTap)
        imageZoomView.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
    }
    
    private func setCurrentMaxAndMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageZoomView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        minimumZoomScale = minScale
        maximumZoomScale = maxScale
    }
    
    private func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageZoomView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageZoomView.frame = frameToCenter
    }
    
    //Gesture
    
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currentScale = zoomScale
        let minScale = minimumZoomScale
        let maxScale = maximumZoomScale
        
        if minScale == maxScale && minScale > 1 {
            return
        }
        
        let toScale = maxScale
        let finalScale = currentScale == minScale ? toScale : minScale
        let zoomRect = zoomRect(scale: finalScale, center: point)
        
        self.zoom(to: zoomRect, animated: animated)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale

        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)

        return zoomRect
    }
}

extension XGSImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
