//
//  ViewController.swift
//  RxNetwork
//
//  Created by G-Xi0N on 04/19/2018.
//  Copyright (c) 2018 G-Xi0N. All rights reserved.
//

import UIKit
import RxNetwork
import RxSwift
import Moya

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network.shared.timeoutInterval = 20
        Network.shared.plugins = [NetworkIndicatorPlugin()]
        
        TestTarget.test(count: 10).cachedObject([TestModel].self, onCache: { (response) in
            debugPrint("onCache")
            debugPrint(response)
        }).request([TestModel].self, atKeyPath: "result").subscribe(onSuccess: { (response) in
            debugPrint("onSuccess")
            debugPrint(response)
        }, onError: nil).disposed(by: disposeBag)
        
        //        TestTarget.test(count: 10).request([TestModel].self, atKeyPath: "result").subscribe(onSuccess: { (response) in
        //            debugPrint("onSuccess")
        //            debugPrint(response)
        //        }, onError: nil).disposed(by: disposeBag)
        
        TestTarget.test(count: 10).cache.request([TestModel].self, atKeyPath: "result").subscribe(onNext: { (response) in
            debugPrint("onNext")
            debugPrint(response)
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

