//
//  MenuViewController.swift
//  spitro
//
//  Created by Bruno Pastre on 17/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    lazy var startButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.onStart), for: .touchDown)
        button.setTitle("Start", for: .normal)
        
        return button
    }()
    
    let loadingView: UIView = {
        let view = UIView()
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        
        view.backgroundColor = UIColor.white
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
    
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupStartButton()
    }
    
    func setupStartButton(){
        self.view.addSubview(self.startButton)
        
        self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.startButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.startButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        self.startButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
    
    }
    
    
    func presentLoadingView(){
        self.view.addSubview(self.loadingView)
        
        self.loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.loadingView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        self.loadingView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        
        self.loadingView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.loadingView.alpha = 1
        }
    }
    
    func dismissLoadingView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 0
        }) { (_) in
            self.loadingView.removeFromSuperview()
        }
    }
    
    @objc func onStart() {
        self.presentLoadingView()
        ConnectionFacade.instance.setupConnection()
        self.dismissLoadingView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
