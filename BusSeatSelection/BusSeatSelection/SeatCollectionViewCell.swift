//
//  SeatCell.swift
//  FlightSeatSelection
//
//  Created by Vimal on 04/07/23.
//

import UIKit

class SeatCollectionViewCell: UICollectionViewCell {
    let seatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let seatLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(seatImageView)
        contentView.addSubview(seatLabel)
        
        seatImageView.frame = contentView.bounds
        seatImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        seatLabel.frame = contentView.bounds
        seatLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with seat: Seat) {
        seatLabel.text = seat.seatNumber
        
        switch seat.status {
        case .empty:
            seatImageView.image = UIImage(named: "empty")
        case .selected(let gender):
            //contentView.backgroundColor = (gender == .male) ? .blue : .systemPink
            seatImageView.image =  (gender == .male) ? UIImage(named: "male") :   UIImage(named: "female")
        case .occupied(let gender):
            //contentView.backgroundColor = (gender == .male) ? .blue : .systemPink
            seatImageView.image =  (gender == .male) ? UIImage(named: "male") :   UIImage(named: "female")
        }
    }
}
