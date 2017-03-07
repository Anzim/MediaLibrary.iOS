//
//  FirstScreenViewController.swift
//  Cooking
//
//  Created by Andriy Zymenko on 10/7/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {
    @IBOutlet weak var BackgroundImage: UIImageView!

    @IBOutlet weak var TopCircleCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var CenterCircleCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var BottomCircleCenterYConstraint: NSLayoutConstraint!

    @IBOutlet weak var TopCircleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var CenterCircleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var BottomCircleHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var BackgroundImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var BackgroundImageWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var TopCircleButton: RoundButton!
    @IBOutlet weak var CenterCircleButton: RoundButton!
    @IBOutlet weak var BottomCircleButton: RoundButton!

    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)

        // Do any additional setup after loading the view.

        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
            guard let this = self else { return }

            this.BackgroundImage.image = UIImage(named: "first_screen_bg")
            this.BackgroundImageWidthConstraint.constant = 81
            this.BackgroundImageHeightConstraint.constant = 150

            DispatchQueue.main.async { [weak self] in
                guard let this = self else { return }
                this.TopCircleCenterYConstraint.constant = 20
                this.CenterCircleCenterYConstraint.constant = 20
                this.BottomCircleCenterYConstraint.constant = 20

                this.TopCircleHeightConstraint.constant = 172
                this.CenterCircleHeightConstraint.constant = 172
                this.BottomCircleHeightConstraint.constant = 172

                this.TopCircleButton.alpha = 1
                this.CenterCircleButton.alpha = 1
                this.BottomCircleButton.alpha = 1

                this.BackgroundImageWidthConstraint.constant = 40.5
                this.BackgroundImageHeightConstraint.constant = 75

                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.33, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations:
                {
                    self?.view?.layoutIfNeeded()

                }) { (done) in
                    print("Animation done")
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    static let segues = ["FirstSreenToPlayCSTab": 0,
                         "FirstSreenToSeeCSTab": 1,
                         "FirstSreenToCSStreamTab": 2,
                         "FirstSreenToTabBarVC": -1]
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationTabBarController = segue.destination as? UITabBarController,
            let segueId = segue.identifier,
            let index = FirstScreenViewController.segues[segueId], index >= 0
        {
                destinationTabBarController.selectedIndex = index
        }
    }


}
