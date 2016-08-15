//
//  ViewController.swift
//  MovieApp2
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController!
    var movies = [Entity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieCell {
            let movie = movies[indexPath.row]
            cell.configureCell(movie)
            return cell
        } else {
            return MovieCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = movies[indexPath.row]
        self.performSegueWithIdentifier("DetailsVC", sender: currentCell)//the datas will come from currentCell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    override func viewDidAppear(animated: Bool) {
        fetchAndSetResults()
        tableView.reloadData()
    }
    func fetchAndSetResults() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.movies = results as![Entity]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailsVC" {
            if let details = segue.destinationViewController as? DetailsVC {
                if let currentCell = sender as? Entity {
                    details.dTitle = currentCell.title
                    details.dDescription = currentCell.descriptionMovie
                    details.dImage = currentCell.getMovieImg()
                    details.summary = currentCell.urlImdb
                    details.imdbLink = currentCell.urlImdb
                }
            }
        }
    }
}

