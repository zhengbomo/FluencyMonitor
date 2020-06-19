//
//  ViewController.swift
//  Demo
//
//  Created by bomo on 2020/6/18.
//  Copyright © 2020 bomo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.frame = self.view.bounds
    }
    override func viewDidLoad() {
        
        FluencyMonitor.shared.start()
        super.viewDidLoad()
    }

    @IBAction func cancel(_ sender: Any) {
        
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = UUID().uuidString
        if indexPath.row > 0 && indexPath.row % 30 == 0 {
            usleep(2000000);
        }
        return cell
    }
}
