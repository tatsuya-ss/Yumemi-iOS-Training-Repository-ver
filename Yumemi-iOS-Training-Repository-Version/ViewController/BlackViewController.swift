//
//  YellowViewController.swift
//  Yumemi-iOS-Training-Repository-Version
//
//  Created by 坂本龍哉 on 2021/04/27.
//

import UIKit

class BlackViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        print("黒viewがロード")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("黒viewがロードされた")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("黒viewが現れる前")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("黒色viewがレイアウトされる前")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("黒色viewがレイアウトされた後")
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("黒viewが現れた後")
        performSegue(withIdentifier: "weatherSeague", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("黒viewが消える前")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("黒viewが消えた後")
    }
    
    @IBAction func blackViewSegue(segue: UIStoryboardSegue) {
        
    }

}
