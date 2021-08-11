# MyGiphy Application

## About
This is a simple iOS application that fetch trending gifs, searched gifs, and favourite them.

## Purpose
This application is to implement important fundamentals of iOS using Swift.

## Installation and configuration
You can clone/download the repository and build the project. The project is built in <b>XCode 12.3</b><br>

## Documentation

### Design Pattern
MVVM

### Requirement
The application consists of a <b> Tab Bar </b> consisting of the following tabs:

#### Feeds Tab:
• Contains a search bar at the top. <br>
• Contains a table view that displays searched gifs. <br>
• Loading indicator while searching. <br>
• The default items in the table view shows the trending gifs (if nothing in search bar) <br>
##### Gif TableView Cell
• Contains a view of the gif running
• Contains a favourite button which allows favouriting and unfavouriting
• The favourited items are stored locally on the device

#### Favourite Tab:
• Contains a collection view that displays a grid of favourited gifs stored locally <br>
##### Gif CollectionView Cell
• Contains a view of the gif running
• Contains an unfavourite button

### Additional Implementation
• <b>DataStore: </b> Helps maintain single source of truth for the data stored locally. <br>
• <b> Combine </b> (Alternative for RxSwift). <br>
• <b> Pagination: </b> The feeds page loads 10 gifs initially and then implements pagination.

### Areas of Improvement
• The logic of download of gifs can be improved. <br>

### Video
[MyGiphy Demo Video](https://drive.google.com/file/d/1MKhQkVYj7qjow8SPGlFsaReWgQPvhM-G/view?usp=sharing)
