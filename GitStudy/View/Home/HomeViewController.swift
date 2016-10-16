//
//  HomeViewController.swift
//  GitStudy
//
//  Created by ShinokiRyosei on 2016/10/06.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import JEToolkit

class HomeViewController: UIViewController {
    
    fileprivate let cellMargin: CGFloat = 2.0
    fileprivate var numbers: [CommitNumber] = []
    fileprivate var contributions: [[String: Int]] = []
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerCellClass(HomeViewCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numbers = CommitNumber.fetch()
        contributions = self.parse(numbers: numbers)
        collectionView.reloadData()
    }
    
    private func parse(numbers: [CommitNumber]) -> [[String: Int]] {
        let now = Date()
        var arr: [[String: Int]] = []
        for i in numbers {
            let dict: [String: Int] = ["day": i.createdAt.past(to: now), "contributions": i.contributions]
            arr.append(dict)
        }
        return arr
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 365
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: HomeViewCell.self, for: indexPath) as! HomeViewCell
        if let contribution: [String: Int] = contributions.filter({ $0["contributions"]! == indexPath.row }).first {
            cell.applyColor(of: true)
        }else {
            cell.applyColor()
        }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    private func toSegue() {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / 14
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
}
