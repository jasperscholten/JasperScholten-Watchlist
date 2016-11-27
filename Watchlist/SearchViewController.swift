//
//  SearchViewController.swift
//  Watchlist
//
//  Created by Jasper Scholten on 25-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTableView: UITableView!
    
    var movieList = [String: AnyObject]()
    var movieSearch = [AnyObject]()
    var imdbList = [IndexPath: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieSearch = movieList["Search"] as! [AnyObject]
        print(movieSearch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchresultCell", for: indexPath) as! SearchresultTableViewCell
        
        let movieRow = movieSearch[indexPath.row]
        cell.movieTitleSearch.text = movieRow["Title"] as? String
        cell.movieYearSearch.text = movieRow["Year"] as? String
        
        let posterString = movieRow["Poster"] as? String
        let posterURL = URL(string: posterString!)
        
        getDataFromUrl(url: posterURL!) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                cell.moviePosterSearch.image = UIImage(data: data)
            }
        }
        
        // use to create indexPath: imdbId dictionary.
        imdbList[indexPath] = movieRow["imdbID"] as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMovie", sender: indexPath);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let showMovie = segue.destination as? ResultViewController {
            
            let row = sender as! IndexPath
            let imdbID = imdbList[row]
            showMovie.movieID = imdbID!
        }
    }

}
