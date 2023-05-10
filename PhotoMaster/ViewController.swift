//
//  ViewController.swift
//  PhotoMaster
//
//  Created by 杉井位次 on 2023/05/10.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //写真表示用ImageView
    @IBOutlet var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTappedCameraButton() {
        presentPickConroller(sourceType: .camera)
    }
    
    @IBAction func onTappedAlbumButton() {
        presentPickConroller(sourceType: .photoLibrary)
    }
    
    @IBAction func onTappedTextButton() {
        if photoImageView.image != nil {
            photoImageView.image = drawText(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }
    
    @IBAction func onTappedIllustButton() {
        if photoImageView.image != nil {
            photoImageView.image = drawMaskImage(image: photoImageView.image!)
        } else {
            print("画像がありません")
        }
    }
    
    
    //カメラ、アルバムの呼び出しメソッド（カメラorアルバムのソースタイプが引数）
    func presentPickConroller(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    //写真が選択された時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        //画像を出力
        photoImageView.image = info[.originalImage] as? UIImage
    }
    
    func drawText(image: UIImage) -> UIImage {
        
        //テキストの内容の設定
        let text = "LifeisTech!"
        
        //textFontAttributes: 文字の特性[フォントとサイズ、カラー、スタイル]の設定
        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 120)!,
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        //グラフィックスコンテキストの生成・編集を開始
        UIGraphicsBeginImageContext(image.size)
        //読み込んだ画像を書き出す
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        //定義　CGRect(x: [左からのx座標], y: [上からのy座標], width: [横の長さ]px, height: [縦の長さ]px)
        let margin: CGFloat = 5.0
        let textRect = CGRect(x: margin, y: margin, width: image.size.width - margin, height: image.size.height - margin)
        
        //textRectで指定した範囲にtextを書き出す
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //元の画像にイラストを合成するメソッド
    func drawMaskImage(image: UIImage) -> UIImage {
        
        //マスク画像の設定
        let maskImage = UIImage(named: "furo_ducky")!
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    
        let margin: CGFloat = 50.0
        let maskRect = CGRect(x: image.size.width - maskImage.size.width - margin,
                              y: image.size.height - maskImage.size.height - margin,
                              width: maskImage.size.width, height: maskImage.size.height)
        
        maskImage.draw(in: maskRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

