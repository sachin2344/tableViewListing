//
//  ViewController.swift
//  DemoProject
//
//  Created by sachin on 28/05/24.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UITableViewDiffableDataSource<Int, Post>!
    var viewModel: ListViewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        observeEvent()
        setUpTableView()
        setUpDataSource()
        fetchInitialData()
    }

}

extension ListViewController{
    
    func setUpTableView(){
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
    }
    
    func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Post>(tableView: tableView) { tableView, indexPath, post in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
            cell.post = post
            return cell
            
        }
    }
    
    func showInfoView(message: String = "Loading...", showLoader: Bool = true){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.tableView.isHidden = true
            self.infoView.isHidden = false
            self.infoLabel.text = message
            if showLoader{
                self.loader.isHidden = false
                self.loader.startAnimating()
            } else{
                self.loader.isHidden = true
            }
        }
    }
    
    func hideInfoView(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.tableView.isHidden = false
            self.infoView.isHidden = true
            self.infoLabel.text = "Loading..."
            self.loader.startAnimating()
        }
    }
    
    func openDetailVC(post: Post){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVc = storyBoard.instantiateViewController(withIdentifier: "detailVc") as! DetailViewController
        detailVc.post = post
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}

// MARK: - Table view
extension ListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let post = dataSource.itemIdentifier(for: indexPath)
        if let post{
            self.openDetailVC(post: post)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > (viewModel.postsArray.count - 3){
            self.viewModel.page += 1
            self.viewModel.fetchData()
        }
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.postsArray)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}


extension ListViewController{
    
    func fetchInitialData(){
        viewModel.fetchData()
    }
    
    func updateTable(){
        if viewModel.page == 1{
            self.hideInfoView()
        }
        self.updateDataSource()
    }
    
    func observeEvent(){
        viewModel.eventHandler = { [weak self] event in
            print("Event Callback - \(event)")
            guard let self else {return}
            
            switch event{
            case .loading:
                self.showInfoView()
            case .postsLoaded:
                self.updateTable()
            case .errorFetchingPosts:
                self.showInfoView(message: "Something went wrong!!")
            }
        }
    }
}
