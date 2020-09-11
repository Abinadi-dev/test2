//
//  ViewController.swift
//  Test2
//
//  Created by The App Experts on 11/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var TableView1: UITableView!

    var show: [Show] = []
    //?limit=60&offset=60.
//    let firstPageURLString = "https://pokeapi.co/api/v2/pokemon"
    let firstPageURLString = "https://www.episodate.com/api/most-popular?page=1"
    var pageNumber = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView1.dataSource = self
        self.TableView1.prefetchDataSource = self
        self.TableView1.register(UINib(nibName: "TVTableViewCell", bundle: nil), forCellReuseIdentifier: "TVTableViewCell")
//        self.TableView1.rowHeight = UITableView.automaticDimension
//        self.TableView1.estimatedRowHeight = 155;
        self.getShow()
    }

    
    func getShow(with pageNumber: Int = 1) {
      let showPageURLString = self.firstPageURLString + "?limit=20&offset=\(20 * (pageNumber - 1))"
      guard let url = URL(string: showPageURLString) else { return }
      URLSession.shared.dataTask(with: url) { (data, _, _) in
        guard let data = data else { return }
        guard let results = try? JSONDecoder().decode(ShowResults.self, from: data) else { return }
        self.show.append(contentsOf: results.tv_shows)
        DispatchQueue.main.async {
          self.TableView1.reloadData()
        }
      }.resume()
    }

    func getNextPage() {
      self.pageNumber += 1
      self.getShow(with: self.pageNumber)
    }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.show.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TVTableViewCell", for: indexPath) as! TVTableViewCell
    cell.configure(with: self.show[indexPath.row])
    return cell
  }
}

extension ViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let lastIndexPath = IndexPath(row: self.show.count - 1, section: 0)
    guard indexPaths.contains(lastIndexPath) else { return }
    self.getNextPage()
  }
}
