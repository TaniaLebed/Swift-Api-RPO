//
//  ViewController.swift
//  Api
//
//  Created by TaniaLebed on 5/19/20.
//  Copyright © 2020 TaniaLebed. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let apiUrl = URL(string : "https://newsapi.org/v2/top-headlines?country=ru&apiKey=d87997f3a0874abd9cdf1ea7da5976d0")

    var articles: Array<Dictionary<String,Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = articles[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if let title = row["title"] as? String{
            cell.title.text = title
        }
        
        if let urlToImage = row["urlToImage"] as? String{
            cell.image.sd_setImage(with: URL(string: urlToImage))
        }
        
        return cell
    }

    func loadData(){
        let session = URLSession.shared.dataTask(with: URLRequest(url : apiUrl!)) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode != 200) {
                    print("Error")
                }
            }
            if let myData = data {
                if let json = try? JSONSerialization.jsonObject(with: myData, options: []) as! Dictionary<String,Any> {
                    if let articles = json["articles"] as? Array<Dictionary<String,Any>> {
                        self.articles = articles
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } else {
                        print("Error")
                    }
                } else {
                    print("Error")
                }
            }
        }
        session.resume()
    }
}
