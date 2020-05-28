//
//  ViewController.swift
//  Sample GCD App
//
//  Created by Pankaj kumar on 28/05/20.
//  Copyright © 2020 Pankaj kumar. All rights reserved.
//

import UIKit

enum Images: String {
    case whale = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe5127_whale/whale.jpg"
    case shark = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe5123_shark/shark.jpg"
    case seaLion = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe511f_sealion/sealion.jpg"
}

class ViewController: UIViewController {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBAction func setTransparencyOfImage(sender: UISlider) {
        photoView.alpha = CGFloat(sender.value)
    }
    
    @IBAction func synchronousDownload(sender: UIBarButtonItem) {
        activityView.startAnimating()
        if let url = URL(string: Images.seaLion.rawValue), let imgData = try? Data(contentsOf: url) {
            let image = UIImage(data: imgData)
            self.photoView.image = image
            self.activityView.stopAnimating()
        }
    }
    
    @IBAction func simpleAsynchronousDownload(sender: UIBarButtonItem) {
        activityView.startAnimating()
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {
            if let url = URL(string: Images.shark.rawValue), let imgData = try? Data(contentsOf: url) {
                let image = UIImage(data: imgData)
                DispatchQueue.main.async {
                    self.photoView.image = image
                    self.activityView.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func asynchronousDownload(sender: UIBarButtonItem) {
        activityView.startAnimating()
        downloadBigImage { (image) -> Void in
            self.photoView.image = image
            self.activityView.stopAnimating()
        }
    }
    func downloadBigImage(completionHandler handler: @escaping (UIImage?) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: Images.whale.rawValue), let imgData = try? Data(contentsOf: url) {
                let image = UIImage(data: imgData)
                DispatchQueue.main.async {
                    handler(image)
                }
            }
        }
    }
}

