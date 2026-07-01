//
//  NALibs.swift
//  
//
//  Created by D1MACBOOKAIR on 25/6/2569 BE.
//

/// --> Thread <--
/// DispatchQueue.main --> อัปเดต UI, เปลี่ยนหน้าจอ, วาดกราฟิกให้ผู้ใช้เห็น
/// DispatchQueue.global(qos: .userInteractive) --> งานคำนวณที่ส่งผลต่อ UI ทันที เช่น แอนิเมชันฟิสิกส์ตามมือนิ้วลาก
/// DispatchQueue.global(qos: .userInitiated) --> (แนะนำสำหรับอ่านบัตร) เช่น การกดปุ่มแล้วรอโหลดข้อมูล, โหลดไฟล์ไลบรารีสแกนบัตร
/// DispatchQueue.global(qos: .default) --> งานทั่วไปที่ระบบจะจัดสรรให้ตามความเหมาะสม
/// DispatchQueue.global(qos: .utility) --> งานดาวน์โหลดไฟล์ขนาดใหญ่, การดึงข้อมูลจากฐานข้อมูลก้อนโต
/// DispatchQueue.global(qos: .background) --> งานสำรองข้อมูล (Backup), การทำดัชนีแคชระบบเงียบ ๆ เบื้องหลัง

import Flutter
import NiOSHardware
import Foundation


class NILibsCores: NiOS{
    
    
    static let instance = NILibsCores()

    private override init() {
        super.init()
    }
    
    private let LIC_FILE_NAME:String = "rdnidlib"
    private let LIC_FILE_TYPE:String = ".dlt"
    private let LIC_FILE:String = "rdnidlib.dlt"
    
    /// reader type ( ref -> NiOS.h )
    //    #define  READERTYPE_USB_LTN     0x001
    //    #define  READERTYPE_BLT         0x002
    //    #define  READERTYPE_BLE         0x004
    //    #define  READERTYPE_BUL         (READERTYPE_BLT|READERTYPE_USB_LTN)
    
    private let USE_LTN_MODE:Int32 = READERTYPE_USB_LTN
    private let BLE_MODE:Int32 = READERTYPE_BLE
    private let BLT_MODE:Int32 = READERTYPE_BLT
    private let BUL_MODE:Int32 = READERTYPE_BUL
    
    /// thread
    private func launch(
        qos thread: DispatchQoS.QoSClass = .default,
        execute work: @escaping () -> Void
    ) {
        return DispatchQueue
            .global(qos: thread)
            .async (execute: work)
    }
    
    private func launchMain(
        execute work: @escaping () -> Void
    ) {
        return DispatchQueue
            .main
            .async (execute: work)
    }
    
    private func error(
        message: String?,
    ) -> FlutterError {
        return FlutterError(
            code: "ERROR_500",
            message: message,
            details: nil
        )
    }
    
    private func success(
        result: Any?,
        code: String?,
    ) -> [String:Any] {
        return [
            "result" : result ?? "",
            "code" : code ?? ""
        ]
    }
    
    private func loadLICPath(
        path:inout String
    ) {
        
        /// ตรวจสอบที่อยู่ file libs ว่ามีอยู่จริง
        let bundlePath:String = Bundle.main.path(
            forResource: self.LIC_FILE_NAME,
            ofType: self.LIC_FILE_TYPE
        ) ?? ""
        print("getLICPath: bundlePath: \(bundlePath)")
        
        /// สร้าง File สำหรับ อ่านและเขียนได้
        let libsPath:[String] = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true
        )
        print("getLICPath: libsPath: \(libsPath)")
        
        let firstPath:String = libsPath.first ?? ""
        print("getLICPath: firstPath: \(firstPath)")
        
        path = firstPath.isEmpty ? "" : "\(firstPath)/\(LIC_FILE)"
        
        print("getLICPath: path_extends: \(path)")
        
        let fullDestPath:NSURL = NSURL(
            fileURLWithPath: path
        )
        let fileManager:FileManager = FileManager.default
        let fullDestPathString:String = fullDestPath.path ?? ""
        
