//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/23/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private var didSetupConstraints: Bool = false
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var baseURL: URL {
        guard let url = URL(string: "https://calendarific.com/api/v2/") else {
            fatalError("Failed to create URL")
        }
        
        return url
    }
    
    private var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Demo"
        view.backgroundColor = .white
        
        layoutUI()
        loadCountries()
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    private func loadCountries() {
        let request = APIRequest(method: .get, path: "countries")
        request.queryItems = [URLQueryItem(name: "api_key", value: Credentials.apiKey)]
        APIClient(baseURL: baseURL).perform(request) { [weak self] (result) in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.decode(to: CountryResponse.self)
                    self?.setCountries(decodedResponse.body.countries)
                } catch let error as APIError {
                    self?.showAlert(withMessage: error.localizedDescription)
                } catch {
                    self?.showAlert(withMessage: error.localizedDescription)
                }
            case .failure(let error):
                self?.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func setCountries(_ countries: [Country]) {
        self.countries = countries
        tableView.reloadData()
    }
    
    private func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        let country = countries[indexPath.row]
        cell.textLabel?.text = String(format: "%@ - %@", country.countryName, String(country.totalHolidays))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

