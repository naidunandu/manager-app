import 'dart:convert';

Department departmentFromJson(String str) => Department.fromJson(json.decode(str));

String departmentToJson(Department data) => json.encode(data.toJson());

class Department {
  int departmentId;
  String departmentName;
  String location;

  Department({
    required this.departmentId,
    required this.departmentName,
    required this.location,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    departmentId: json["DepartmentID"],
    departmentName: json["DepartmentName"] ?? "",
    location: json["Location"],
  );

  Map<String, dynamic> toJson() => {
    "DepartmentID": departmentId,
    "DepartmentName": departmentName,
    "Location": location,
  };
}
