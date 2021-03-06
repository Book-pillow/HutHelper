//
//  MomentViewModel.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/15.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftyJSON
import Alamofire

class MomentViewModel {
    var momentDatas = [MomentModel]()
    var page = 1

}
// MARK:- 请求数据
extension MomentViewModel {
    func getAllMomentRequst(page: Int, callback:@escaping ([MomentModel]) -> Void) {
        MomentProvider.request(.all(page)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json: json["statement"].description) {

                        callback(datas as! [MomentModel])
                    }
                }
            }
        }
    }
    func getLikeMomentRequst(momentId: String, callback:@escaping () -> Void) {
        MomentProvider.request(.like(momentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    func getUnLikeMomentRequst(momentId: String, callback:@escaping () -> Void) {
        MomentProvider.request(.unlike(momentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    func getDeleteMomentRequst(momentId: String, callback:@escaping () -> Void) {
        MomentProvider.request(.delete(momentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    func getDeleteCMomentRequst(commentId: String, callback:@escaping () -> Void) {
        MomentProvider.request(.deleteC(commentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    func getCommentSayRequst(comment: String, momentId: String, callback:@escaping () -> Void) {
        MomentProvider.request(.comment(comment, momentId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }

    func getHotMomentRequst(page: Int, day: Int, callback:@escaping ([MomentModel]) -> Void) {

        MomentProvider.request(.hot(page, day)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json: json["statement"].description) {
                        callback(datas as! [MomentModel])
                    }
                }
            }
        }
    }
    func getOwnMomentRequst(page: Int, userId: String, callback:@escaping ([MomentModel]) -> Void) {

        MomentProvider.request(.own(page, userId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json: json["statement"].description) {
                        callback(datas as! [MomentModel])
                    }
                }
            }
        }
    }
    func getInteractiveMomentRequst(page: Int, callback:@escaping ([MomentModel]) -> Void) {

        MomentProvider.request(.interactive(page)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json: json["statement"].description) {
                        callback(datas as! [MomentModel])
                    }
                }
            }
        }
    }
    func getSearchMomentRequst(content: String, page: Int, callback:@escaping ([MomentModel]) -> Void) {

        MomentProvider.request(.search(content, page)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json: json["statement"].description) {
                        callback(datas as! [MomentModel])
                    }
                }
            }
        }
    }
    
    // 关注页
    func getConcernMomentRequst(page: Int, callback:@escaping ([MomentModel]) -> Void) {

        MomentProvider.request(.concern(page)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json: json["statement"].description) {
                        callback(datas as! [MomentModel])
                    }
                }
            }
        }
    }
    
    func getUserInfo(id:String,callback:@escaping (PeopleModel) -> ()) {
        Alamofire.request(getPersonInfo(userId: id)).responseJSON { (response) in
            guard response.result.isSuccess else {
                return
            }
            let value = response.value
            let json = JSON(value!)
            if let data = JSONDeserializer<PeopleModel>.deserializeFrom(json: json["data"].description) {
               callback(data)
            }
        }
    }
    
    // 举报
    func PostHandRequst(email: String, content: String, callback: @escaping (_ result: JSON) -> Void) {
        
        MomentProvider.request(.report(email, content)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    print(json)
                    callback(json)
                }
            }
        }
    }
    
    // 关注
    func postConcern(userId: String, callback:@escaping ([MomentModel]) -> Void) {

        MomentProvider.request(.unconcren(userId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    if let datas = JSONDeserializer<MomentModel>.deserializeModelArrayFrom(json: json["statement"].description) {
                        callback(datas as! [MomentModel])
                    }
                }
            }
        }
    }
    
    func getUnconcernMomentRequst(userId: String, callback:@escaping () -> Void) {
        MomentProvider.request(.unconcren(userId)) { (result) in
            if case let .success(response) = result {
                let value = try? response.mapJSON()
                if let data = value {
                    let json = JSON(data)
                    print(json)
                    callback()
                }
            }
        }
    }
    

}
