//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Mario Jackson on 8/6/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url: String
        
        if navigationController?.tabBarItem.tag == 0 {
           url = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            url = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        guard let url = URL(string: url) else {
            showError()
            return
        }
        
        if let data = try? Data(contentsOf: url) {
            parse(json: data)
            return
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was an problem loading the feed. Please check your connection and try again",
            preferredStyle: .alert
        )
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
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

