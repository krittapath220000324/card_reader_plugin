import Flutter
import UIKit


public class CardReaderPlugin: NSObject, FlutterPlugin {
    
    private static let thaiIDCardReader:String = "THAI_ID_CARD_READER"
    
    /// คล้ายๆ lateinit var ใน kotlin เติม ! ไว้ด้านหลัง
    private static var channel:FlutterMethodChannel!
    
    private var niLibsService:NILibsService!
    
    public static func register(with pluginRegister: FlutterPluginRegistrar) {
        self.channel = FlutterMethodChannel(
            name: self.thaiIDCardReader,
            binaryMessenger: pluginRegister.messenger()
        )
        
        pluginRegister.addMethodCallDelegate(
            CardReaderPlugin(),
            channel: self.channel
        )
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        print("sad")
        
        self.niLibsService = NILibsService.instance(
            call: call,
            result: result
        )
    
    }
    
}
