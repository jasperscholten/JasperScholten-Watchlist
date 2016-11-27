//
//  ResultViewController.swift
//  Watchlist
//
//  Created by Jasper Scholten on 25-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

class ResultViewController: UIViewController {

    private let db = DatabaseHelper()
    
    @IBOutlet weak var moviePoster: UIImageView!
    // change for textview
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieActors: UITextView!
    @IBOutlet weak var moviePlot: UITextView!
    
    var movieID = String()
    var movieList = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("movieID: \(movieID)")
        
        // http://stackoverflow.com/questions/38292793/http-requests-in-swift-3
        
        let movie = movieID
        let search = String(movie.characters.map { $0 == " " ? "+" : $0 })
        let url = URL(string: "https://www.omdbapi.com/?i=" + search + "&y=&plot=full&r=json")
        print(url!)
        
        if url == nil {
            print("Empty string")
        } else {
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                
                if json["Error"] != nil {
                    print(json["Error"]!)
                } else {
                    DispatchQueue.main.async {
                        self.movieList = json
                        self.movieTitle.text = self.movieList["Title"] as? String
                        self.movieYear.text = self.movieList["Year"] as? String
                        self.movieActors.text = self.movieList["Actors"] as? String
                        self.moviePlot.text = self.movieList["Plot"] as? String
                    }
                }
            }
            task.resume()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMovie(_ sender: Any) {
        
        print((movieList["Title"] as? String)!)
        print((movieList["Year"] as? String)!)
        print((movieList["Rated"] as? String)!)
        print((movieList["Released"] as? String)!)
        print((movieList["Runtime"] as? String)!)
        print((movieList["Genre"] as? String)!)
        print((movieList["Director"] as? String)!)
        print((movieList["Writer"] as? String)!)
        print((movieList["Actors"] as? String)!)
        print((movieList["Plot"] as? String)!)
        print((movieList["Language"] as? String)!)
        print((movieList["Country"] as? String)!)
        print((movieList["Awards"] as? String)!)
        print((movieList["Poster"] as? String)!)
        print((movieList["Metascore"] as? String)!)
        print((movieList["imdbRating"] as? String)!)
        print((movieList["imdbVotes"] as? String)!)
        print((movieList["imdbID"] as? String)!)
        print((movieList["Type"] as? String)!)
        
        do {
            try db!.add(title: (movieList["Title"] as? String)!, year: (movieList["Year"] as? String)!, rated: (movieList["Rated"] as? String)!, released: (movieList["Released"] as? String)!, runtime: (movieList["Runtime"] as? String)!, genre: (movieList["Genre"] as? String)!, director: (movieList["Director"] as? String)!, writer: (movieList["Writer"] as? String)!, actors: (movieList["Actors"] as? String)!, plot: (movieList["Plot"] as? String)!, language: (movieList["Language"] as? String)!, country: (movieList["Country"] as? String)!, awards: (movieList["Awards"] as? String)!, poster: (movieList["Poster"] as? String)!, metascore: (movieList["Metascore"] as? String)!, imdbrating: (movieList["imdbRating"] as? String)!, imdbvotes: (movieList["imdbVotes"] as? String)!, imdbid: (movieList["imdbID"] as? String)!, type: (movieList["Type"] as? String)!)
            
            NotificationCenter.default.post(name: .reload, object: nil)
            
        } catch {
            print(error)
        }
        
    }

}
