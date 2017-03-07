//
//  VideoContainer.swift
//  CookStream
//
//  Created by Andriy Zymenko on 10/26/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit

//class VideoContainer: UIView, VideoContainerProtocol {
//    weak internal var VideoViewHeightConstraint: NSLayoutConstraint!
//
//    internal var model: PlayStream?
//
//
//}
//
//protocol VideoContainerProtocol: NSObjectProtocol {
//    weak var VideoViewHeightConstraint: NSLayoutConstraint! { get }
//    var VideoViewMargins: CGFloat { get }
//    var model: PlayStream? { get }
//    var view: UIView? { get }
//
//    func adjustVideoSize(superViewSize: CGSize?)
////    func layoutSubviews()
////    func setNeedsLayout()
//}
//
//extension VideoContainerProtocol {
//    var VideoViewMargins: CGFloat { return 8 * 2 }
//    func adjustVideoSize(superViewSize: CGSize?) {
//        guard let playStream = model, let sizeWithMargins = superViewSize else { return }
//        let aspectRatio = playStream.aspectRatio
//
//        let maxHeight = sizeWithMargins.height - VideoViewMargins
//        let maxWidth = sizeWithMargins.width - VideoViewMargins
//
//        var height = maxWidth * aspectRatio
//        //        var width = maxWidth
//
//        if (height > maxHeight) {
//            height = maxHeight
//            //            width = maxHeight / aspectRatio
//        }
//        if (VideoViewHeightConstraint.constant != height) {
//            VideoViewHeightConstraint.constant = height
////            setNeedsUpdateConstraints()
//            view?.setNeedsLayout()
//        }
//    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        adjustVideoSize(superViewSize: superview?.bounds.size)
//    }
//}
