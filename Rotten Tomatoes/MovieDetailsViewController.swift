//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Gabriel Santos on 2/4/15.
//  Copyright (c) 2015 Team Nebula. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    var movieData: NSDictionary?
    
    
    override func viewDidLoad()
    {
        if let movieName = movieData?["title"] as? String
        {
            self.title = movieName
        }
        
        if let synopsis = movieData?["synopsis"] as? String
        {
            println(synopsis)
            
            synopsisLabel.text = synopsis
            synopsisLabel.numberOfLines = 0
            synopsisLabel.sizeToFit()
        }
        
        if let posters = movieData?["posters"] as? NSDictionary
        {
            if let thumbStr = posters["original"] as? String
            {
                let oriStr = thumbStr.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                let url = NSURL(string: oriStr)
                posterImage.setImageWithURL(url)
                
            }
        }
        
        let h = posterImage.bounds.height + synopsisLabel.bounds.height - 70;
        self.myScrollView.contentSize = CGSizeMake(self.myScrollView.bounds.width, h)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
//        scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y), animated: true)
    }
}