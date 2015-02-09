//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Gabriel Santos on 2/2/15.
//  Copyright (c) 2015 Team Nebula. All rights reserved.
//

import UIKit

class ViewController: UITableViewController //UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var moviesArray: NSArray?

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (moviesArray != nil)
        {
            var i:Int? = moviesArray?.count as Int?
            return i!;
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let index:Int = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell") as ReviewCell;
        
        if (moviesArray?.count >= index)
        {
            let movie: NSDictionary = self.moviesArray?[index] as NSDictionary;
            
            let ratings: NSDictionary = movie["ratings"] as NSDictionary
            
            println(ratings);
            
            if (ratings["critics_rating"] != nil && ratings["critics_score"] != nil)
            {
                var percent:Int = ratings["critics_score"] as Int
                
                var pStr: String = String(percent)
                cell.tomatoLabel.text = pStr + "%";
                
                if (ratings["critics_rating"] as String == "Rotten")
                {
                    cell.tomatoIcon.image = UIImage(named: "splat-16")
                }
            }
            else if (ratings["audience_score"] != nil)
            {
                var percent:Int = ratings["audience_score"] as Int;
                
                var pStr: String = String(percent)
                cell.tomatoLabel.text = pStr + "%";
                
                if (percent < 50)
                {
                    cell.tomatoIcon.image = UIImage(named: "splat-16")
                }
            }
            
            let title: String = movie["title"] as NSString;
            cell.movieNameLabel.text = title;
            
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let detailsView: MovieDetailsViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("detailsView") as MovieDetailsViewController
        
        let index:Int = indexPath.row
        let movie: NSDictionary = self.moviesArray?[index] as NSDictionary
        detailsView.movieData = movie
        
        self.showViewController(detailsView, sender: detailsView)
    }
    
    override func viewDidLoad()
    {
        self.title = "Rotten Tomatoes"
    }
    
    override func viewDidAppear(animated: Bool)
    {
        loadMovieData();
    }

    func loadMovieData()
    {
        showActivity()
        
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/opening.json?apikey=v4dp89x7m2t8annz9f382qpz"
        
        let request = NSMutableURLRequest(URL: NSURL(string:RottenTomatoesURLString)!);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ ( response, data, error) in var errorValue: NSError? = nil
            
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            
            self.moviesArray = dictionary["movies"]! as? NSArray
            
            self.tableView.reloadData()
            
            self.hideActivity()
        });
    }
    
    func showActivity()
    {
        actInd = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd?.center = self.view.center
        actInd?.hidesWhenStopped = true
        actInd?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd!)
        actInd?.startAnimating()
    }
    
    func hideActivity()
    {
        actInd?.stopAnimating()
        actInd?.removeFromSuperview()
    }
    
    var actInd: UIActivityIndicatorView?
}

