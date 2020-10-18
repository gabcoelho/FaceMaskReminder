//
//  SettingsData.swift
//  FaceMaskReminder
//
//  Created by Gabriela Coelho on 17/10/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import Foundation

enum SwitchType: String {
    case location = "Ativar Localização"
    case notification = "Ativar Notificações"
}

struct SettingsData {
    let type = [SwitchType.location, SwitchType.notification]
    let icons = ["location", "notification"]
}

