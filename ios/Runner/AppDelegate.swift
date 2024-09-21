import UIKit
import Flutter
import SQLClient


@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let sqlClientChannel = FlutterMethodChannel(name: "com.example/sqlclient",
                                                    binaryMessenger: controller.binaryMessenger)
        sqlClientChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "connectToSQLServer" {
                self?.connectToSQLServer(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func connectToSQLServer(result: @escaping FlutterResult) {
        let client = SQLClient.sharedInstance()!
        client.connect("65.1.22.155:1433", username: "test", password: "Test@12345678", database: "dev-db") { success in
            if success {
                client.execute("SELECT * FROM Employees") { tables in
                    var resultData = [[String: Any]]()
                    for table in tables as! [[[String: Any]]] {
                        for row in table {
                            resultData.append(row)
                        }
                    }
                    result(resultData)
                    client.disconnect()
                }
            } else {
                result(FlutterError(code: "SQL_CONNECTION_ERROR", message: "Failed to connect to SQL Server", details: nil))
            }
        }
    }
}
