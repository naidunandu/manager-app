import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:manager_app/models/department_model.dart';
import 'package:manager_app/models/employee_model.dart';
import 'package:mssql_connection/mssql_connection.dart';

class SqlService {
  static const MethodChannel _channel = MethodChannel('mssql_channel');
  MssqlConnection mssqlConnection = MssqlConnection.getInstance();

  Future<bool> _isConnected() async {
    try {
      if (Platform.isAndroid) {
        return await mssqlConnection.connect(
          ip: '65.1.22.155',
          port: '1433',
          databaseName: 'dev-db',
          username: 'test',
          password: 'Test@12345678',
          timeoutInSeconds: 15,
        );
      } else {
        return false;
      }
    } catch (err) {
      return false;
    }
  }

  Future<List<Employee>> getEmployees() async {
    if (Platform.isAndroid) {
      bool isConnected = await _isConnected();
      if (isConnected) {
        String query = 'SELECT * FROM Employees ORDER BY EmployeeID DESC';
        String result = await mssqlConnection.getData(query);
        List results = jsonDecode(result);
        List<Employee> employeeList =
            results.map((employee) => Employee.fromJson(employee)).toList();
        return employeeList;
      }
    } else {
      String query = 'SELECT * FROM Employees ORDER BY EmployeeID DESC';
      List results = await getQueryiOS(query);
      List<Employee> employeeList =
          results.map((employee) => Employee.fromJson(employee)).toList();
      return employeeList;
    }
    return [];
  }

  Future<List<Department>> getDepartments() async {
    if (Platform.isAndroid) {
      bool isConnected = await _isConnected();
      if (isConnected) {
        String query = 'SELECT * FROM Departments';
        String result = await mssqlConnection.getData(query);
        List results = jsonDecode(result);
        List<Department> departmentList = results
            .map((department) => Department.fromJson(department))
            .toList();
        return departmentList;
      }
    } else {
      String query = 'SELECT * FROM Departments';
      List results = await getQueryiOS(query);
      List<Department> departmentList =
          results.map((department) => Department.fromJson(department)).toList();
      return departmentList;
    }
    return [];
  }

  Future<bool> onSave(Employee employee, bool isNew) async {
    if (Platform.isAndroid) {
      bool isConnected = await _isConnected();
      if (isConnected) {
        if (isNew) {
          String query =
              "INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, HireDate, DepartmentID) VALUES (${employee.employeeId}, '${employee.firstName}', '${employee.lastName}', ${employee.salary}, '${employee.hireDate}', '${employee.departmentId}');";
          await mssqlConnection.writeData(query);
          return true;
        } else {
          String query =
              "UPDATE Employees SET FirstName = '${employee.firstName}', LastName = '${employee.lastName}', Salary = ${employee.salary}, HireDate = '${employee.hireDate}', DepartmentID = '${employee.departmentId}' WHERE EmployeeID = ${employee.employeeId};";
          await mssqlConnection.writeData(query);
          return true;
        }
      } else {
        return false;
      }
    } else {
      if (isNew) {
        String query =
            "INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, HireDate, DepartmentID) VALUES (${employee.employeeId}, '${employee.firstName}', '${employee.lastName}', ${employee.salary}, '${employee.hireDate}', '${employee.departmentId}');";
        await writeQueryiOS(query);
        return true;
      } else {
        String query =
            "UPDATE Employees SET FirstName = '${employee.firstName}', LastName = '${employee.lastName}', Salary = ${employee.salary}, HireDate = '${employee.hireDate}', DepartmentID = '${employee.departmentId}' WHERE EmployeeID = ${employee.employeeId};";
        await writeQueryiOS(query);
        return true;
      }
    }
  }

  Future<bool> onDeleteEmployee(int employeeId) async {
    if (Platform.isAndroid) {
      String query = "DELETE FROM Employees WHERE EmployeeID = $employeeId";
      await mssqlConnection.writeData(query);
      return true;
    } else {
      return true;
    }
  }

  Future<List<Map<String, dynamic>>> getQueryiOS(String query) async {
    try {
      final String? result =
          await _channel.invokeMethod('queryDatabase', {'query': query});
      if (!result!.contains('Failed to query database')) {
        List<dynamic> jsonResponse = json.decode(result);
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonResponse);
        return data;
      } else {
        return [];
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to query database: '${e.message}'.");
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> writeQueryiOS(String query) async {
    try {
      final String? result =
          await _channel.invokeMethod('queryDatabase', {'query': query});
      return [];
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to query database: '${e.message}'.");
      }
      return [];
    }
  }
}
