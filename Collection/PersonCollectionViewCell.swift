//
//  PersonCollectionViewCell.swift
//  Collection
//
//  Created by Artak Ter-Stepanyan on 06.02.24.
//

import Foundation
import UIKit

class PersonCollectionViewCell: UICollectionViewCell {

   @IBOutlet weak var customImageView: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!

   override func awakeFromNib() {
           super.awakeFromNib()
           customImageView.contentMode = .scaleAspectFill
           customImageView.clipsToBounds = true
       }

       func configure(with person: Person) {
           customImageView.layer.cornerRadius = 10
           nameLabel.text = "\(person.name.firstName)"

           if let imageUrl = URL(string: person.picture.mediumPicture) {
           let task = URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
           if let data = data, let image = UIImage(data: data) {
               DispatchQueue.main.async {
                       self.customImageView.image = image
                   }
               }
           }
           task.resume()
       }
   }
}
