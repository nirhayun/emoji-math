//
//  CustomAd.swift
//  Emoji math
//
//  Created by Nir Hayun on 13/04/2018.
//  Copyright © 2018 Nir Hayun. All rights reserved.
//

import UIKit

final class CustomAd: UIViewController {

    @IBOutlet private weak var adImage: UIImageView!
    @IBOutlet private weak var adLogo: UIImageView!

    private static let adImageNames = ["ad.anat", "ad.gold"]

    @IBAction private func closeAd(_ sender: Any) {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let index = Int.random(in: 0..<Self.adImageNames.count)
        adImage.image = UIImage(named: Self.adImageNames[index])

        let openAction = index == 1 ? #selector(openFacebookPage) : #selector(openInstagramPage)

        let imageTap = UITapGestureRecognizer(target: self, action: openAction)
        adImage.isUserInteractionEnabled = true
        adImage.addGestureRecognizer(imageTap)

        let logoTap = UITapGestureRecognizer(target: self, action: openAction)
        adLogo.isUserInteractionEnabled = true
        adLogo.addGestureRecognizer(logoTap)
    }

    @objc private func openFacebookPage() {
        if let facebookURL = URL(string: "fb://profile/330248223791084") {
            UIApplication.shared.open(facebookURL, options: [:], completionHandler: nil)
        } else if let webURL = URL(string: "https://www.facebook.com/AnaAestheticst/") {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }

    @objc private func openInstagramPage() {
        guard let instagramURL = URL(string: "instagram://user?username=anat.aesthetics") else {
            if let webURL = URL(string: "https://www.instagram.com/anat.aesthetics/") {
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            }
            return
        }
        if UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else if let webURL = URL(string: "https://www.instagram.com/anat.aesthetics/") {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}
