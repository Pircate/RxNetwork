# RxNetwork

[![CI Status](http://img.shields.io/travis/G-Xi0N/RxNetwork.svg?style=flat)](https://travis-ci.org/G-Xi0N/RxNetwork)
[![Version](https://img.shields.io/cocoapods/v/RxNetwork.svg?style=flat)](http://cocoapods.org/pods/RxNetwork)
[![License](https://img.shields.io/cocoapods/l/RxNetwork.svg?style=flat)](http://cocoapods.org/pods/RxNetwork)
[![Platform](https://img.shields.io/cocoapods/p/RxNetwork.svg?style=flat)](http://cocoapods.org/pods/RxNetwork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RxNetwork is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxNetwork'
```

## Usage

### Import

``` swift
import RxNetwork
```

### Configure

``` swift
Network.shared.timeoutInterval = 20 // set timeout interval
Network.shared.plugins = [NetworkIndicatorPlugin()] // add plugin
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
```

### Request with cache

![](https://github.com/Ginxx/RxNetwork/blob/master/Example/cached_object.png)

![](https://github.com/Ginxx/RxNetwork/blob/master/Example/cache.png)

### Request without cache

![](https://github.com/Ginxx/RxNetwork/blob/master/Example/without_cache.png)

## Author

gaoX, gao497868860@163.com

## License

RxNetwork is available under the MIT license. See the LICENSE file for more info.