        if !fullDestPathString.isEmpty {
            let exist:Bool = fileManager.fileExists(
                atPath: fullDestPathString
            )
            print("getLICPath: fullDestPathString: exist: \(exist)")
            if !exist {
                do {
                    /// copy file ลงไว้ใน resources to storage
                    try fileManager.copyItem(
                        atPath: bundlePath,
                        toPath: fullDestPathString
                    )
                }
                catch {
                    print("getLICPath: copy file LIC error !! \(error)")
                }
            }
        }
       
    }

    func openLibs(
        result response: @escaping FlutterResult
    ) {
        
        self.launch (qos: .userInitiated) {
            
            /// default path
            var licPath:String = ""
            
            self.loadLICPath(
                path: &licPath
            )
            
            let licPathInput:NSMutableString = NSMutableString(
                string: licPath
            )
            print("openLibs: licPathInput: \(licPathInput)")
           
            
            let code:Int32 = self.openLibNi(licPathInput)
            print("openLibNi: code: \(code)")
            
            /// success
            if code == 0 {
                self.launchMain {
                    response(
                        self.success(
                            result: "",
                            code: "\(code)"
                        )
                    )
                }
                return
            }
            
            /// error then to updateLicenseFileNi()
            self.launch (qos: .background) {
                let codeUpdateLic:Int32 = self.updateLicenseFileNi()
                print("updateLicenseFileNi: codeUpdateLic: \(codeUpdateLic)")
                
                self.launchMain {
                    /// error
                    if codeUpdateLic < 0 {
                        response(
                            self.error(
                                message: "openLibs: updateLicenseFileNi: Failed: code: \(codeUpdateLic)"
                            )
                        )
                        return
                    }

                    /// success
                    response(
                        self.success(
                            result: "",
                            code: "\(codeUpdateLic)"
                        )
                    )
                }
                
            }
                        
        }
        
    }
    
    func closedLibs(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let code:Int32 = self.closeLibNi()
            
            self.launchMain {
                response(
                    self.success(
                        result: "",
                        code: "\(code)"
                    )
                )
            }
            
        }
         
    }
    
    func updateLicenseFiles(
        result response: @escaping FlutterResult
    ) {
        self.launch(qos: .background) {
            
            let code:Int32 = self.updateLicenseFileNi()
            
            self.launchMain {
                response(
                    self.success(
                        result: "",
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func setReaderType(
        arguments:Any?,
        result response: @escaping FlutterResult
    ) {
        
        self.launch (qos: .userInitiated){
            
            let disabledBLEMode:Bool = (arguments as? Bool) ?? false
            print("setReaderType: disabledBLEMode: \(disabledBLEMode)")
            
            let mode:Int32 = disabledBLEMode ? self.BUL_MODE : self.BLE_MODE
            print("setReaderType: mode: \(mode)")
            
            NILibsCores.setReaderTypeNi(mode)
            
            self.launchMain {
                response(
                    self.success(
                        result: "",
                        code: "0"
                    )
                )
            }
        }
        
    }
    
    func findReader(
        arguments:Any?,
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            /// default time out 5 milliseconds
            let timeout:Int = arguments as? Int ?? 10
            print("findReader: timeout: \(timeout)")
            
            let timeoutToInt32:Int32 = Int32(timeout)
            print("findReader: timeoutToInt32: \(timeoutToInt32)")
            
            let output:NSMutableArray = NSMutableArray(array: [])
            
            let code:Int32 = self.scanReaderListBleNi(
                output,
                timeoutToInt32
            )
            print("findReader: output: \(output)")
            
            
            self.launchMain {
                
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: [],
                            code: "\(code)"
                        )
                    )
                    return
                }
                
                /// success
                let result:[String] = output as? [String] ?? []
                print("findReader: result: \(result)")
                
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
                
            }
            
        }
        
    }
    
    func stopFindReader(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let code:Int32 = self.stopReaderListBleNi()
            
            self.launchMain {
                response(
                    self.success(
                        result: "",
                        code: "\(code)"
                    )
                )
            }
        }
        
    }
    
    func selectReader(
        arguments:Any?,
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
             
            let deviceName:String = arguments as? String ?? ""
            print("selectReader: deviceName: \(deviceName)")
            
            if deviceName.isEmpty {
                self.launchMain {
                    response(
                        self.error(
                            message: "selectReader: arguments deviceName is empty !!"
                        )
                    )
                }
                return
            }
            
            let deviceNameInput:NSMutableString = NSMutableString(
                string: deviceName
            )
            print("selectReader: deviceNameInput: \(deviceNameInput)")
            
            let code:Int32 = self.selectReaderNi(deviceNameInput)
           
            self.launchMain {
                response(
                    self.success(
                        result: "\(deviceName)",
                        code: "\(code)"
                    )
                )
            }
           
        }
        
    }
    
    func deselectReader(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let code:Int32 = self.deselectReaderNi()
            
            self.launchMain {
                response(
                    self.success(
                        result: "",
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func connectedCard(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let code:Int32 = self.connectCardNi()
            
            self.launchMain {
                response(
                    self.success(
                        result: "",
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func disconnectedCard(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let code:Int32 = self.disconnectCardNi()
            
            self.launchMain {
                response(
                    self.success(
                        result: "",
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func getLicenseInfo(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let output:NSMutableString = NSMutableString(string: "")
            
            let code:Int32 = self.getLicenseInfoNi(output)
            print("getLicenseInfo: output: \(output)")
            
            self.launchMain {
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: "",
                            code: "\(code)"
                        )
                    )
                    return
                }
                
                /// success
                let result:String = output as String
                print("getLicenseInfo: result: \(result)")
                
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func getReaderInfo(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let output:NSMutableString = NSMutableString(string: "")
            
            let code:Int32 = self.getReaderInfoNi(output)
            print("getReaderInfo: output: \(output)")
            
            self.launchMain {
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: "",
                            code: "\(code)"
                        )
                    )
                    return
                }
                
                /// success
                let result:String = output as String
                print("getReaderInfo: result: \(result)")
                
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func getSoftwareInfo(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
             
            let output:NSMutableString = NSMutableString(string: "")
            
            let code:Int32 = self.getSoftwareInfoNi(output)
            print("getSoftwareInfo: output: \(output)")
            
            self.launchMain {
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: "",
                            code: "\(code)"
                        )
                    )
                    return
                }
                
                let result:String = output as String
                print("getSoftwareInfo: result: \(result)")
                
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func getReaderList(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let output:NSMutableArray = NSMutableArray(array: [])
            
            let code:Int32 = self.getReaderListNi(output)
            print("getReaderList: output: \(output)")
            
            self.launchMain {
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: [],
                            code: "\(code)"
                        )
                    )
                    return
                }
                
                /// success
                let result:[String] = output as? [String] ?? []
                print("getReaderList: result: \(result)")
                
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func idCardNumber(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let output:NSMutableString = NSMutableString(string: "")
            
            let code:Int32 = self.getNIDNumberNi(output)
            print("idCardNumber: output: \(output)")
            
            self.launchMain {
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: "",
                            code: "\(code)"
                        )
                    )
                    return
                }
         
                /// success
                let result:String = output as String
                print("idCardNumber: result: \(result)")
                
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func idCardText(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let output:NSMutableString = NSMutableString(string: "")
            
            let code:Int32 = self.getNIDTextNi(output)
            print("idCardText: output: \(output)")
            
            self.launchMain {
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: "",
                            code: "\(code)"
                        )
                    )
                    return
                }
                
                /// success
                let result:String = output as String
                print("idCardText: result: \(result)")
                
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func idCardPhoto(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let output:NSMutableData = NSMutableData(data: Data())
            
            let code:Int32 = self.getNIDPhotoNi(output)
            print("idCardPhoto: output: \(output)")
            
            self.launchMain {
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: nil,
                            code: "\(code)"
                        )
                    )
                    return
                }
                
                /// success
                let result:Data = output as Data
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func icCardTextWithOptions(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated){
             
            let output:NSMutableString = NSMutableString(string: "")
            
            let code:Int32 = self.getATextNi(output)
            print("idCardText: output: \(output)")
            
            self.launchMain {
                /// error
                if code != 0 {
                    response(
                        self.success(
                            result: "",
                            code: "\(code)"
                        )
                    )
                    return
                }
                
                /// success
                let result:String = output as String
                print("idCardText: result: \(result)")
                
                response(
                    self.success(
                        result: result,
                        code: "\(code)"
                    )
                )
            }
        }
       
    }
    
    func cardStatus(
        result response: @escaping FlutterResult
    ) {
        
        self.launch(qos: .userInitiated) {
            
            let code:Int32 = self.getCardStatusNi()
            
            self.launchMain {
                response(
                    self.success(
                        result: "",
                        code: "\(code)"
                    )
                )
            }
            
        }
        
    }
    
    func requestPermission(
        result response: @escaping FlutterResult
    ) {
        response(
            self.success(
                result: true,
                code: "0")
        )
    }
    
    
    
}
