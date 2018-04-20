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
        
        // request with cache
        TestTarget.test(count: 10).cachedObject([TestModel].self, onCache: { (response) in
            debugPrint("onCache:", response.first?.name ?? "")
        }).request([TestModel].self, atKeyPath: "result").subscribe(onSuccess: { (response) in
            debugPrint("onSuccess:", response.first?.name ?? "")
        }).disposed(by: disposeBag)
        // or
        TestTarget.test(count: 10).cache.request([TestModel].self, atKeyPath: "result").subscribe(onNext: { (response) in
            debugPrint("onNext:", response.first?.name ?? "")
        }).disposed(by: disposeBag)
        
        // request without cache
        TestTarget.test(count: 10).request([TestModel].self, atKeyPath: "result").subscribe(onSuccess: { (response) in
            debugPrint("without cache:", response.first?.name ?? "")
        }).disposed(by: disposeBag)
        
        // map result
        TestTarget.test(count: 10).request().mapResult([TestModel].self, atKeyPath: "result").subscribe(onSuccess: { (result) in
            if let response = try? result.dematerialize() {
                debugPrint("map result", response.first?.name ?? "")
            }
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

