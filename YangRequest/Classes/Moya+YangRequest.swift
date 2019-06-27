//
//  Moya+YangRequest.swift
//  Pods-YangRequest_Example
//
//  Created by huangyang on 2019/6/27.
//

import Moya
import HandyJSON
import SwiftyJSON

public extension YangRequestTargetType {
    
    typealias Progress = (ProgressResponse) -> ()
    
    typealias Failure = (Error) -> ()
    
    @discardableResult
    func request(success: ((Response) -> ())? = nil,
                 progress: Progress? = nil,
                 failure: Failure? = nil) -> Cancellable {
        
        let provider: MoyaProvider<MultiTarget> = YangRequest.generateProvider(behavior: stubBehavior,
                                                                             plugins: plugins,
                                                                             timeoutInterval: timeoutInterval,
                                                                             callbackQueue: callbackQueue)
        
        return provider.request(MultiTarget(self), progress: progress) {
            
            switch $0 {
            case let .success(response):
                success?(response)
            case let .failure(error):
                failure?(error)
            }
            
        }
        
    }
    
    @discardableResult
    func requestJSON(success: ((JSON) -> ())? = nil,
                     progress: Progress? = nil,
                     failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapSwiftyJSON())
            }catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
    @discardableResult
    func requestObject<T: HandyJSON>(path: String? = nil,
                                     success: ((T) -> ())? = nil,
                                     progress: Progress? = nil,
                                     failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapObject(T.self, path: path))
            }catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
    @discardableResult
    func requestObjectArray<T: HandyJSON>(path: String? = nil,
                                          success: (([T]) -> ())? = nil,
                                          progress: Progress? = nil,
                                          failure: Failure? = nil) -> Cancellable {
        
        return request(success: {
            
            do {
                success?(try $0._mapObjectArray(T.self, path: path))
            }catch {
                failure?(error)
            }
            
        }, progress: progress, failure: failure)
        
    }
    
}

extension Moya.Response {
    
    func _mapSwiftyJSON() throws -> JSON {
        return try JSON(data: data)
    }
    
    func _mapObject<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> T {
        guard let jsonString = String(data: data, encoding: .utf8),
            let object = JSONDeserializer<T>
                .deserializeFrom(json: jsonString, designatedPath: path) else {
                    throw MoyaError.stringMapping(self)
        }
        return object
    }
    
    func _mapObjectArray<T: HandyJSON>(_ type: T.Type, path: String? = nil) throws -> [T] {
        guard let jsonString = String(data: data, encoding: .utf8),
            let objectArray = JSONDeserializer<T>
                .deserializeModelArrayFrom(json: jsonString, designatedPath: path) as? [T] else {
                    throw MoyaError.stringMapping(self)
        }
        return objectArray
    }
    
}
