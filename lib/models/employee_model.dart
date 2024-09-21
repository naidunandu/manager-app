import 'dart:convert';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

String employeeToJson(Employee data) => json.encode(data.toJson());

class Employee {
  int employeeId;
  String firstName;
  String lastName;
  int departmentId;
  double salary;
  String hireDate;

  Employee({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.departmentId,
    required this.salary,
    required this.hireDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    employeeId: json["EmployeeID"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    departmentId: json["DepartmentID"],
    salary: json["Salary"],
    hireDate: json["HireDate"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeID": employeeId,
    "FirstName": firstName,
    "LastName": lastName,
    "DepartmentID": departmentId,
    "Salary": salary,
    "HireDate": hireDate,
  };
}
