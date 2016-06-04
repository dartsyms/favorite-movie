//
//  SearchVC.swift
//  FavoriteMovie
//
//  Created by sanchez on 16.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    // for movie search
    var movies: [MovieItem] = [MovieItem]()
    var filteredMovies: [MovieItem] = [MovieItem]()
    var shouldShowSearchResults = false
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var selectedMovieID = ""
    
    var searchString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "white_smoke_bkgrnd.jpg"))
        
        if self.searchString != "" {
            loadMovieList(self.searchString)
        }
        
        configureSearchController()
        tableView.reloadData()
    }
    
    func loadMovieList(searchTitle: String) {
        
        let methodParameters = [
            "s": searchTitle,
            "r": "json"
        ]
        
        let urlString = appDelegate.baseURLString + appDelegate.escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                print("Could not complete the request \(error)")
            } else {
                let parsingError: NSError? = nil
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                
                if let error = parsingError {
                    print("Could not parse the data \(error)")
                } else {
                    if let results = parsedResult["Search"] as? [[String : AnyObject]] {
                        self.movies = MovieItem.moviesFromResults(results)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Could not find results in \(parsedResult)")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableView methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
        
        let backgroundImage = cellBackgroundForRowAtIndexPath(indexPath)!
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.alpha = 0.7
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = backgroundImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = CGRectMake(0, 0, cell.bounds.width, cell.bounds.height)
        backgroundImageView.addSubview(visualEffectView)
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredMovies[indexPath.row].title
            cell.detailTextLabel?.text = filteredMovies[indexPath.row].releaseDate
        }
        else {
            cell.textLabel?.text = movies[indexPath.row].title
            cell.detailTextLabel?.text = movies[indexPath.row].releaseDate
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredMovies.count
        }
        else {
            return movies.count
        }
    }
    
    // MARK: - TableViewCell helper method
    
    func cellBackgroundForRowAtIndexPath(indexPath: NSIndexPath) -> UIImage? {
        let rowCount = tableView.numberOfRowsInSection(0)
        let rowIndex = indexPath.row
        var background: UIImage?
        
        if (rowIndex == 0) {
            background = UIImage(named: "cell_top.png")
        } else if (rowIndex == rowCount - 1) {
            background = UIImage(named: "cell_bottom.png")
        } else {
            background = UIImage(named: "cell_middle.png")
        }
        
        return background
    }
    
    // MARK: - SearchController methods
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        if searchString != "" {
            searchController.searchBar.text = searchString
        } else {
            searchController.searchBar.placeholder = "Enter Search Title..."
        }
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if let startSearchButton = searchBar.valueForKey("cancelButton") as? UIButton {
            startSearchButton.setTitle("Done", forState: UIControlState.Normal)
            startSearchButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
        
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        if let startSearchButton = searchBar.valueForKey("cancelButton") as? UIButton {
            startSearchButton.setTitle("Done", forState: UIControlState.Normal)
            startSearchButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
        
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            loadMovieList(searchText)
            // Filter the data array and get only those movies that match the search text.
//            filteredMovies = movies.filter({ (movie) -> Bool in
//                let movieText: NSString = movie.title
//                return (movieText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
//            })
            tableView.reloadData()
        }
//        // Reload the tableview.
//        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadMovieList(searchText)
        tableView.reloadData()
    }

}
