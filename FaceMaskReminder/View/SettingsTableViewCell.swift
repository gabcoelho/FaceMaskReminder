//
//  SettingsTableViewCell.swift
//  FaceMaskReminder
//
//  Created by Gabriela Coelho on 16/10/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsTableViewCell: UITableViewCell {

    private var type: SwitchType?
    private var dependenciesManager: DependenciesManager?
    
    private lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var settingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.3921568627, green: 0.5843137255, blue: 0.5607843137, alpha: 1)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var settingEnablerSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
        return switchButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(icon: String, type: SwitchType, dependencies: DependenciesManager?) {
        settingsLabel.text = type.rawValue
        iconImageView.image = UIImage(named: icon)
        dependenciesManager = dependencies
        self.type = type
        setupSwitchForType()
    }
    
    @objc func didToggleSwitch() {
//        updateAuthorizations()
    }
    
    private func setupSwitchForType() {
        guard let type = type else { return }
        switch type {
        case .notification:
            dependenciesManager?.notificationDelegate = self
            verifyNotificationAuthorizationStatus()
        case .location:
            dependenciesManager?.locationDelegate = self
            settingEnablerSwitch.isOn = verifyLocationAuthorizationStatus()
        }
    }

    private func updateAuthorizations() {
        guard let type = type else { return }
        switch type {
        case .notification:
            if settingEnablerSwitch.isOn == false { UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["attention"])
            }
        case .location: break
//            dependenciesManager?.locationManager?.requestLocation()
        }
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(settingsLabel)
        contentView.addSubview(settingEnablerSwitch)
        setupConstraints()
        backgroundColor = UIColor(named: "backgroundColor")
    }
    
    private func setupConstraints() {
        iconImageView.anchor(
            left: contentView.leftAnchor,
            leftConstant: 10,
            widthConstant: 35,
            heightConstant: 35
        )
        iconImageView.anchorCenterYToSuperview()
        
        settingsLabel.anchor(
            left: iconImageView.rightAnchor,
            leftConstant: 10
        )
        settingsLabel.anchorCenterYToSuperview()

        settingEnablerSwitch.anchor(
            right: contentView.rightAnchor,
            rightConstant: 10
        )
        settingEnablerSwitch.anchorCenterYToSuperview()
    }
    
    
    private func verifyNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    self.settingEnablerSwitch.isOn = true
                }
            case .denied, .notDetermined, .ephemeral:
                DispatchQueue.main.async {
                    self.settingEnablerSwitch.isOn = false
                }
            @unknown default:
                DispatchQueue.main.async {
                    self.settingEnablerSwitch.isOn = false
                }
            }
        }
    }
    
    private func verifyLocationAuthorizationStatus() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse, .restricted:
            dependenciesManager?.locationManager?.startMonitoringVisits()
            dependenciesManager?.locationManager?.startUpdatingLocation()
            dependenciesManager?.locationManager?.allowsBackgroundLocationUpdates = true
            dependenciesManager?.locationManager?.pausesLocationUpdatesAutomatically = false
            return true
        case .notDetermined, .denied:
            return false
        default: return false
        }
    }

}

extension SettingsTableViewCell: LocationAuthorization {
    func updateLocationAuthorization() {
        DispatchQueue.main.async {
            self.settingEnablerSwitch.isOn = self.verifyLocationAuthorizationStatus()
        }
    }
}

extension SettingsTableViewCell: NotificationAuthorization {
    func updateNotificationAuthorization() {
        verifyNotificationAuthorizationStatus()
    }
    
    func newLocationReceived() {
        if type == .notification && settingEnablerSwitch.isOn {
            let content = UNMutableNotificationContent()
            content.title = "Atenção!"
            content.body = "Percebemos que você está saindo, lembrou de pegar uma máscara?"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.30, repeats: false)
            let request = UNNotificationRequest(identifier: "attention", content: content, trigger: trigger)
            
            dependenciesManager?.center?.add(request, withCompletionHandler: nil)
        }
    }
}
