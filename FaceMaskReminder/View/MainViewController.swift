//
//  ViewController.swift
//  FaceMaskReminder
//
//  Created by Gabriela Coelho on 15/10/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var tableViewIdentifier = "SettingsTableViewCell"
    private var settingsData = SettingsData()
    private var dependencies = DependenciesManager()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "face-mask")
        return imageView
    }()
    
    private lazy var sumButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "up-arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(sumDistanceButton), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.2852856964, green: 0.4291566659, blue: 0.4144926088, alpha: 1)
        return button
    }()
    
    private lazy var substractButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "down-arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(substractDistanceButton), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.2852856964, green: 0.4291566659, blue: 0.4144926088, alpha: 1)
        return button
    }()
    
    private lazy var distanceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Distância máxima permitida(m): "
        label.textColor = #colorLiteral(red: 0.3921568627, green: 0.5843137255, blue: 0.5607843137, alpha: 1)
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.text = "50"
        label.layer.borderColor = UIColor(red: 100/255, green: 149/255, blue: 143/255, alpha: 1).cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.textColor = #colorLiteral(red: 0.3921568627, green: 0.5843137255, blue: 0.5607843137, alpha: 1)
        return label
    }()
    
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = #colorLiteral(red: 0.3921568627, green: 0.5843137255, blue: 0.5607843137, alpha: 1)
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: tableViewIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        additionalConfigurations()
        addSubViews()
        setupConstraints()
        dependencies.setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func additionalConfigurations() {
        navigationController?.navigationBar.topItem?.title = "Bem Vindo!"
        navigationController?.navigationBar.prefersLargeTitles = true
        addingTableViewLayerConfigurations()
    }
    
    @objc func sumDistanceButton() {
        guard let sum = Int(distanceLabel.text ?? "") else { return }
        distanceLabel.text = "\(sum + 10)"
        updateDistanceValue()
    }
    
    @objc func substractDistanceButton() {
        guard let sum = Int(distanceLabel.text ?? "") else { return }
        distanceLabel.text = "\(sum - 10)"
        updateDistanceValue()
    }
    
    func updateDistanceValue() {
        guard let distance = Double(distanceLabel.text ?? "") else { return }
        dependencies.locationManager?.distanceFilter = distance
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsData.type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }

        cell.setupCell(
            icon: settingsData.icons[indexPath.row],
            type: settingsData.type[indexPath.row],
            dependencies: dependencies
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(50)
    }
    
    private func addingTableViewLayerConfigurations() {
        settingsTableView.layer.cornerRadius = 10
        settingsTableView.layer.shadowColor = UIColor.lightGray.cgColor
        settingsTableView.layer.shadowRadius = 5
        settingsTableView.layer.shadowOpacity = 0.25
        settingsTableView.layer.shadowOffset = CGSize(width: 0, height: 5)
        settingsTableView.clipsToBounds = false
        settingsTableView.layer.masksToBounds = false
    }
}

// MARK: - Setup Views

extension MainViewController {
    private func addSubViews() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(logoImageView)
        view.addSubview(settingsTableView)
        view.addSubview(sumButton)
        view.addSubview(substractButton)
        view.addSubview(distanceLabel)
        view.addSubview(distanceDescriptionLabel)
    }
    
    private func setupConstraints() {
        logoImageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            topConstant: 50,
            widthConstant: 150,
            heightConstant: 150
        )
        logoImageView.anchorCenterXToSuperview()
        
        settingsTableView.anchor(
            top: logoImageView.bottomAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            topConstant: 70,
            leftConstant: 20,
            rightConstant: 20,
            heightConstant: 100
        )
        
        distanceDescriptionLabel.anchor(
            top: settingsTableView.bottomAnchor,
            left: settingsTableView.leftAnchor,
            topConstant: 25,
            widthConstant: 180
        )
        
        distanceLabel.anchor(
            top: settingsTableView.bottomAnchor,
            left: distanceDescriptionLabel.rightAnchor,
            topConstant: 25,
            leftConstant: 10,
            widthConstant: 90,
            heightConstant: 50
        )
        
        sumButton.anchor(
            top: settingsTableView.bottomAnchor,
            left: distanceLabel.rightAnchor,
            topConstant: 25,
            leftConstant: 25,
            widthConstant: 25,
            heightConstant: 25
        )
        
        substractButton.anchor(
            top: sumButton.bottomAnchor,
            left: distanceLabel.rightAnchor,
            leftConstant: 25,
            widthConstant: 25,
            heightConstant: 25
        )
    }
    
}
