//
//  ViewController.swift
//  Collection
//
//  Created by Artak Ter-Stepanyan on 06.02.24.
//

import UIKit

class ViewController: UIViewController {

    private let url: String = "https://randomuser.me/api?seed=artak&results=100"

    @IBOutlet weak var personCollectionView: UICollectionView!

    var personData: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        personCollectionView.register(nib, forCellWithReuseIdentifier: "customCell")

        parseJson(from: url) { data in
            self.personData = data
            DispatchQueue.main.async {
                self.personCollectionView.reloadData()
            }
        }
    }

    private func parseJson(from url: String, completion: @escaping ([Person]) -> Void) {

        let task = URLSession.shared.dataTask(with: URL(string: url)!) {data, _, error in

            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }

            var result: Response?

            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("failed to convert \(error.localizedDescription)")
            }

            guard let personResponse = result else {
                return
            }
            completion(personResponse.results)
        }
        task.resume()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? PersonCollectionViewCell

        let person = personData[indexPath.item]
        cell?.configure(with: person)

        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 80, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 10
    }
}

struct Response: Codable {
    let results: [Person]
}

struct Person: Codable {
    let name: Name
    let picture: Picture

}

struct Name: Codable {

    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
    }
}

struct Picture: Codable {

    let mediumPicture: String

    enum CodingKeys: String, CodingKey {
        case mediumPicture = "medium"
    }
}
