//
//  ViewController.swift
//  BirdLoaderExamples
//
//  Created by Abhijit Singh on 20/11/20.
//

import UIKit
import BirdLoader

class ViewController: UIViewController {
    
    private var loaders: [BirdLoader] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        addTapGesture()
    }
    
    func startLoading() {
        let directions: [BirdLoader.Direction] = [.facingRight, .facingLeft]
        let loaderViewHeight: CGFloat = view.bounds.height / CGFloat(directions.count)
        directions.enumerated().forEach { (index, direction) in
            let loaderProperties: BirdLoader.Properties = .init(
                hairColor: .systemRed,
                foreheadColor: .white,
                beardColor: .systemGray,
                beakColor: .systemYellow,
                mouthColor: .systemOrange,
                eyeColor: .black,
                startDirection: direction,
                duration: 0.4
            )
            let loader: BirdLoader = .init(properties: loaderProperties)
            view.addSubview(loader)
            loaders.append(loader)
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            loader.centerYAnchor.constraint(
                equalTo: view.topAnchor,
                constant: CGFloat(index) * loaderViewHeight + loaderViewHeight / 2
            ).isActive = true
            loader.widthAnchor.constraint(equalToConstant: 150).isActive = true
            loader.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
    }
    
    private func addTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(handleViewTapped)
            )
        )
    }
    
    @objc
    private func handleViewTapped() {
        loaders.forEach {
            $0.stopLoading()
        }
    }

}
