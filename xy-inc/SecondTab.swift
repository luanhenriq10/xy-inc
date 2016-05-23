//
//  SecondTab.swift
//  xy-inc
//
//  Created by Luan Damasceno on 18/05/16.
//  Copyright © 2016 luan. All rights reserved.
//

import UIKit
import CoreData

class SecondTab: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: Properties
    var movies = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Every time this screen is show, reload the table view datas.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions to implement table view functions
    override func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MoviesTableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MoviesTableViewCell
        let data = movies[indexPath.row]

        cell.titleLabel.text      = String(data.valueForKey("title")!)
        cell.yearLabel.text       = String(data.valueForKey("year")!)
        cell.genderLabel.text     = String(data.valueForKey("gender")!)

        let nsData: NSData      = data.valueForKey("imageSaved") as! NSData

        cell.photoImageView!.image = UIImage(data: nsData)!
        
        return cell
    }
    
    // Function to delete element in list
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(movies[indexPath.row] as NSManagedObject)
            movies.removeAtIndex(indexPath.row)
            do {
                try context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Movies")

        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            movies = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
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
