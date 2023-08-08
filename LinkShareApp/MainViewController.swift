//
//  MainViewController.swift
//  LinkShareApp
//
//  Created by Faiz Ul Hassan on 08/08/2023.
//

import UIKit
import LinkPresentation


class MainViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    var cellItems: [CellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgCollectionView.isHidden = true
        
        if cellItems.isEmpty {return}
        if let url = cellItems[0].url{
            self.loadMetadata(for: url)
        }
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
                    self?.title = metadata.title
                }
                
                if let imageProvider = metadata.imageProvider {
                    imageProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            // Display the image in your app
                            DispatchQueue.main.async {
                                self.addImageView(image: image)
                            }
                        }
                    }
                }
            } else if let error = error {
                print("Error fetching link preview: \(error)")
            }
        }
    }
    
    func addLinkView(metadata: LPLinkMetadata) {
        let linkView = LPLinkView(metadata: metadata)
        linkView.bounds = CGRect(x: 0, y: 0, width: 300, height: 150)
        stackView.addArrangedSubview(linkView)
    }
        
    func addImageView(image: UIImage) {
        let linkView = UIImageView(image: image)
        linkView.bounds = CGRect(x: 0, y: 0, width: 300, height: 150)
        stackView.addArrangedSubview(linkView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openPhotos(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return self.cellItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = cellItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.item = data
        cell.imgViewwidth.constant = cell.frame.size.width
        cell.imgViewHeight.constant = cell.frame.size.height
        cell.backgroundColor = .gray
        return cell
    }
}
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            // Handle the selected image here
            // For example, you can display the image in an image view
            self.cellItems.append(CellModel(image: image));
            self.imgCollectionView.reloadData()
//            self.imgCollectionView.isHidden = false
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
