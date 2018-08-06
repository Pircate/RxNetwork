//
//  ViewController.swift
//  RxNetwork
//
//  Created by Pircate on 04/19/2018.
//  Copyright (c) 2018 Pircate. All rights reserved.
//

import UIKit
import RxNetwork
import RxSwift
import Moya

class ViewController: UIViewController {
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.center = view.center
        button.backgroundColor = UIColor.blue
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network.Configuration.default.timeoutInterval = 20
        Network.Configuration.default.plugins = [NetworkIndicatorPlugin()]
        Network.Configuration.default.taskClosure = { target in
            // configure common parameters etc.
            switch target.task {
            case let .requestParameters(parameters, encoding):
                let params: [String: Any] = ["token": "", "sign": "", "body": parameters]
                return .requestParameters(parameters: params, encoding: encoding)
            default:
                return target.task
            }
        }
        
        view.addSubview(startButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func startButtonAction() {
        
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
        BannerAPI.test(count: 10)
            .onCache([BannerModel].self, { (models) in
                
            })
            .requestObject()
            .subscribe(onSuccess: { (models) in
                
            })
            .disposed(by: disposeBag)
        
        BannerAPI.test(count: 10)
            .cache
            .request()
            .mapObject([BannerModel].self)
            .subscribe(onNext: { (models) in
                debugPrint("onNext:", models.first?.name ?? "")
            })
            .disposed(by: disposeBag)
        
        // MARK: - request without cache
        BannerAPI.test(count: 10)
            .request()
            .mapObject([BannerModel].self)
            .subscribe(onSuccess: { (models) in
                debugPrint("without cache:", models.first?.name ?? "")
            }).disposed(by: disposeBag)
    }
}

