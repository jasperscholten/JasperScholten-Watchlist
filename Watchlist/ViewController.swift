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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if db == nil {
            print("Error")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
    }
    
    func reloadTableData(_ notification: Notification) {
        listTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            cell.movieTitleList.text = try db!.populate(index: indexPath.row)
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
    }

}

