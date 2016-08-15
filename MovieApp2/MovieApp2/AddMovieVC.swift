//
//  AddMovieVC.swift
//  MovieApp2
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit
import CoreData

class AddMovieVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieDescription: UITextField!
    @IBOutlet weak var movieUrl: UITextField!
    @IBOutlet weak var movieUrlPlot: UITextField!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        movieImg.layer.cornerRadius = 5.0
        movieImg.clipsToBounds = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMovieVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddMovieVC.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddMovieVC.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    @IBAction func addImage(sender: AnyObject!) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        movieImg.image = image
    }
    @IBAction func saveBtn(sender: AnyObject!) {
        if let title = movieTitle.text where title != "" {
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = app.managedObjectContext
            let entity = NSEntityDescription.entityForName("Entity", inManagedObjectContext: context)!
            let movies = Entity(entity: entity, insertIntoManagedObjectContext: context)
            movies.title = title
            
            movies.descriptionMovie = movieDescription.text
            movies.urlImdb = movieUrl.text
            movies.urlImdbPlot = movieUrlPlot.text
            movies.setMoviesImg(movieImg.image!)
            
            context.insertObject(movies)
            do {
                try context.save()
            } catch {
                print("Could not save movie")
            }
            //self.navigationController?.popViewControllerAnimated(true)
            // dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        //self.view.frame.origin.y -= 150
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
