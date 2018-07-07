//
//  ViewController.swift
//  CacheUtils
//
//  Created by Steven on 2018/7/7.
//  Copyright © 2018年 Steven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cacheLabel: UILabel!
    
    deinit {
        print("ViewController deinit")
    }
    
    @IBAction func next(_ sender: Any) {
        let nav = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        navigationController?.pushViewController(nav.visibleViewController!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func readCahce(_ sender: Any) {
        
        cacheLabel.text = CacheUtils.cacheSize()
        
    }
    
    @IBAction func cleanCache(_ sender: Any) {
        CacheUtils.cleanCache(pathKey: .all) {cleanedSize in
            cacheLabel.text = CacheUtils.cacheSize()
            print("清理了\(cleanedSize)")
        }
    }
    
}

