//
//  FirstTab.swift
//  xy-inc
//
//  Created by Luan Damasceno on 18/05/16.
//  Copyright © 2016 luan. All rights reserved.
//

import UIKit
import CoreData

class FirstTab: UIViewController,  UITableViewDelegate, UISearchBarDelegate  {

    // MARK: Properties
    @IBOutlet var addButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textoArea: UITextView!
    // Variable to make loading item.
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    // Var that make the construction of movie.
    var error: Bool!
    var movie: Movies!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    // Every time thats screen is renderized, reset the values of fields.
    override func viewDidAppear(animated: Bool) {
        searchBar.text = ""
        self.titleLabel.hidden = true
        self.imageView.hidden  = true
        self.textoArea.hidden  = true
        self.addButton.hidden  = true
        
    }
    
    // Function for dismiss keyboard when users clicks out of the keyboard
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    // Function for done event in keyboard
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchMovies()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function to start the loading
    func startLoading(){
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,100,100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    // Function to search movies into OMDb API
    func searchMovies() {
        self.error = false
        
        if searchBar.text == "" {
            displayAlert("Ops", message: "Insira algum filme no campo de busca")
        } else {
            startLoading();
            // Init the loading
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            // Call the service to get movies
            RestApiManager.sharedInstance.getMovies({ json in
                if json != nil {
                    print(json)
                    
                    // If not found the movie
                    if String(json["Response"]) == "False"{
                        self.error = true;
                    } else {
                        // Founded MOVIE
                        var urlInside: NSURL!
                    
                        // Case: Not have image registered in API
                        if(String(json["Poster"]) != "N/A"){
                            urlInside    = NSURL(string: String(json["Poster"]))
                        } else {
                            urlInside    = NSURL(string: "https://cdn.amctheatres.com/Media/Default/Images/noposter.jpg")
                        }
                        
                        // Movies model
                        self.movie = Movies(title: String(json["Title"]), imageLoaded: NSData(contentsOfURL: urlInside!)!, year: String(json["Year"]), actrices: String(json["Actors"]), gender: String(json["Genre"]), runtime: String(json["Runtime"]), urlImage: urlInside)
                    }
                    
                    // Changing the layout
                    dispatch_async(dispatch_get_main_queue(),{
                        if (self.error == true) {
                            self.displayAlert(":(", message: "Nao foi encontrado o filme nos nossos arquivos!")
                        } else {
                            self.titleLabel.text        = self.movie.title
                            self.imageView.image        = UIImage(data: self.movie.imageLoaded)
                            self.textoArea.text         = "\nAno = \(self.movie.year)\nElenco = \(self.movie.actrices)\nGenero = \(self.movie.gender)\nDuração = \(self.movie.runtime)\n"
                        
                            self.titleLabel.hidden = false
                            self.imageView.hidden  = false
                            self.textoArea.hidden  = false
                            self.addButton.hidden  = false
                        }
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    })
                    
                } else {
                    // When is disconnected (Offline)
                    dispatch_async(dispatch_get_main_queue(),{
                        self.displayAlert(":(", message: "Você não esta conectado!")
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    })
                }
            }, name: searchBar.text!)

        }
    }
    
    // Function that makes the save of movie searched to database
    @IBAction func addToFavorite(sender: AnyObject) {
        startLoading()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        downloadImage(self.movie.urlImage)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Func to download the image from poster
    func downloadImage(url: NSURL){
        // Call service to get image from url in poster element
        RestApiManager.sharedInstance.getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                
                self.movie.savedImage = NSData(data: UIImageJPEGRepresentation(UIImage(data: data)!, 1)!)
                self.saveIntoDatabase()
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()

                
            }
        }
    }
    
    // Realize the save into database (CoreData)
    func saveIntoDatabase(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Movies",
                                                        inManagedObjectContext:managedContext)
        
        let m = NSManagedObject(entity: entity!,
                                insertIntoManagedObjectContext: managedContext)
        
        m.setValue(self.movie.title, forKey: "title")
        m.setValue(self.movie.year, forKey: "year")
        m.setValue(self.movie.runtime, forKey: "runtime")
        m.setValue(self.movie.gender, forKey: "gender")
        m.setValue(self.movie.actrices, forKey: "actrices")
        m.setValue(self.movie.savedImage, forKey: "imageSaved")
        
        do {
            try managedContext.save()
            displayAlert(":)", message: "Filme adicionado a sua lista de favoritos!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
