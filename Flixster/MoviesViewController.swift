//
//  MoviesViewController.swift
//  Flixster
//
//  Created by William Huynh on 10/12/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()
    var numberOfMoviesPages:Int!
    
    var myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadMovies()
        myRefreshControl.addTarget(self, action: #selector(loadMovies), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    //MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        
        let posterPath = movie["poster_path"] as? String ?? "/qdfARIhgpgZOBh3vfNhWS4hmSo3.jpg"
        
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == movies.count {
            loadMoreMovies()
        }
    }
    
    //MARK: - API Functions
    
    @objc func loadMovies() {
        
        numberOfMoviesPages = 1
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
                // print(dataDictionary)
                
                //print(self.movies)
            }
        }
        task.resume()
    }
    
    func loadMoreMovies() {
        
        numberOfMoviesPages = numberOfMoviesPages + 1
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&page=\(numberOfMoviesPages ?? 1)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies += dataDictionary["results"] as! [[String:Any]]
                
                self.tableView.reloadData()
                // print(dataDictionary)
                
                //print(self.movies)
            }
        }
        task.resume()
        
        
    }
    
    // MARK: - Navigation
    // TEST BRANCH WORKING
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Find selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the detials view controller
        let detailVC = segue.destination as! MovieDetailsViewController
        detailVC.movie = movie
        
        // Remove still hightlight of the cell after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
