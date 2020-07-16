//
//  MQTTAdapters.swift
//  hatariIotDemo
//
//  Created by nic wanavit on 7/16/20.
//  Copyright © 2020 nic wanavit. All rights reserved.
//

import Foundation
import IoT
import IoTDataPlane

let ThingName = "AP-M_2005230221001909"
let AccessKey = "AKIATE7YQEGLGIV3ZOFG"
let SecretKey = "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"


public struct PurifierStatus: Codable {
    public let state: Reported
}

public struct Reported: Codable {
    public let mode: Int
    public let speed: Int
    public let dust: Int
    public let humidity: Float
    public let reportingInterval: Int
    public let timer:APTimer
    enum CodingKeys: String, CodingKey {
        case mode
        case speed
        case dust
        case humidity
        case timer
        case reportingInterval = "reporting_interval"
    }

}

public struct APTimer: Codable {
    public let action: Int
    public let timestamp: Int
}


class AirPurifier{
    class func getStatus(callback: @escaping (PurifierStatus)->Void)->Void{
        let iotData = IoTDataPlane(accessKeyId: AccessKey, secretAccessKey: SecretKey,  region: .apsoutheast1,  middlewares: [], eventLoopGroupProvider: .useAWSClientShared)
        let _ = iotData.getThingShadow(.init(thingName: ThingName)).always { (res) in
            debugPrint(res)
            let decoder = JSONDecoder()
            do {
                let result = try res.get()
                if let payload = result.payload {
                    let purifierStatus = try decoder.decode(PurifierStatus.self, from: payload)
                    callback(purifierStatus)
                }
            } catch {
                debugPrint("decoding error \(error)")
            }
            
        }
    }
    class func updateStatus(purifierStatus:PurifierStatus, callback: @escaping (PurifierStatus)->Void)->Void{
        let iotData = IoTDataPlane(accessKeyId: AccessKey, secretAccessKey: SecretKey,  region: .apsoutheast1,  middlewares: [], eventLoopGroupProvider: .useAWSClientShared)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(purifierStatus)
            let _ = iotData.updateThingShadow(.init(payload: data, thingName: ThingName)).always { (res) in
                do {
                    let result = try res.get()
                    debugPrint(result)
                } catch {
                    debugPrint(error)
                }
            }
        } catch {
            debugPrint(error)
        }
        
    }
}
