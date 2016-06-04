//
//  MovieDetailVC.swift
//  FavoriteMovie
//
//  Created by sanchez on 16.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieShortDescription: UILabel!
    @IBOutlet weak var movieFullDescription: UITextView!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var actors: UILabel!
    
    var movies = [Movie]()
    var movieID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if movieID != "" {
            fetchAndSetResultForOne()
            
            moviePoster.image = movies.first!.getMoviePosterImage()
            movieTitle.text = (movies.first!.valueForKey("title") as! String)
            movieShortDescription.text = "Genre: " + (movies.first!.valueForKey("personalDescription") as! String)
            movieFullDescription.text = movies.first!.valueForKey("fullDescription") as! String
            releaseYear.text = "Released in: " + (movies.first!.valueForKey("releaseDate") as! String)
            director.text = "Directed by: " + (movies.first!.valueForKey("director") as! String)
            actors.text = "Cast: " + (movies.first!.valueForKey("actors") as! String)
        }
        
        let backgrndImg = UIImage(named: "white_smoke_bkgrnd.jpg")
        self.view.backgroundColor = UIColor(patternImage: backgrndImg!)
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        view.insertSubview(visualEffectView, atIndex: 0)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fetchAndSetResultForOne() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        if self.movieID != "" {
            let filter = self.movieID
            let predicate = NSPredicate(format: "imdbId == %@", filter)
            fetchRequest.predicate = predicate
        }
        
        do {
            let results = try context.executeFetchRequest(fetchRequest) as! [Movie]
            self.movies = results
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func backToRootVCPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func viewMorePressed(sender: AnyObject) {
        performSegueWithIdentifier("showWeb", sender: self)
    }
    
    @IBAction func changePosterPressed(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(IMDBWebVC) {
            let imdbWebVC = segue.destinationViewController as! IMDBWebVC
            if self.movieID != "" {
                imdbWebVC.movieID = self.movieID
            }
            
        }
    }
}
