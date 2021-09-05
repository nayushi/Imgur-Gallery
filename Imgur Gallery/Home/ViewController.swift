//
//  ViewController.swift
//  Imgur Gallery
//
//  Created by Mariana Brasil on 03/09/21.
//

import UIKit
import SDWebImage
import AVFoundation

struct CustomData {
    var image = UIImage()
}

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let apiClient = ImagesAPIClient()
    var images: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gallery"
        
        loadingImages()
        setupView()
        setupConstraint()
        loadData()
    }
    
    // MARK: - Methods
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
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 80) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func loadImage() {
        let imageView = SDAnimatedImageView()
        let animatedImage = SDAnimatedImage(named: "image.gif")
        imageView.image = animatedImage
        imageView.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"))
    }
    
    func loadingImages() {
        let alert = UIAlertController(title: nil, message: "Loading images", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
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
                self.images = path
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.dismiss(animated: false, completion: nil)
                }
            case .failure(let error):
                print("Erro:", error.localizedDescription)
            }
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        let imgData = images[indexPath.row]
        let imgURL = URL(string: imgData)
        if let url = imgURL {
            if imgData.contains(".mp4") {
                let mp4Image = getThumbnailImage(forUrl: url)
                cell.img.image = mp4Image
            } else {
                cell.img.sd_setImage(with: url, completed: nil)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 4) - 1
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    
  
}
