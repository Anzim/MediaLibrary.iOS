//
//  PushNoAnimationSegue.swift
//  CookStream
//
//  Created by Andriy Zymenko on 10/25/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit

class PushNoAnimationSegue: UIStoryboardSegue {

    override func perform() {
        let playStreamVC = source as? PlayStreamViewController
        playStreamVC?.stopPlaying()
        source.present(destination, animated: false) {
            playStreamVC?.resumePlaying()
        }
    }
}
