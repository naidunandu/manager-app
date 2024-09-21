import 'dart:convert';
import 'dart:io';
import 'package:manager_app/models/department_model.dart';
import 'package:manager_app/models/employee_model.dart';
import 'package:mssql_connection/mssql_connection.dart';

class SqlService {
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
        List<Employee> employeeList = results.map((employee) => Employee.fromJson(employee)).toList();
        return employeeList;
      }
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
        List<Department> departmentList = results.map((department) => Department.fromJson(department)).toList();
        return departmentList;
      }
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
      return true;
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
}
