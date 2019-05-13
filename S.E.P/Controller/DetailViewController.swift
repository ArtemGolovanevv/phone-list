//
//  DetailViewController.swift
//  S.E.P
//
//  Created by Artem Golovanev on 12.05.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    let api = APIManager()
    var concretetPhone: DataModel! = nil
    let detailView: DetailView = {
        let view = DetailView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.detailViewController = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post Concretet", style: .plain, target: self, action: #selector(handlePostBtn))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.customMilkWhite
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        detailView.scrollView.alpha = 0.50
    }

    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          detailView.scrollView.alpha = 1.0
    }

    @objc private func handlePostBtn() {
        let isUploaded = api.uploadPhones(phonesArray: [concretetPhone])
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            if !isUploaded || self.concretetPhone == nil {
                let alert = UIAlertController(title: "", message: "Sorry. Internet connection lost", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
            }
            else {
                let alert = UIAlertController(title: "", message: "Successfully", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
            }
        }
    }
}

