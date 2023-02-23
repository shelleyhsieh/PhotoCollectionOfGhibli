//
//  DetailViewController.swift
//  PhotoCollectionOfGhibli
//
//  Created by shelley on 2023/2/5.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

}
