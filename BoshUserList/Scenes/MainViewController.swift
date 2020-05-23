//
//  ViewController.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import UIKit
import PromiseKit
import SwifterSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var userListTable: UITableView!
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var currentPage = 0
    private var isLoading = false
    private var users: UserListModel = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callUserListAPI(page: currentPage)
    }
}


//MARK:- Setting View
extension MainViewController {
    private func settingView() {
        userListTable.refreshControl = refreshControl
    }
}


//MARK:- Call Api
extension MainViewController {
    fileprivate func callUserListAPI(page: Int) {
        if isLoading {
            return
        }
        
        isLoading = true
        userListTable.isUserInteractionEnabled = false
        firstly {
            APIService<UserListModel>().request(RandomUserService.getUserList(page))
        }.done { response in
            if self.currentPage == 0 {
                self.users = UserListModel()
            }
            self.currentPage += 1
            self.users += response
            self.userListTable.reloadData()
        }.ensure {
            self.userListTable.isUserInteractionEnabled = true
            self.isLoading = false
        }.catch {
            print($0)
        }
    }
}


//MARK:- Table delegate & data source
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count == 0 ? 0 : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        cell.setData = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.indexPathForLastRow == indexPath {
            callUserListAPI(page: currentPage)
        }
    }
    
    @objc func pullToRefresh() {
        currentPage = 1
        callUserListAPI(page: currentPage)
    }
}
