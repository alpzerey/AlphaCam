//
//  filterView.swift
//  MyCam
//
//  Created by Alp Zerey on 28.02.2019.
//  Copyright © 2019 Alp Zerey. All rights reserved.
//

import UIKit
import Photos





class filterView: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate 
{
     public var indexFilter : Int = 0
     public var selectedFilter :Bool = false
    
    
    
    
    public var labels : [String] = []
    var mySimpleFilterView: UICollectionView!
    var cellId = "filterCell"
    
    public var simpleImage : [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mySimpleFilterView.collectionViewLayout.invalidateLayout()
        
    }
    
    
    func createView()->UIView
    {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .horizontal
        mySimpleFilterView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height-200, width: view.frame.width, height: 100), collectionViewLayout: layout)
        mySimpleFilterView.dataSource = self
        mySimpleFilterView.delegate = self
        mySimpleFilterView.register(LabelItemCell.self, forCellWithReuseIdentifier: cellId)
        mySimpleFilterView.showsHorizontalScrollIndicator = false
        mySimpleFilterView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        mySimpleFilterView.alpha = 0
        
        mySimpleFilterView.isHidden = true
        return mySimpleFilterView
    }
    
    func hideShowview(hide : Bool)
    {
       if(mySimpleFilterView.alpha == 0 && !hide)
            {
                mySimpleFilterView.isHidden = hide
                mySimpleFilterView.alpha = 0
                UIView.animate(withDuration: 0.5) {
                    
                    self.mySimpleFilterView.alpha = 1
                }
            }
            else if(mySimpleFilterView.alpha == 1 && hide)
            {
                mySimpleFilterView.alpha = 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.mySimpleFilterView.alpha = 0
                }){(finished) in
                    self.mySimpleFilterView.isHidden = finished
                }
            }
    }
    
    func hideShowviewToggle()
    {
        if(mySimpleFilterView.alpha == 0 && mySimpleFilterView.isHidden)
        {
            mySimpleFilterView.isHidden = !mySimpleFilterView.isHidden
            mySimpleFilterView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                
                self.mySimpleFilterView.alpha = 1
            }
        }
        else if(mySimpleFilterView.alpha == 1 && !mySimpleFilterView.isHidden)
        {
            mySimpleFilterView.alpha = 1
            UIView.animate(withDuration: 0.3, animations: {
                self.mySimpleFilterView.alpha = 0
            }){(finished) in
                self.mySimpleFilterView.isHidden = finished
            }
        }
        
    }
    
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return simpleImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LabelItemCell
        
        
        cell.img.image = simpleImage[indexPath.row]
        
        cell.textLabel.text = labels[indexPath.row]
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width-5
        let height = collectionView.frame.height-10
        return CGSize(width: width/5 - 1, height: height)
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
       indexFilter = indexPath.row
        selectedFilter = !selectedFilter
    }
    
    
    
}

class LabelItemCell: UICollectionViewCell {
    
    var img = UIImageView()
    let filterLabel = String()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        //label.text = "Bos"
        
        
        
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.darkGray
        img.layer.cornerRadius = 10
        img.clipsToBounds=true
        setupfilterView()
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        img.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupfilterView()
    {
        self.addSubview(img)
        addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: img.bottomAnchor, constant: -15).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //textLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
