//
//  SeatSelectionViewController.swift
//  FlightSeatSelection
//
//  Created by Vimal on 04/07/23.
//

import UIKit


class BusViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let totalSeats = 52
    let columns = 4
    let seatsPerRow = 2
    
    var seats: [Seat] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SeatCollectionViewCell.self, forCellWithReuseIdentifier: "SeatCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "driverCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the seats with empty status
        for seatNumber in 1...totalSeats {
            let seat = Seat(seatNumber: "\(seatNumber)", status: .empty)
            seats.append(seat)
        }
        
        // Load sample data from JSON
        if let jsonData = loadSampleData() {
            let decodedSeats = parseJSONData(jsonData)
            
            // Update the seat status based on the decoded data
            for decodedSeat in decodedSeats {
                if let seatIndex = seats.firstIndex(where: { $0.seatNumber == decodedSeat.seatNumber }) {
                    seats[seatIndex].status = decodedSeat.status
                    print(decodedSeat.status)
                }
            }
        }
        view.addSubview(collectionView)
        
    }
    
    // MARK: - Data Loading
        
    func loadSampleData() -> Data? {
        if let path = Bundle.main.path(forResource: "sample", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                print("Error loading sample data: \(error)")
            }
        }
        return nil
        
    }
    
    func parseJSONData(_ jsonData: Data) -> [Seat] {
        do {
            let jsonDecoder = JSONDecoder()
            let seats = try jsonDecoder.decode([Seat].self, from: jsonData)
            return seats
        } catch {
            print("Error parsing JSON data: \(error)")
        }
        return []
        
    }
    
    // Helper function to check if a seat is occupied
    func isSeatOccupied(at index: Int) -> Bool {
        if case .occupied(_) = seats[index].status {
            return true
        } else {
            return false
        }
    }
    // MARK: - UICollectionViewDataSource,UICollectionViewDelegate
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // First section has only one item for the image
        } else {
            return seats.count // Second section has the seat options
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // First section cell with the image
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "driverCell", for: indexPath)
            
            // Configure the cell with the image
            let imageView = UIImageView(image: UIImage(named: "hands"))
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: cell.bounds.width - 120, y: 10, width: 60, height: 60) // Adjust the frame as needed
            cell.addSubview(imageView)
            return cell
        }else {
            // Second section cell for seat selection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! SeatCollectionViewCell
            let seat = seats[indexPath.item]
            cell.configure(with: seat)
            return cell
        }
    }
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let seat = seats[indexPath.item]
            
            switch seat.status {
            case .empty:
                seat.status = .selected(gender: .male)
            case .selected:
                seat.status = .empty
            case .occupied:
                if isSeatOccupied(at: indexPath.item) {
                    // Seat is occupied, cannot be selected
                    return
                }
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            // Size for the first section (image)
            let cellWidth = collectionView.bounds.width
            let cellHeight: CGFloat = 90 // Adjust the height as needed
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            // Size for the second section (seat options)
            let totalGapWidth = CGFloat(columns - 1) * 10 // Adjust the spacing as needed
            let availableWidth = collectionView.bounds.width - totalGapWidth
            let cellWidth = availableWidth / CGFloat(columns)
            let cellHeight = collectionView.bounds.height / CGFloat(totalSeats / columns)
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
    }
}



// Helper function to get the indices of adjacent seats
//    func getAdjacentSeats(at index: Int) -> [Int] {
//        var adjacentSeats: [Int] = []
//        let row = index / columns
//        let column = index % columns
//
//        if column > 0 {
//            adjacentSeats.append(index - 1) // Left seat
//        }
//        if column < columns - 1 {
//            adjacentSeats.append(index + 1) // Right seat
//        }
//        if row > 0 {
//            adjacentSeats.append(index - columns) // Seat above
//        }
//        if row < totalSeats / columns - 1 {
//            adjacentSeats.append(index + columns) // Seat below
//        }
//
//        return adjacentSeats
//    }
//
// Helper function to get the indices of selected seats
//    func getSelectedSeats(for gender: Gender? = nil) -> [Int] {
//        return seats.enumerated().compactMap { index, seat in
//            if case let .selected(seatGender) = seat.status {
//                if let gender = gender {
//                    return seatGender == gender ? index : nil
//                } else {
//                    return index
//                }
//            }
//            return nil
//        }
//    }

//    // Helper function to determine the gender of the seat to be selected
//    func seatToBeSelectedGender(at index: Int, selectedSeats: [Int]) -> Gender? {
//        let adjacentSeats = getAdjacentSeats(at: index)
//
//        for adjacentIndex in adjacentSeats {
//            if selectedSeats.contains(adjacentIndex) {
//                let adjacentSeat = seats[adjacentIndex]
//                if case let .selected(seatGender) = adjacentSeat.status {
//                    return seatGender == .male ? .female : .male
//                }
//            }
//        }
//
//        return nil
//    }

// Helper function to select a seat with a specific gender
//    func selectSeat(at index: Int, with gender: Gender) {
//        seats[index].status = .selected(gender: gender)
//    }
