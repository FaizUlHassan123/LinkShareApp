//
//  ShareViewController.swift
//  LinkShareExtension
//
//  Created by Faiz Ul Hassan on 08/08/2023.
//

import UIKit
import Social
import MobileCoreServices
import Toast
import UniformTypeIdentifiers
import LinkPresentation

class ShareViewController: UIViewController {
    
    let sharedKey = "ImageSharePhotoKey"
    
    var selectedImages: [CellModel] = []
    var imagesData: [String:Any] = [:]
    
    @IBOutlet weak var vwStack: UIStackView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        
        // Assuming you have an attachment
        if let attachment = content.attachments?.first {
            let contentTypeImage = UTType.image.description as String // Replace with the desired type
            let contentTypeURL = UTType.url.description as String // Replace with the desired type
            
            
            if attachment.hasItemConformingToTypeIdentifier(contentTypeImage) {
                self.imgCollectionView.isHidden = false
                self.vwStack.isHidden = true
                self.manageImages()
            } else if attachment.hasItemConformingToTypeIdentifier(contentTypeURL) {
                self.vwStack.isHidden = false
                self.imgCollectionView.isHidden = true
                self.manageURL()
            }else{
                print("Error content type is mot imager or URL")
                self.view.makeToast("Error content type is mot imager or URL \(attachment) \(contentTypeURL)", duration: 3.0, position: .bottom)
            }
        }
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.redirectToHostApp()
    }
    
    
    func loadMetadata(for url: URL) {
        let metadataProvider = LPMetadataProvider()
        
        metadataProvider.startFetchingMetadata(for: url) { (returnedMetadata, error) in
            if let metadata = returnedMetadata, error == nil {
                print("Title: " + (metadata.title ?? "No Title"))
                print("description: " + (metadata.description))
                print(metadata)
                
                DispatchQueue.main.async { [weak self] in
                    self?.addLinkView(metadata: metadata)
                }
            }
        }
    }
    
    func addLinkView(metadata: LPLinkMetadata) {
        let linkView = LPLinkView(metadata: metadata)
        linkView.bounds = CGRect(x: 0, y: 0, width: 300, height: 150)
        vwStack.addArrangedSubview(linkView)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func redirectToHostApp() {
        print(#function)
        let url = URL(string: "LinkShareApp://dataUrl=\(sharedKey)")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func manageImages() {
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = UTType.image.description as String
        
        for (index, attachment) in (content.attachments!).enumerated() {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { [weak self] data, error in
                    
                    if error == nil, let url = data as? URL, let this = self {
                        do {
                            
                            // GETTING RAW DATA
                            let rawData = try Data(contentsOf: url)
                            let rawImage = UIImage(data: rawData)
                            
                            // CONVERTED INTO FORMATTED FILE : OVER COME MEMORY WARNING
                            // YOU USE SCALE PROPERTY ALSO TO REDUCE IMAGE SIZE
                            let image = UIImage.resizeImage(image: rawImage!, width: 100, height: 100)
                            let imgData = image.pngData()
                            
                            this.selectedImages.append(CellModel(image: rawImage));
                            this.imagesData["image"] = imgData!
                            //                            this.imagesData.append(imgData!)
                            
                            if index == (content.attachments?.count)! - 1 {
                                DispatchQueue.main.async {
                                    this.imgCollectionView.reloadData()
                                    let userDefaults = UserDefaults(suiteName: "group.com.sdsol.sharesheet")
                                    userDefaults?.set(this.imagesData, forKey: this.sharedKey)
                                    userDefaults?.synchronize()
                                }
                            }
                        }
                        catch let exp {
                            print("GETTING EXCEPTION \(exp.localizedDescription)")
                        }
                        
                    } else {
                        print("GETTING ERROR")
                        let alert = UIAlertController(title: "Error", message: "Error loading image \(error?.localizedDescription ?? "") ", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func manageURL() {
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = UTType.url.description as String
        

        for (_, attachment) in (content.attachments!).enumerated() {

            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { [weak self] data, error in
                    
                    if error == nil, let url = data as? URL, let this = self {
                        
                        //                        this.downloadImage(from: url) { image in
                        //                            if let image = image {
                        //                                let resizedImage = UIImage.resizeImage(image: image, width: 100, height: 100)
                        //                                let imgData = resizedImage.pngData()
                        
                        //                                this.selectedImages.append(resizedImage)
                        //                        self?.imagesData["URL"] = try? Data(contentsOf: url)
                        
                        this.selectedImages.append(CellModel(url: url));
                        self?.imagesData["URL"] = url.absoluteString
                        
                        
                        //                        if index == (content.attachments?.count)! - 1 {
                        DispatchQueue.main.async {
                            this.imgCollectionView.reloadData()
                            let userDefaults = UserDefaults(suiteName: "group.com.sdsol.sharesheet")
                            userDefaults?.set(self?.imagesData, forKey: this.sharedKey)
                            userDefaults?.synchronize()
                            this.loadMetadata(for: url)
                        }
                        
                        
                        
                        //                    }
                        //                        }
                        //                            }
                        //                        }+
                        
                    } else {
                        print("GETTING ERROR")
                        
                        let alert = UIAlertController(title: "Error", message: "Error loading URL \(error?.localizedDescription ?? "") ", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                
                
            }
        }
        
    }
}

extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.size
        let width = viewWidth.width / 3 - 30
        let height = viewWidth.height / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = selectedImages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.item = data
        cell.imgViewwidth.constant = cell.frame.size.width
        cell.imgViewHeight.constant = cell.frame.size.height
        cell.backgroundColor = .gray
        return cell
    }
}

extension UIImage {
    class func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
