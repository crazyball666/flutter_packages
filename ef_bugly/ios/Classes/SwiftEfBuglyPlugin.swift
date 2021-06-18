import Flutter
import UIKit
import Bugly


public class SwiftEfBuglyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ef_bugly", binaryMessenger: registrar.messenger())
    let instance = SwiftEfBuglyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arg = call.arguments as? [AnyHashable:Any]
    switch call.method {
    case "startBugly":
        if let appid = arg?["appId"] as? String{
            startBugly(appid: appid)
        }
        result(nil)
        break
    case "setData":
        let key : String = arg?["key"] as? String ??  ""
        let value : String = arg?["value"] as? String ?? ""
        setData(key, value)
        result(nil)
        break
    case "reportException":
        let category = arg?["category"] as? UInt ?? 0
        let name = arg?["name"] as? String ?? ""
        let reason = arg?["reason"] as? String ?? ""
        let callStack = arg?["callStack"] as? String ?? ""
        let extraInfo = arg?["extraInfo"] as? [AnyHashable : Any] ?? [AnyHashable : Any]()
        let terminateApp = arg?["terminateApp"] as? Bool ?? false
        reportException(category: category, name: name, reason: reason, callStack: [callStack], extraInfo: extraInfo, terminateApp: terminateApp)
        result(nil)
        break
    default:
        break
    }
  }
    
    func startBugly(appid: String){
        Bugly.start(withAppId: appid)
    }
    
    func setData(_ key:String,_ value:Any?){
        Bugly.setValue(value, forKey: key)
    }
    
    func reportException(category:UInt, name:String, reason:String,callStack:[Any], extraInfo:[AnyHashable : Any], terminateApp: Bool){
        Bugly.reportException(withCategory: category, name: name, reason: reason, callStack: callStack, extraInfo: extraInfo, terminateApp: terminateApp)
    }
    
}
