//
//  ImageDetailViewController.swift
//  Imgur Gallery
//
//  Created by Mariana Brasil on 05/09/21.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation

class ImageDetailViewController: UIViewController {
    
    // MARK: - Properties
    var urlImage = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Image"

        view.addSubview(someImageView)
        someImageViewConstraints()
        
        let imgURL = URL(string: urlImage)
        if let url = imgURL {
            if urlImage.contains(".mp4") {
            playVideo(url: url)
            } else {
                someImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    // MARK: - Methods
    let someImageView: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = UIImage(named: "name")
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        theImageView.contentMode = .scaleAspectFit
        theImageView.backgroundColor = .white
        return theImageView
    }()

    // MARK: - Functions
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
    
    func playVideo(url: URL){
        let player = AVPlayer(url: url)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.addChild(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = self.view.frame
            playerController.view.backgroundColor = .white
            player.play()
        }
    
    func someImageViewConstraints() {
        someImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        someImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        someImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        someImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
    }
}
