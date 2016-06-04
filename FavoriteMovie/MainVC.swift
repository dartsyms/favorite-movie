//
//  MainVC.swift
//  FavoriteMovie
//
//  Created by sanchez on 16.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()
    var movieID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "white_smoke_bkgrnd.jpg"))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchAndSetResults()
        tableView.reloadData()
    }
    
    // MARK: - Core Data Stack methods
    func fetchAndSetResults() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.movies = results as! [Movie]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // MARK: - TableViewDataSource and TableViewDelegate methods

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieCell {
            let movie = movies[indexPath.row]
            
            let backgroundImage = cellBackgroundForRowAtIndexPath(indexPath)!
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.alpha = 0.7
            cell.backgroundColor = UIColor.clearColor()
            cell.backgroundView = backgroundImageView
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            visualEffectView.frame = CGRectMake(0, 0, cell.bounds.width, cell.bounds.height)
            backgroundImageView.addSubview(visualEffectView)
            
            cell.configureCell(movie)
            
            return cell
        } else {
            return MovieCell()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = movies[sourceIndexPath.row]
        movies.removeAtIndex(sourceIndexPath.row)
        movies.insert(itemToMove, atIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            context.deleteObject(movies[indexPath.row] as NSManagedObject)
            movies.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            do {
                try context.save()
            } catch {
                print("Error while saving")
            }
            
            tableView.reloadData()
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
    
    // MARK: - Navigation (segues)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewDetail" {
            let detailVC = segue.destinationViewController as! MovieDetailVC
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            detailVC.movieID = self.movies[indexPath.row].imdbId!
        }
//        if segue.identifier == "editMovie" {
//            let addMovieVC = segue.destinationViewController as! AddMovieVC
//            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
//            addMovieVC.movieID = self.movies[indexPath.row].imdbId!
//        }
    }


}

