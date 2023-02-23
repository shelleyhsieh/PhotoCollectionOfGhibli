//
//  PhotoCollectionViewController.swift
//  PhotoCollectionOfGhibli
//
//  Created by shelley on 2022/12/27.
//

import UIKit


class PhotoCollectionViewController: UICollectionViewController {
    
    //產生一個照片儲存位置
    var images: [UIImage] = []
    
    let movieTitle: String
    let imageName: String
    
    //從前一頁將照片傳值過來
    init?(coder: NSCoder, movieTitle: String, imageName: String) {
        self.movieTitle = movieTitle
        self.imageName = imageName
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//產生載入中的轉圈圈動畫
    let loadingIndicator = UIActivityIndicatorView()
    let loadingView = UIView()
    
//畫面載入完成
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCellSize()
        addLoadingView()
        
        navigationItem.title = movieTitle
       
    }
    
//更新畫面後才開始抓圖，抓完後移除loadingView
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getImages()
        loadingView.removeFromSuperview()
    }
    
    //將選到的圖片傳至下一頁
    @IBSegueAction func showPhotoDetail(_ coder: NSCoder) -> DetailViewController? {
        guard let detailVC = DetailViewController(coder: coder) else { return nil }
        if let item = collectionView.indexPathsForSelectedItems?.first?.item {
            detailVC.image = self.images[item]
        }
        return detailVC
    }

    
    
   // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }
    // 一個section中有多少item數量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(photoCollectionViewCell.self)", for: indexPath) as! photoCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPhotoDetail", sender: nil)
    }
    
    // 設定cell格式大小間距
    func configureCellSize(){
        let itemSpace: Double = 3   // cell間距
        let columeCount:Double = 3  // 一排有幾個cell
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width - itemSpace * (columeCount-1)) / columeCount) //計算完為整數．若有小數可能就會超出畫面進到下一行，（螢幕寬-cell間距數量）/cell數量
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = itemSpace  //上下間距
        flowLayout?.minimumInteritemSpacing = itemSpace  //左右間距
    }
    
    //URLSession網路連線抓圖
    func getImageFromUrl(url:URL?, completion: @escaping (UIImage?) -> Void) {
        if let url{
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data,
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    completion(image)
                }else{
                    completion(nil)
                }
            }.resume()
        }
    }
    
    // 透過網址取得照片
    func getImages(){
        for imageNumber in 1...50 {
            let imageNo = String(format: "%03d", imageNumber)
                                     // https://www.ghibli.jp/works/totoro/#&gid=1&pid=1 (totoro001)
            if let url = URL(string: "https://www.ghibli.jp/gallery/\(imageName)\(imageNo).jpg") {
                getImageFromUrl(url: url) { image in
                    if let image {
                        //將照片加入array中
                        self.images.append(image)
                        print("✅ get photo")
                    }
                }
            }
        }
    }
//    載入中的轉圈圈動畫
    func addLoadingView(){
        //設定與loadingView、loadingIndicator的尺寸&位置相同(置中填滿)
        loadingView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        //設定動畫
        loadingIndicator.startAnimating()
        //設定樣式:Medium、Large、Large White、White、Gray
        loadingIndicator.style = .large
        //在loadingView加入載入指示器
        loadingView.addSubview(loadingIndicator)
        //在主view加入指示器
        view.addSubview(loadingView)
    }

}
