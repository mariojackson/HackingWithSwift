//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Mario Jackson on 8/6/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var topPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPetitions()
    }
    
    /// Shows a connection problem error.
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(
                title: "Loading error",
                message: "There was an problem loading the feed. Please check your connection and try again",
                preferredStyle: .alert
            )
            
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    /// Parses the given data into Petitions.
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /// Fetches the petitions by making a API request if the petitions are empty.
    /// Otherwise the cached petitions will be used, without making a new request.
    private func fetchPetitions() {
        let tag = navigationController?.tabBarItem.tag
        let url = getUrlByTag(tabBarItemTag: tag)
        
        if !shouldMakeApiRequest(tabBarItemTag: tag) {
           return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: url) else {
                self.showError()
                return
            }
        
            if let data = try? Data(contentsOf: url) {
                self.parse(json: data)
                return
            }
        
            self.showError()
        }
    }
    
    /// Returns the URL of the  JSON  for the petitions
    private func getUrlByTag(tabBarItemTag tag: Int?) -> String {
        if tag == 0 {
           return "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        
        return "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
    
    /// Checks whether a new request should be made to fetch the petitions or not
    private func shouldMakeApiRequest(tabBarItemTag tag: Int?) -> Bool {
        if tag == 0 && petitions.count > 0 {
            return false
        }
        
        if tag == 1 && topPetitions.count > 0 {
            return false
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

