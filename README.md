# RxNetwork

[![CI Status](http://img.shields.io/travis/Pircate/RxNetwork.svg?style=flat)](https://travis-ci.org/Pircate/RxNetwork)
[![Version](https://img.shields.io/cocoapods/v/RxNetwork.svg?style=flat)](http://cocoapods.org/pods/RxNetwork)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/RxNetwork.svg?style=flat)](http://cocoapods.org/pods/RxNetwork)
[![Platform](https://img.shields.io/cocoapods/p/RxNetwork.svg?style=flat)](https://cocoapods.org/pods/RxNetwork)
[![codebeat badge](https://codebeat.co/badges/03811ea6-f2a0-46fe-b7b3-24e56d00c1b0)](https://codebeat.co/projects/github-com-pircate-rxnetwork-master)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 9.0
* Swift 5.0

## Installation

RxNetwork is available through [CocoaPods](http://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Podfile or Cartfile:

#### Podfile

```ruby
pod 'RxNetwork'
```
缓存
```ruby
pod 'RxNetwork/Cacheable'
```

#### Cartfile
```ruby
github "Pircate/RxNetwork"
```

## Usage

### Import

``` swift
import RxNetwork
```

### Configuration

```swift
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

// or

let configuration = Network.Configuration()
configuration.timeoutInterval = 20
configuration.plugins = [NetworkIndicatorPlugin()]
Network.Configuration.default = configuration
```

### Allow storage strategy

确保缓存的数据是正确的 JSON 格式，否则解析数据的时候会失败导致序列抛出异常。

如下，仅当 code 为 200 时返回的数据才是正确的 JSON 格式。

```
extension Storable where Self: TargetType {
    
    public var allowsStorage: (Moya.Response) -> Bool {
        return {
            do {
                return try $0.mapCode() == 200
            } catch {
                return false
            }
        }
    }
}
```

### Request without cache

```swift
StoryAPI.latest
    .request()
    .map(StoryListModel.self)
    .subscribe(onSuccess: { (model) in
        
    }).disposed(by: disposeBag)
```

### Request with cache

```swift
/*
 {
    "top_stories": []
 }
 */
StoryAPI.latest
    .onCache(StoryListModel.self, { (model) in
        
    })
    .request()
    .subscribe(onSuccess: { (model) in
        
    })
    .disposed(by: disposeBag)

StoryAPI.latest
    .cache
    .request()
    .map(StoryListModel.self)
    .subscribe(onNext: { (model) in

    }).disposed(by: disposeBag)
```

```swift
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
        
    })
    .disposed(by: disposeBag)
```

### Cacheable

为 `target` 提供缓存功能，请遵循 `Cacheable` 协议

```swift
enum API: TargetType, Cacheable {
    case api
    
// 设置缓存过期时间
    var expiry: Expiry {
        return .never
    }
}
```

## Author

Pircate, gao497868860@163.com

## License

RxNetwork is available under the MIT license. See the LICENSE file for more info.
