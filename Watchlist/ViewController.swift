//
//  ViewController.swift
//  Watchlist
//
//  Created by Jasper Scholten on 25-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let db = DatabaseHelper()
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var movieList = [String: AnyObject]()
    var imdbList = [Int: String]()
    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if db == nil {
            print("Error")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
        // Method to dismiss keyboard upon tap outside keyboard. Uses func dismissKeyboard() http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func reloadTableData(_ notification: Notification) {
        listTableView.reloadData()
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
        var count: Int?
        
        do {
            count = try db!.countRows()
        } catch {
            print(error)
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = listTableView.dequeueReusableCell(withIdentifier: "watchlistCell", for: indexPath) as! WatchlistTableViewCell
        
        do {
            print(try db!.populate(index: indexPath.row))
            cell.movieTitleList.text = try db!.populate(index: indexPath.row)["title"]!
            cell.movieYearList.text = try db!.populate(index: indexPath.row)["year"]!
            let movieID = try db!.populate(index: indexPath.row)["imdbid"]!
            imdbList[indexPath.row] = movieID
            
            let posterString = try db!.populate(index: indexPath.row)["poster"]!
            let posterURL = URL(string: posterString!)
            
            getDataFromUrl(url: posterURL!) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { () -> Void in
                    cell.moviePosterList.image = UIImage(data: data)
                }
            }
            
        } catch {
            print(error)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try db!.delete(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
        
        DispatchQueue.main.async {
            self.selected = indexPath.row
            self.performSegue(withIdentifier: "showMovieList", sender: nil)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func searchMovie(_ sender: Any) {
        
        // http://stackoverflow.com/questions/38292793/http-requests-in-swift-3
        
        let movie = searchField.text!
        let search = String(movie.characters.map { $0 == " " ? "+" : $0 })
        let url = URL(string: "https://www.omdbapi.com/?s=" + search + "&y=&plot=full&r=json")
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
                        self.performSegue(withIdentifier: "showResults", sender: nil)
                        self.searchField.text = ""
                    }
                }
            }
            task.resume()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showResults = segue.destination as? SearchViewController {
            showResults.movieList = movieList
        }
        
        if let showMovie = segue.destination as? ResultViewController {
            showMovie.movieID = imdbList[selected]!
            print(imdbList[selected]!)
        }
    }

}

