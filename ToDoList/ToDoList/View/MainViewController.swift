//
//  MainViewController.swift
//  ToDoList
//
//  Created by Элина Борисова on 01.07.2023.
//

import UIKit
//import CocoaLumberjackSwift
//import FileCachePackage

class MainViewController: UIViewController {
    
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitle("+", for: .normal)

        
        return button
    }()
    
    private let myToDo: UILabel = {
        let label = UILabel()
        label.text = "Мои дела"
        label.font = UIFont.init(name: "SFProDisplay-Bold", size: 38)

        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.nextButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        
        self.view.addSubview(nextButton)
        self.view.addSubview(myToDo)
        self.myToDo.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            nextButton.widthAnchor.constraint(equalToConstant: 44),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 166),
            
            myToDo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myToDo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32)
            
            
        ])
    }
    
    @objc func didTapButton() {
        let vc = ToDoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
