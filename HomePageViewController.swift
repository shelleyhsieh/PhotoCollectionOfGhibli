//
//  HomePageViewController.swift
//  PhotoCollectionOfGhibli
//
//  Created by shelley on 2022/12/27.
//

import UIKit

class HomePageViewController: UIViewController {
    
    var movieTitle: String = ""
    var imageName: String = ""
    
    let ghibliMovie: [String: String] = ["となりのトトロ": "totoro", "魔女の宅急便":"majo", "もののけ姫":"mononoke", "千と千尋の神隠し":"chihiro", "猫の恩返し":"baron", "ハウルの動く城":"howl", "崖の上のポニョ":"ponyo", "借りぐらしのアリエッティ":"karigurashi"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let logoImage = UIImageView(frame: CGRect(x: 67, y: 60, width: 240, height: 128))
        logoImage.image = UIImage(named: "logo")
        logoImage.contentMode = .scaleAspectFit
        view.insertSubview(logoImage, at:0)
        
    }
    

    @IBAction func buttonPressed(_ sender: UIButton) {
        movieTitle = (sender.titleLabel?.text)!
        imageName = ghibliMovie[movieTitle] ?? ""
        performSegue(withIdentifier: "showPhotos", sender: nil)
    }
    
    
    @IBSegueAction func showPhotos(_ coder: NSCoder) -> PhotoCollectionViewController? {
        return PhotoCollectionViewController(coder: coder, movieTitle: movieTitle, imageName: imageName )
    }

}
