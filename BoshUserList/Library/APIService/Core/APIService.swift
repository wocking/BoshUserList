//
//  APIService.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import Moya
import Alamofire
import PromiseKit

struct APIService<ModelType> where ModelType: Codable {
    typealias progressBlock = ((Double) -> ())?
    typealias successCallback = (ModelType) -> Void
    typealias failureCallback = (MoyaError) -> Void
    
    let provider: MoyaProvider<MultiTarget> = {
        return MoyaProvider<MultiTarget>(plugins: [ hudPlugin, NetworkLoggerPlugin(verbose: true)])
    }()
    
    func cancelAllRequest() {
        provider.manager.session.getAllTasks { (tasks) in
            tasks.forEach { $0.cancel() }
        }
    }
    
    fileprivate func showFailHUD(_ error: (MoyaError)) {
        var title = ""
        switch error {
        case let .underlying(nsError as NSError, _):
            title = nsError.code == -1009 ? "沒有網路連線" : ""
        default:
            break
        }
        
        DispatchQueue.main.async {
            HUDService.flashError(message: title)
        }
    }
}


// MARK: Clourse version
extension APIService {
    
    func request<APIModuleType: TargetType & MoyaAddable> (
        _ apiModule: APIModuleType,
        progerss progressBlock: progressBlock = nil,
        success successCallback: @escaping successCallback,
        failure failureCallback: @escaping failureCallback
        ) {
        
        provider.request(
            MultiTarget(apiModule),
            callbackQueue: DispatchQueue.global(),
            progress: { response in
                progressBlock?(response.progress)
        }, completion: { response in
            switch response {
            case let .success(moyaResponse):
                // 過濾http status code & Json parse error
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let responseModel = try filteredResponse.map(ModelType.self)
                    successCallback(responseModel)
                }
                catch let error {
                    if let error = error as? MoyaError {
                        failureCallback(error)
                        self.showFailHUD(error)
                    }
                }
                
            case let .failure(error):
                failureCallback(error)
                if apiModule.isShowHud {
                    self.showFailHUD(error)
                }
            }
        })
    }
    
}

// MARK: Promise version
extension APIService {
    
    func request<APIModuleType: TargetType & MoyaAddable> (
        _ apiModule: APIModuleType,
        progerss progressBlock: progressBlock = nil
        ) -> Promise<ModelType> {
        
        return Promise { seal in
            provider.request(
                MultiTarget(apiModule),
                callbackQueue: DispatchQueue.global(),
                progress: { response in
                    progressBlock?(response.progress)
            }, completion: { response in
                let hudDelayTime = apiModule.isShowHud ? 1.0 : 0.0
                after(seconds: hudDelayTime).done {
                    switch response {
                    case let .success(moyaResponse): 
                        do {
                            let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                            let responseModel = try filteredResponse.map(ModelType.self)
                            seal.fulfill(responseModel)
                        }
                        catch let error {
                            seal.reject(error)
                            if let error = error as? MoyaError {
                                self.showFailHUD(error)
                            }
                        }
                        
                    case let .failure(error):
                        seal.reject(error)
                        if apiModule.isShowHud {
                            self.showFailHUD(error)
                        }
                    }
                }
            })
        }
    }
    
}

