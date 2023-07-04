# BusSeatSelection


![Simulator Screenshot - iPhone 14 Pro - 2023-07-04 at 22 44 31](https://github.com/vimalbosamia/BusSeatSelection/assets/12189623/e3610404-4091-4c5b-af0a-3d5e1ae45d91)


The `BusViewController` class represents a view controller responsible for displaying a bus seating arrangement. It conforms to the `UIViewController`, `UICollectionViewDataSource`, and `UICollectionViewDelegateFlowLayout` protocols.

The class has properties to define the total number of seats (`totalSeats`), the number of columns in the seating arrangement (`columns`), the number of seats per row (`seatsPerRow`), and an array of `Seat` objects (`seats`) to store the seat statuses.

The class contains a `collectionView` property, which is a UICollectionView responsible for displaying the seating arrangement. It is configured with a custom layout and registered cell classes for seat cells and an image cell.

In the `viewDidLoad` method, the seats are initialized with an empty status, and sample data is loaded from a JSON file. The seat statuses are updated based on the loaded data.

The class includes helper methods to load sample data from JSON (`loadSampleData`) and parse the JSON data into an array of `Seat` objects (`parseJSONData`).

The class implements the necessary methods from the `UICollectionViewDataSource` protocol to populate the collection view with cells. It configures the first section cell with an image and the second section cells with seat options. The cell configuration includes setting up the image view for the image cell and configuring the seat cell with the corresponding seat object.

The class also implements the necessary methods from the `UICollectionViewDelegateFlowLayout` protocol to provide sizing information for the collection view cells. The first section cell is sized to fill the entire width and have a fixed height. The second section cells are sized based on the available width, total gap width, and the number of rows in the seating arrangement.

Additionally, there is a helper function `isSeatOccupied` to check if a seat is occupied based on its status.

When a seat cell is selected in the second section, the seat status is toggled between empty and selected, except for occupied seats. The collection view is then reloaded to reflect the updated seat status.

Overall, the `BusViewController` class manages the bus seating arrangement, loads data, displays cells in the collection view, handles seat selection, and adjusts the cell sizes based on the seating arrangement layout.
