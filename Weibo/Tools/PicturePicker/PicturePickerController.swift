//
//  PicturePickerController.swift
//  Weibo
//
//  Created by 狗身狗面狗 on 2022/5/3.
//

import UIKit
private let PicturePickerCellId = "PicturePickerCellId"
private let PicturePickerLimitCount = 9
class PicturePickerController: UICollectionViewController {
    lazy var pictures = [UIImage]()
    /// 当前用户选中的照片索引
    private var selectedIndex = 0;
    
    // MARK: 构造函数
    init() {
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerCellId)
    }
    
    /// MARK: -照片选择器布局
    private class PicturePickerLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            // iPhone 6s下是2 iPhone 6s+ 是3
            // iOS9.0 之后 尤其是iPad支持分屏 不建议过分依赖UIScreen作为布局参照
            let count: CGFloat = 3
            let margin = UIScreen.main.scale * 4
            let w = ((collectionView?.bounds.width)! - (count + 1) * margin) / count
            itemSize = CGSize(width: w, height: w)
            sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: 0, right: margin)
            minimumLineSpacing = margin
            minimumInteritemSpacing = margin
        }
    }

}

// MARK: UICollectionViewDataSource
extension PicturePickerController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count + (pictures.count == PicturePickerLimitCount ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerCellId, for: indexPath) as! PicturePickerCell
//        cell.backgroundColor = UIColor.red
        cell.pictureDelegate = self
        cell.image = (indexPath.item < pictures.count) ? pictures[indexPath.item] : nil
        return cell
    }
}

// MARK: PicturePickerCellDelegate
extension  PicturePickerController: PicturePickerCellDelegate{
    @objc fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        // 判断是否运行访问相册
        /**
         PhotoLibrary    保存的照片（可以删除） 同步的照片 （不允许删除）
        savedPhotosAlbum 保存的照片/ 屏幕截图 / 拍照
         */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            print("无法访问照片库")
            return
        }
        
        selectedIndex = collectionView!.indexPath(for: cell)?.item ?? 0
        
        // 显示照片选择器
        let picker = UIImagePickerController()
        picker.delegate = self
        // 适合头像选择
//        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc fileprivate func picturePickerCellDidRemove(cell: PicturePickerCell) {
        let indexPath = collectionView!.indexPath(for: cell)!
        let index = indexPath.item
        if index >= pictures.count {
            return
        }
        pictures.remove(at: index)
        collectionView.deleteItems(at: [indexPath])
    }
}

// MARK: 照片选择器delegate
/**
 如果使用cocos2dx 开发一个空白的模版游戏, 内存占70M, iOS UI的空白应用程序, 大概20M
 一般应用程序 内存在100M左右都是能够接受的
 */
extension PicturePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let scaleImage = image.scaleToWidth(width: 600)
        if selectedIndex >= pictures.count {
            pictures.append(scaleImage)
        } else {
            pictures[selectedIndex] = scaleImage
            
        }
        collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: PicturePickerCellDeleagte 协议
/// 如果协议中包含optional 协议使用@objc修饰
@objc
private protocol PicturePickerCellDelegate: NSObjectProtocol {
    /// 添加照片
    @objc optional func picturePickerCellDidAdd(cell: PicturePickerCell)
    
    /// 删除照片
    @objc optional func picturePickerCellDidRemove(cell: PicturePickerCell)
}


// MARK: 自定义cell
// private修饰类, 内部的一切方法和属性都是私有的
private class PicturePickerCell: UICollectionViewCell {
    /// 照片选择代理
    weak var pictureDelegate: PicturePickerCellDelegate?
    
    var image: UIImage? {
        didSet {
            
            addButton.setImage(image ?? UIImage(named: "compose_pic_add"), for: UIControl.State.normal)
            removeButton.isHidden = (image == nil)
        }
    }
    
    // MARK: 监听方法
    @objc func addPicture() {
        pictureDelegate?.picturePickerCellDidAdd?(cell: self)
    }
    
    @objc func removePicture() {
        pictureDelegate?.picturePickerCellDidRemove?(cell: self)
    }
    
    // MARK: 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI
    private func setupUI() {
        // 添加控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 设置布局
        addButton.frame = bounds
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
        
        // 监听
        addButton.addTarget(self, action: #selector(addPicture), for: UIControl.Event.touchUpInside)
        removeButton.addTarget(self, action: #selector(removePicture), for: UIControl.Event.touchUpInside)
        
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.clipsToBounds = true
    }
    
    
    // MARK: 懒加载控件
    /// 添加按钮
    private lazy var addButton: UIButton = UIButton(imageName: "compose_pic_add", bgImageName: nil)
    
    /// 删除按钮
    private lazy var removeButton: UIButton = UIButton(imageName: "compose_pic_delete", bgImageName: nil)
}
