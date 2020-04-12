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
import SwiftyJSON

//protocol Retryable {
//    var retry: Bool { get }
//}

enum DataType {
    case storyAPIMapJSON
    case storiAPIMapModel
    case storyAPICacheModel
    case storyAPICacheData
    
    case bannerAPIMapJSON
    case bannerAPIMapModel
    case bannerAPIMapRawModel
    case bannerAPIMapRawModelKeyPath
    case bannerAPICacheData
    case bannerAPICacheModel
}

struct DataModel {
    let type: DataType
    let title: String
}

class ViewController: UIViewController {

    // MARK: - Property
    private let disposeBag = DisposeBag()
    private let datas = [
        DataModel(type: .storyAPIMapJSON, title: "storyAPI: 无缓存，原始 JSON"),
        DataModel(type: .storiAPIMapModel, title: "StoryAPI: 无缓存，转 model"),
        DataModel(type: .storyAPICacheData, title: "StoryAPI: 缓存 data"),
        DataModel(type: .storyAPICacheModel, title: "StoryAPI: 缓存 model"),
        
        DataModel(type: .bannerAPIMapJSON, title: "bannerAPI: 无缓存，原始 JSON"),
        DataModel(type: .bannerAPIMapModel, title: "bannerAPI: 无缓存， 转外层已处理好的 model"),
        DataModel(type: .bannerAPIMapRawModel, title: "bannerAPI: 无缓存，转原始 model"),
        DataModel(type: .bannerAPIMapRawModelKeyPath, title: "bannerAPI: 转原始 keypath model"),
        DataModel(type: .bannerAPICacheData, title: "bannerAPI: 缓存 data"),
        DataModel(type: .bannerAPICacheModel, title: "bannerAPI: 缓存原始 model"),
        
    ]
    let cellID = "Cell"
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNetwork()
        makeUI()
    }
    
    
    // MARK: - Action
    
    
    // MARK: - Lazy
    /// 懒加载 表格
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
        Network.Configuration.default.timeoutInterval = 30
        
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
            // MARK: storyAPI
        case .storyAPIMapJSON:
            Network.Configuration.default.timeoutInterval = 10
            StoryAPI.latest.request()
                .mapJSON()
                .subscribe(onSuccess: { (json) in
                    QL1(JSON(rawValue: json))
                })
                .disposed(by: disposeBag)

        case .storiAPIMapModel:
            Network.Configuration.default.timeoutInterval = 30
            StoryAPI.latest.request()
                .map(StoryListModel.self, using: CleanJSONDecoder())
                .subscribe(onSuccess: { (model) in
                    QL1(model)
                })
                .disposed(by: disposeBag)
            
        case .storyAPICacheData:
            StoryAPI.latest
                .cache
                .request()
                .map(StoryListModel.self, using: CleanJSONDecoder())
                .subscribe(onNext: { (model) in
                    QL1(model)
                }).disposed(by: disposeBag)
            
        case .storyAPICacheModel:
            StoryAPI.latest
                .onCache(StoryListModel.self, using: CleanJSONDecoder(), { (model) in
                    QL1("onCache:", model)
                })
                .request()
                .subscribe(onSuccess: { (model) in
                    QL1("onSuccess:", model)
                })
                .disposed(by: disposeBag)
            
            
            // MARK: bannerAPI
        case .bannerAPIMapJSON:
            BannerAPI.test(count: 10).request()
                .mapJSON()
                .subscribe(onSuccess: { (json) in
                    QL1(JSON(rawValue: json))
                }).disposed(by: disposeBag)
            
        case .bannerAPIMapModel:
            // 项目最外层已经处理
            BannerAPI.test(count: 10).request()
                .mapObject([BannerModel].self)
                .subscribe(onSuccess: { (models) in
                    QL1("without cache:", models)
                }).disposed(by: disposeBag)
            
        case .bannerAPIMapRawModel:
            // 非约定接口，最外层结构和项目不一样
            StoryAPI.latest.request()
                .map(StoryListModel.self, atKeyPath: nil, using: CleanJSONDecoder(), failsOnEmptyData: true)
                .subscribe(onSuccess: { (model) in
                    QL1(model)
                })
                .disposed(by: disposeBag)
            
        case .bannerAPIMapRawModelKeyPath:
            StoryAPI.latest.request()
                .map([StoryItemModel].self, atKeyPath: "top_stories", using: CleanJSONDecoder(), failsOnEmptyData: true)
                .subscribe(onSuccess: { (models) in
                    QL1(models)
                })
                .disposed(by: disposeBag)
        
        case .bannerAPICacheData:
            BannerAPI.test(count: 10)
                .cache
                .request()
                .mapObject([BannerModel].self)
                .subscribe(onNext: { (models) in
                    QL1("onNext:", models)
                })
                .disposed(by: disposeBag)
            
        case .bannerAPICacheModel:
            BannerAPI.test(count: 10)
                .onCache([BannerModel].self, atKeyPath: "result", { (models) in
                    QL1(models)
                })
                .requestObject()
                .subscribe(onSuccess: { (models) in
                    QL1(models)
                })
                .disposed(by: disposeBag)

        }
    }
}
