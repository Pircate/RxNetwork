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
        Network.shared.taskClosure = { target in
            // configure common parameters etc.
            switch target.task {
            case let .requestParameters(parameters, encoding):
                let params: [String: Any] = ["token": "", "sign": "", "body": parameters]
                return .requestParameters(parameters: params, encoding: encoding)
            default:
                return target.task
            }
        }
        
        // request with cache
        TestTarget.test(count: 10)
            .cachedObject([TestModel].self, onCache: { (response) in
                debugPrint("onCache:", response.first?.name ?? "")
            })
            .request([TestModel].self, atKeyPath: "result")
            .subscribe(onSuccess: { (response) in
                debugPrint("onSuccess:", response.first?.name ?? "")
            })
            .disposed(by: disposeBag)
        // or
        TestTarget.test(count: 10).cache
            .request([TestModel].self, atKeyPath: "result")
            .subscribe(onNext: { (response) in
                debugPrint("onNext:", response.first?.name ?? "")
            })
            .disposed(by: disposeBag)
        
        // request without cache
        TestTarget.test(count: 10)
            .request([TestModel].self, atKeyPath: "result")
            .subscribe(onSuccess: { (response) in
                debugPrint("without cache:", response.first?.name ?? "")
            })
            .disposed(by: disposeBag)
        
        TestTarget.test(count: 10).request(TestResponse<[TestModel]>.self)
            .subscribe(onSuccess: { (response) in
                debugPrint("status code:", response.code)
            }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

