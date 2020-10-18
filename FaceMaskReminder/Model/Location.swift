//
//  Location.swift
//  FaceMaskReminder
//
//  Created by Gabriela Coelho on 16/10/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import Foundation
import CoreLocation

class Visit: CLVisit {
    
    private let myCoordinates: CLLocationCoordinate2D
    private let myArrivalDate: Date
    private let myDepartureDate: Date

    override var coordinate: CLLocationCoordinate2D {
      return myCoordinates
    }
    
    override var arrivalDate: Date {
      return myArrivalDate
    }
    
    override var departureDate: Date {
      return myDepartureDate
    }
    
    init(coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date) {
      myCoordinates = coordinates
      myArrivalDate = arrivalDate
      myDepartureDate = departureDate
      super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
