//
//  NALibsService.swift
//  
//
//  Created by D1MACBOOKAIR on 25/6/2569 BE.
//


import Flutter
import UIKit

class NILibsService{
    
    /// Cmd + Ctrl + E ทำการ rename จุดที่เรียกใช้ด้วย
    
    /// การใส่ คำบางอย่างไว้ข้างหน้าเป็นการ ตั้งชื่อ แทนใช่ชื่อ ตัวแปรใน params
    /// ส่วนการใช้ _ เป็นการไม่มีป้ายกำกับรับ params
    public static func instance(
        call request: FlutterMethodCall,
        result response: @escaping FlutterResult
    ) -> NILibsService {
        return NILibsService(
            call: request ,
            result: response
        )
    }
    
    private let request: FlutterMethodCall
    private let response: FlutterResult
    
    private init(
        call request: FlutterMethodCall,
        result response: @escaping FlutterResult
    ) {
        self.request = request
        self.response = response
        self.handler()
    }
    
    private let niLibsCores:NILibsCores = NILibsCores.instance
    
    private func handler() {
        let arguments:Any? = self.request.arguments
        let method:String = self.request.method
        
        print("handler: arguments: \(arguments, default: "not found arguments !!")")
        print("handler: method: \(method)")
        
        switch method {
        case MethodName.readyToUsed.rawValue:
            response(true)
            break
            
        case MethodName.getPlatformVersion.rawValue:
            response("\(UIDevice.current.model) IOS \(UIDevice.current.systemVersion)")
            break
            
        case MethodName.openLibs.rawValue:
            niLibsCores.openLibs(
                result: response
            )
            break
            
        case MethodName.closedLibs.rawValue:
            niLibsCores.closedLibs(
                result: response
            )
            break
            
        case MethodName.updateLicenseFile.rawValue:
            niLibsCores.updateLicenseFiles(
                result: response
            )
            break
            
        case MethodName.setReaderType.rawValue:
            niLibsCores.setReaderType(
                arguments: arguments,
                result: response
            )
            break
            
        case MethodName.findReader.rawValue:
            niLibsCores.findReader(
                arguments: arguments,
                result: response
            )
            break
        
        case MethodName.stopFindReader.rawValue:
            niLibsCores.stopFindReader(
                result: response
            )
            break
            
        case MethodName.selectReader.rawValue:
            niLibsCores.selectReader(
                arguments: arguments,
                result: response
            )
            break
            
        case MethodName.deselectReader.rawValue:
            niLibsCores.deselectReader(
                result: response
            )
            break
            
        case MethodName.connectedCard.rawValue:
            niLibsCores.connectedCard(
                result: response
            )
            break
            
        case MethodName.disconnectedCard.rawValue:
            niLibsCores.disconnectedCard(
                result: response
            )
            break
            
        case MethodName.getLicenseInfo.rawValue:
            niLibsCores.getLicenseInfo(
                result: response
            )
            break
            
        case MethodName.getReaderInfo.rawValue:
            niLibsCores.getReaderInfo(
                result: response
            )
            break
            
        case MethodName.getSoftwareInfo.rawValue:
            niLibsCores.getSoftwareInfo(
                result: response
            )
            break
        
        case MethodName.getReaderList.rawValue:
            niLibsCores.getReaderList(
                result: response
            )
            break
                    
        case MethodName.idCardNumber.rawValue:
            niLibsCores.idCardNumber(
                result: response
            )
            break
            
        case MethodName.idCardText.rawValue:
            niLibsCores.idCardText(
                result: response
            )
            break
        
        case MethodName.idCardPhoto.rawValue:
            niLibsCores.idCardPhoto(
                result: response
            )
            break
            
        case MethodName.icCardTextWithOptions.rawValue:
            niLibsCores.icCardTextWithOptions(
                result: response
            )
            break
        
        case MethodName.cardStatus.rawValue:
            niLibsCores.cardStatus(
                result: response
            )
            break
        
        case MethodName.requestPermissions.rawValue:
            niLibsCores.requestPermission(
                result: response
            )
            break
        
        default:
            response(FlutterMethodNotImplemented)
            break
        }
    }
    
   
    
    
   


    
    
}
