//
//  ViewController.swift
//  Imgur Gallery
//
//  Created by Mariana Brasil on 03/09/21.
//

import UIKit
import SDWebImage

struct CustomData {
    var image = UIImage()
}

class ViewController: UIViewController {
    
    
    private let apiClient = ImagesAPIClient()
    //var data: [FirstData] = []
    

    fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gallery"
        
        setupView()
        setupConstraint()
        loadData()
        
    
        
    }
    
   
    
    func loadImage() {
        
        let imageView = SDAnimatedImageView()
        let animatedImage = SDAnimatedImage(named: "image.gif")
        imageView.image = animatedImage
        
        imageView.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"))
    }
    
    
    func setupView(){
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupConstraint(){
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func loadData() {
        apiClient.fetchImages { result in
            switch result {
            case .success(let path):
                let data = path.data
                print(data)
                
                self.collectionView.reloadData()
                //print("AQUI", self.data)
            case .failure(let error):
                print("Erro:", error.localizedDescription)
            }
        }
    }
    
    
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.backgroundColor = .blue
        
       /* let imgData = data[indexPath.row]
       let imageView = SDAnimatedImageView()
        let animatedImage = SDAnimatedImage(named: imgData.link)
       imageView.image = animatedImage
        */
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 4) - 1
        
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("aaaa")
    }
    
    
    
}
