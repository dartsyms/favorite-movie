//
//  AddMovieVC.swift
//  FavoriteMovie
//
//  Created by sanchez on 16.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//

import UIKit
import CoreData

class AddMovieVC: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieShortDescription: UITextField!
    @IBOutlet weak var movieIMDbLink: UITextField!
    @IBOutlet weak var movieFullDescription: UITextView!
    
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var movies = [MovieItem]()
    var results = [[String : AnyObject]]()
    var movieID = ""
    var moviePosterPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if movieID != "" {
            loadMovieByID(movieID)
            if let posterPath = movies.first?.posterPath {
                loadMoviePosterFromIMDb(posterPath)
            } else {
                self.moviePoster.image = UIImage(named: "white_smoke_bkgrnd.jpg")
            }
        }
        
    }
    
    func loadMoviePosterFromIMDb(path: String) {
        let url = NSURL(string: path)
        let request = NSURLRequest(URL: url!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                print(error)
            } else {
                if let image = UIImage(data: data!) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.moviePoster.image = image
                    }
                }
            }
        }
        task.resume()
    }
    
    func loadMovieByID(searchID: String) {
        
        let methodParameters = [
            "i": searchID,
            "plot": "full",
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
                    if let result = parsedResult as? [String : AnyObject] {
                        self.results.append(result)
                        self.movies = MovieItem.moviesFromResults(self.results)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.movieTitle.text = self.movies.first!.title
                            self.movieShortDescription.text = self.movies.first!.genre
                            self.movieFullDescription.text = self.movies.first!.plot
                            self.movieIMDbLink.text = "http://www.imdb.com/title/\(self.movies.first!.id)/"
                            if let posterPath = self.movies.first?.posterPath {
                                self.loadMoviePosterFromIMDb(posterPath)
                            } else {
                                self.moviePoster.image = UIImage(named: "white_smoke_bkgrnd.jpg")
                            }
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
    
    @IBAction func savePressed(sender: AnyObject) {
        if let title = movieTitle.text where title != "" {
            let context = appDelegate.managedObjectContext
            let entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: context)!
            let movie = Movie(entity: entity, insertIntoManagedObjectContext: context)
            movie.title = title
            movie.fullDescription = movieFullDescription.text
            movie.personalDescription = movieShortDescription.text
            movie.setMoviePosterImage(moviePoster.image!)
            movie.actors = self.movies.first?.actors ?? ""
            movie.director = self.movies.first?.director ?? ""
            movie.imdbId = self.movies.first?.id ?? ""
            movie.rate = self.movies.first?.rate ?? ""
            movie.releaseDate = self.movies.first?.releaseDate ?? ""
            movie.writer = self.movies.first?.writer ?? ""
            movie.movieType = self.movies.first?.movieType ?? ""
            
            context.insertObject(movie)
            do {
                try context.save()
            } catch {
                print("Could not save movie")
            }
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToPrevious" {
            let movieSelectorVC = segue.sourceViewController as! SearchVC
            let indexPath : NSIndexPath = movieSelectorVC.tableView.indexPathForSelectedRow!
            movieID = movieSelectorVC.movies[indexPath.row].id
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchOnline" {
            if segue.destinationViewController.isKindOfClass(SearchVC) {
                let searchVC = segue.destinationViewController as! SearchVC
                if self.movieTitle.text != "" {
                    searchVC.searchString = self.movieTitle.text!
                }
            }
        }
    }
    
}
