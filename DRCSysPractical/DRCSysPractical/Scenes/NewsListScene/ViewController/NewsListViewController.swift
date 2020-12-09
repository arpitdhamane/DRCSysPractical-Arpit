//
//  DemoViewController.swift
//  DRCSysPractical
//
//  Created by Mac Mini on 09/12/20.
//  
//

import UIKit

final class AudioListViewController: BaseViewController {
    
    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet weak var tblNewsList: UITableView!
    var viewModel = AudioListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupUI()
        if UserDefaults.standard.bool(forKey: "isAppAlreadyOpen") {
            self.tblNewsList.isHidden = false
            self.tblNewsList.reloadData()
        } else {
            callInitialAPI()
        }
    }
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "News List"
        
        tblNewsList.delegate = self
        tblNewsList.dataSource = self
    }
    
    private func callInitialAPI() {
        self.tblNewsList.isHidden = true
        self.lblLoading.text = "Loading news articles..."
        viewModel.callNewsListAPI(completion: { (status) in
            DispatchQueue.main.async {
                if status {
                    UserDefaults.standard.set(true, forKey: "isAppAlreadyOpen")
                    self.tblNewsList.isHidden = false
                    self.tblNewsList.reloadData()
                } else {
                    UserDefaults.standard.set(false, forKey: "isAppAlreadyOpen")
                    self.lblLoading.text = "Some Error occured"
                }
            }
        })
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}

extension AudioListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell", for: indexPath) as! NewsListCell
        
        cell.lblNewsTitle.text = "aaaa"
//        let news = self.viewModel.news[indexPath.row]
        cell.lblNewsTitle.text = news.value(forKeyPath: "title") as? String
        let strURL = news.value(forKeyPath: "image") as? String ?? ""
        cell.imageNews.downloaded(from: strURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objDetailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as DetailViewController
//        objDetailVC.viewModel.selectedNews = self.viewModel.news[indexPath.row]
        self.present(objDetailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
