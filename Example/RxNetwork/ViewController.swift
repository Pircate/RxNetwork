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
import Alamofire
import CleanJSON

//protocol Retryable {
//    var retry: Bool { get }
//}

enum DataType {
    case storyAPI
    case storyAPICache
    case storiAPICleanJSON
    case storyAPIMapJSON
    
    case bannerAPI
    case bannerAPICache
    case bannerAPIMapObject
    case bannerAPIMapJSON
    case bannerAPIOriginalModel
    case bannerAPIOriginalModelKeyPath
}

struct DataModel {
    let type: DataType
    let title: String
}

class ViewController: UIViewController {
    // MARK: - Property
    private let disposeBag = DisposeBag()
    private let datas = [
        DataModel(type: .storyAPI, title: "无缓存: StoryAPI.latest"),
        DataModel(type: .storyAPICache, title: "有缓存：StoryAPI.latest"),
        DataModel(type: .storiAPICleanJSON, title: "StoryAPI: CleanJSON"),
        DataModel(type: .storyAPIMapJSON, title: "storyAPI: MapJSON"),
        
        DataModel(type: .bannerAPI, title: "bannerAPI: 无缓存"),
        DataModel(type: .bannerAPICache, title: "bannerAPI: 缓存"),
        DataModel(type: .bannerAPIMapObject, title: "bannerAPI: MapObject"),
        DataModel(type: .bannerAPIMapJSON, title: "bannerAPI: mapJSON"),
        DataModel(type: .bannerAPIOriginalModel, title: "bannerAPI: OriginalModel"),
        DataModel(type: .bannerAPIOriginalModelKeyPath, title: "bannerAPI: OriginalModelKeyPath"),
        
    ]
    let cellID = "Cell"
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    
    // MARK: - Action
    
    
    // MARK: - Lazy
    /// 懒加载tv
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 0)))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        return tableView
    }()
}

// MARK: - Private Method
private extension ViewController {
    func makeUI() {
        navigationItem.title = "网络测试"
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 44),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
    func configNetwork() {
        Network.Configuration.default.timeoutInterval = 20
        Network.Configuration.default.plugins = [NetworkIndicatorPlugin()]
        Network.Configuration.default.replacingTask = { target in
            // configure common parameters etc.
            switch target.task {
            case let .requestParameters(parameters, encoding):
                let params: [String: Any] = ["token": "", "sign": "", "body": parameters]
                return .requestParameters(parameters: params, encoding: encoding)
            default:
                return target.task
            }
        }
        
        Network.Configuration.default.addingHeaders = { target in
            if target.path.contains("user") { return ["userId": "123456789"] }
            return [:]
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = datas[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = datas[indexPath.row]
        switch data.type {
        case .storyAPI:
            /*
             {
             "top_stories": []
             }
             */
            StoryAPI.latest
                .onCache(StoryListModel.self, using: CleanJSONDecoder(), { (model) in
                    debugPrint("onCache:", model)
                })
                .request()
                .subscribe(onSuccess: { (model) in
                    debugPrint("onSuccess:", model)
                })
                .disposed(by: disposeBag)
            
        case .storyAPICache:
            StoryAPI.latest
                .cache
                .request()
                .map(StoryListModel.self, using: CleanJSONDecoder())
                .subscribe(onNext: { (model) in
                    debugPrint(model)
                }).disposed(by: disposeBag)
            
        case .storiAPICleanJSON:
            StoryAPI.latest.request()
                .map(StoryListModel.self, using: CleanJSONDecoder())
                .subscribe(onSuccess: { (model) in
                    debugPrint(model)
                })
            .disposed(by: disposeBag)
            
        case .storyAPIMapJSON:
            StoryAPI.latest.request()
                .mapJSON()
                .subscribe(onSuccess: { (json) in
                    debugPrint(json)
                })
                .disposed(by: disposeBag)
            
        case .bannerAPI:
            /*
             {
             "code": 2000,
             "message": "Ok",
             "result": []
             }
             */
            BannerAPI.test(count: 10)
                .onCache([BannerModel].self, atKeyPath: "result", { (models) in
                    debugPrint(models)
                })
                .requestObject()
                .subscribe(onSuccess: { (models) in
                    debugPrint(models)
                })
                .disposed(by: disposeBag)

        case .bannerAPICache:
            BannerAPI.test(count: 10)
                .cache
                .request()
                .mapObject([BannerModel].self)
                .subscribe(onNext: { (models) in
                    debugPrint("onNext:", models)
                })
                .disposed(by: disposeBag)

        case .bannerAPIMapObject:
            // 项目最外层已经处理
            BannerAPI.test(count: 10).request()
                .mapObject([BannerModel].self)
                .subscribe(onSuccess: { (models) in
                    debugPrint("without cache:", models)
                }).disposed(by: disposeBag)
            
        case .bannerAPIMapJSON:
            BannerAPI.test(count: 10).request()
                .mapJSON()
                .subscribe(onSuccess: { (json) in
                    debugPrint(json)
                }).disposed(by: disposeBag)
            
        case .bannerAPIOriginalModel:
            // 非约定接口，最外层结构和项目不一样
            StoryAPI.latest.request()
            .mapRawObject(StoryListModel.self, atKeyPath: nil)
                .subscribe(onSuccess: { (model) in
                    debugPrint(model)
                })
                .disposed(by: disposeBag)
            
        case .bannerAPIOriginalModelKeyPath:
            StoryAPI.latest.request()
                .mapRawObject([StoryItemModel].self, atKeyPath: "top_stories")
                .subscribe(onSuccess: { (models) in
                    debugPrint(models)
                })
                .disposed(by: disposeBag)

        }
    }
}
