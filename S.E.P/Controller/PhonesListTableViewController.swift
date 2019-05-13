//
//  TableViewController.swift
//  S.E.P
//
//  Created by Artem Golovanev on 11.05.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import UIKit

class PhonesListTableViewController: UITableViewController, UISearchResultsUpdating {
    var refresh: UIRefreshControl!
    var searchController: UISearchController!
    var phones: [DataModel] = []
    var searchResult: [DataModel] = []
    var isNavigationBarHidden: Bool = false
    var api = APIManager()

    override func loadView() {
        super.loadView()
        loadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCellPhones", bundle: nil),
        forCellReuseIdentifier: "customCell")
        settingsBar()
        setSearching()
        settingsNavigation()
        connectionErrorAlert()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        connectionErrorAlert()
        if self.phones.isEmpty {
            loadData()
        }
    }

    private func connectionErrorAlert() {
        let time = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: time) {
            if self.phones.isEmpty {
                let alert = UIAlertController(title: "", message: "Sorry. Internet connection lost", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
            }

        }
    }

   @objc private func handlePostBtn() {
        let isUploaded = api.uploadPhones(phonesArray: phones)
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            if isUploaded == true {
                let alert = UIAlertController(title: "", message: "Successfully", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
            }
            else {
                let alert = UIAlertController(title: "", message: "Sorry. Internet connection lost", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
            }
        }
    }

    private func settingsNavigation() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.title = "Phones List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePostBtn))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.customMilkWhite
    }
    private func settingsBar() {
        navigationController?.hidesBarsOnSwipe = false
        isNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func setSearching() {
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.customDark
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.keyboardAppearance = .dark
    }

    private func loadData() {
        self.api.getPhones { (data, error) in
            if let error = error {
                print("Get  error: \(error.localizedDescription)")
                return
            }
            guard let data = data  else {
                return
            }
            print("Current  Object:")
            self.phones = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCellPhones
        let phns = (searchController.isActive) ? searchResult[indexPath.row]: phones[indexPath.row]
        if let imageURL = URL(string: phns.imagePhone) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imageViewPhones.image = image
                    }
                }
            }
        }
        cell.labelPhonesName.text = phns.namePhone
        cell.labelPricePhone.text = phns.pricePhone
        cell.descr = phns.descriptionPhone
        return cell
    }

    internal override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = (searchController.isActive) ? searchResult[indexPath.row]: phones[indexPath.row]
        let selectedPhone = DetailViewController()
        if let imageURL = URL(string: phones[indexPath.row].imagePhone) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            selectedPhone.detailView.phoneImageView.image = image
                        }
                    }
                }
            }
        selectedPhone.detailView.labelPhoneName.text = cell.namePhone
        selectedPhone.detailView.labelPhoneDescription.text = cell.descriptionPhone
        selectedPhone.detailView.labelPhonePrice.text = cell.pricePhone
        selectedPhone.concretetPhone = cell
        navigationController?.pushViewController(selectedPhone, animated: true)
        }
}

extension PhonesListTableViewController {

    internal override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->
    CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt
    indexPath: IndexPath) {
        let transform = CATransform3DTranslate(CATransform3DIdentity, 500, 500, 100)
        cell.layer.transform = transform
        UIView.animate(withDuration: 0.9, animations: { cell.layer.transform =
        CATransform3DIdentity })
    }

    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResult.count
        }
        else {
            return phones.count
        }
    }
}

extension PhonesListTableViewController {

    internal override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }

     private func filterContent(searchText:String) {
        searchResult = phones.filter({ (phn:DataModel) -> Bool in
            let filterByName = phn.namePhone.range(of: searchText, options:
            String.CompareOptions.caseInsensitive)
            return filterByName != nil
        })
    }

    internal func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            tableView.reloadData()
        }
    }
}
 
