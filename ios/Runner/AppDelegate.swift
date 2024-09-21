import UIKit
import Flutter
import SQLClient


@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
           let mssqlChannel = FlutterMethodChannel(name: "mssql_channel", binaryMessenger: controller.binaryMessenger)
           mssqlChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
             if call.method == "queryDatabase" {
               if let args = call.arguments as? [String: Any], let query = args["query"] as? String {
                 self?.queryDatabase(query: query, result: result)
               }
             } else {
               result(FlutterMethodNotImplemented)
             }
           }
           return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func queryDatabase(query: String, result: @escaping FlutterResult) {
       let client = SQLClient.sharedInstance()!
       client.connect("65.1.22.155:1433", username: "test", password: "Test@12345678", database: "dev-db") { success in
         if success {
           client.execute(query) { (results: [Any]?) in
             if let results = results, let firstTable = results.first as? [[String: Any]] {
               let jsonString = self.convertToJSONString(array: firstTable)
               result(jsonString)
             } else {
               result(FlutterError(code: "NO_DATA", message: "No data found", details: nil))
             }
             client.disconnect()
           }
         } else {
           result(FlutterError(code: "CONNECTION_ERROR", message: "Unable to connect to database", details: nil))
         }
       }
     }

     private func convertToJSONString(array: [[String: Any]]) -> String {
       do {
         let jsonData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
         return String(data: jsonData, encoding: .utf8) ?? ""
       } catch {
         return "[]"
       }
     }
}
