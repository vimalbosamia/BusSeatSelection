//
//  Seat.swift
//  FlightSeatSelection
//
//  Created by Vimal on 04/07/23.
//

import Foundation

import Foundation

enum Gender: String, Codable {
    case male
    case female
}

enum SeatStatus: Codable, Equatable {
    case empty
    case selected(gender: Gender)
    case occupied(gender: Gender)
    
    enum CodingKeys: String, CodingKey {
        case caseType
        case gender
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseType = try container.decode(String.self, forKey: .caseType)
        switch caseType {
        case "empty":
            self = .empty
        case "selected":
            if container.contains(.gender) {
                let gender = try container.decode(Gender.self, forKey: .gender)
                self = .selected(gender: gender)
            } else {
                self = .empty
            }
        case "occupied":
            if container.contains(.gender) {
                let gender = try container.decode(Gender.self, forKey: .gender)
                self = .occupied(gender: gender)
            } else {
                self = .occupied(gender: .male) // Replace .male with the appropriate default gender
            }
        default:
            throw DecodingError.dataCorruptedError(forKey: .caseType, in: container, debugDescription: "Invalid seat status")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .empty:
            try container.encode("empty", forKey: .caseType)
        case .selected(let gender):
            try container.encode("selected", forKey: .caseType)
            try container.encode(gender, forKey: .gender)
        case .occupied(let gender):
            try container.encode("occupied", forKey: .caseType)
            try container.encode(gender, forKey: .gender)
        }
    }
}

class Seat: Codable {
    let seatNumber: String
    var user: String?
    var gender: Gender?
    var status: SeatStatus
    
    enum CodingKeys: String, CodingKey {
        case seatNumber
        case user
        case gender
        case status
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        seatNumber = try container.decode(String.self, forKey: .seatNumber)
        user = try container.decodeIfPresent(String.self, forKey: .user)
        gender = try container.decodeIfPresent(Gender.self, forKey: .gender)
        
        let statusString = try container.decode(String.self, forKey: .status)
        if statusString == "empty" {
            status = .empty
        } else if statusString == "occupied" {
            if let gender = gender {
                status = .occupied(gender: gender)
            } else {
                status = .occupied(gender: .male) // Replace .male with the appropriate default gender
            }
        } else if statusString == "selected" {
            if let gender = gender {
                status = .selected(gender: gender)
            } else {
                status = .empty
            }
        } else {
            throw DecodingError.dataCorruptedError(forKey: .status, in: container, debugDescription: "Invalid seat status")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(seatNumber, forKey: .seatNumber)
        try container.encode(user, forKey: .user)
        try container.encode(gender, forKey: .gender)
        switch status {
        case .empty:
            try container.encode("empty", forKey: .status)
        case .selected(let gender):
            try container.encode("selected", forKey: .status)
            try container.encode(gender, forKey: .gender)
        case .occupied(let gender):
            try container.encode("occupied", forKey: .status)
            try container.encode(gender, forKey: .gender)
        }
    }
    
    init(seatNumber: String, status: SeatStatus) {
        self.seatNumber = seatNumber
        self.status = status
    }
}
