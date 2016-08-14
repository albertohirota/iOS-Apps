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
    
    //var fetchedResultsController: NSFetchedResultsController!
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
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if ttt == nil {
    //            if (segue.identifier == "DetailsVC")
    //            {
    ////                let vc = segue.destinationViewController as! DetailsVC
    ////                vc.dDescription = ddd
    ////                vc.summary = sss
    ////                vc.dImage = iii
    ////                vc.dTitle = ttt
    //
    //           //     let indexPath: NSIndexPath = self.tableView.indexPathsForSelectedRows()!
    //
    //        }
    //
    //        }
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let currentCell = movies[indexPath.row]
        let storyboard = UIStoryboard(name: "DetailsVC", bundle: nil)
        let viewController: DetailsVC = storyboard.instantiateViewControllerWithIdentifier("DetailsVC") as! DetailsVC
        viewController.dDescription = currentCell.descriptionMovie
        viewController.dImage = currentCell.getMovieImg()
        viewController.dTitle = currentCell.title
        
        viewController.summary = currentCell.urlImdbPlot
        //viewController.passedValue = currentCell.textLabel.text
        self.presentViewController(viewController, animated: true, completion: nil)
        
        //        let row = movies[indexPath.row] //selecionou correto, nao apagar
        //
        //
        //        let detailsVC: DetailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsVC") as! DetailsVC
        //        detailsVC.dImage = row.getMovieImg()
        //        detailsVC.dTitle = row.title
        //        detailsVC.dDescription = row.descriptionMovie
        //        detailsVC.summary = row.urlImdbPlot
        //        iii = row.getMovieImg()
        //        ttt = row.title!
        //        ddd = row.descriptionMovie!
        //        sss = row.urlImdbPlot!
        //        print(row.descriptionMovie)
        //        self.presentViewController(ViewController, animated: true, completion: nil)
        
        //self.performSegueWithIdentifier("DetailsVC", sender: self)
        
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
}

