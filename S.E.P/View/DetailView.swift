//
//  DetailView.swift
//  S.E.P
//
//  Created by Artem Golovanev on 12.05.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import Foundation
import UIKit

class DetailView: UIView {

    weak var detailViewController: DetailViewController? {
        didSet {
            setupDetailController()
        }
    }

    let phoneImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let labelPhoneName = UILabel()
    let labelPhonePrice = UILabel()
    let labelPhoneDescription = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        anchors()
    }

    private func setup() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.contentSize.height = 650
        scrollView.contentSize.width = 550
        for label in [labelPhoneName, labelPhoneDescription, labelPhonePrice] {
            label.textColor = UIColor.black
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.text = "Text"
            label.font = UIFont.systemFont(ofSize: 25)
            label.textAlignment = .left
            contentView.addSubview(label)
        }
        labelPhoneDescription.textAlignment = .center
        labelPhoneDescription.font =
        UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .footnote), size: 20)
        labelPhoneName.font =
        UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 25)
        labelPhonePrice.font =
        UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 22)
        contentView.addSubview(phoneImageView)
    }

    private func anchors() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        NSLayoutConstraint.activate([
            phoneImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            phoneImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            labelPhoneName.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelPhoneName.bottomAnchor.constraint(equalTo: labelPhonePrice.topAnchor,
                                                   constant: -10),
            labelPhoneName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            labelPhonePrice.bottomAnchor.constraint(equalTo: phoneImageView.topAnchor,
                                                    constant: -10),
            labelPhonePrice.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            labelPhoneDescription.topAnchor.constraint(equalTo: phoneImageView.bottomAnchor,
                                                       constant: 20 ),
            labelPhoneDescription.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            labelPhoneDescription.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    private func setupDetailController() {
        translatesAutoresizingMaskIntoConstraints = false
        if let detailViewController = detailViewController {
            detailViewController.view.addSubview(self)
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: detailViewController.view.topAnchor),
                bottomAnchor.constraint(equalTo: detailViewController.view.bottomAnchor),
                leftAnchor.constraint(equalTo: detailViewController.view.leftAnchor),
                rightAnchor.constraint(equalTo: detailViewController.view.rightAnchor)
            ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
