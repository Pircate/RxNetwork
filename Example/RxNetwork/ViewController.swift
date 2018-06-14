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
        
        Network.default.timeoutInterval = 20
        Network.default.plugins = [NetworkIndicatorPlugin()]
        Network.default.taskClosure = { target in
            // configure common parameters etc.
            switch target.task {
            case let .requestParameters(parameters, encoding):
                let params: [String: Any] = ["token": "", "sign": "", "body": parameters]
                return .requestParameters(parameters: params, encoding: encoding)
            default:
                return target.task
            }
        }
        
        // MARK: - request with cache
        /*
         {
            "top_stories": []
         }
         */
        StoryAPI.latest
            .onCache(StoryListModel.self, { (model) in
                debugPrint("onCache:", model.topStories.first?.title ?? "")
            })
            .request()
            .subscribe(onSuccess: { (model) in
                debugPrint("onSuccess:", model.topStories.first?.title ?? "")
            })
            .disposed(by: disposeBag)
        
        StoryAPI.latest
            .cache
            .request()
            .map(StoryListModel.self)
            .subscribe(onNext: { (model) in
                
            }).disposed(by: disposeBag)
        // or
        /*
         {
            "code": 2000,
            "message": "Ok",
            "result": []
         }
         */
        TestTarget.test(count: 10)
            .onCache([TestModel].self, { (models) in
                
            })
            .requestObject()
            .subscribe(onSuccess: { (models) in
                
            })
            .disposed(by: disposeBag)
        
        TestTarget.test(count: 10)
            .cache
            .request()
            .mapObject([TestModel].self)
            .subscribe(onNext: { (models) in
                debugPrint("onNext:", models.first?.name ?? "")
            })
            .disposed(by: disposeBag)
        
        // MARK: - request without cache
        TestTarget.test(count: 10)
            .request()
            .mapObject([TestModel].self)
            .subscribe(onSuccess: { (models) in
                debugPrint("without cache:", models.first?.name ?? "")
            }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

