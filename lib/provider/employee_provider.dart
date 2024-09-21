import 'package:flutter/material.dart';
import 'package:manager_app/models/department_model.dart';
import 'package:manager_app/models/employee_model.dart';
import 'package:manager_app/utils/helpers.dart';

import '../services/sql_service.dart';

class EmployeeProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSavingData = false;
  List<Employee> employeeList = [];
  List<Department> departmentList = [];
  final formKey = GlobalKey<FormState>();

  String employeeId = "";
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtSalary = TextEditingController();
  TextEditingController txtHireDate = TextEditingController();
  TextEditingController txtDepartment = TextEditingController();

  onReset() {
    employeeId = "";
    txtFirstName.text = "";
    txtLastName.text = "";
    txtSalary.text = "";
    txtHireDate.text = "";
    txtDepartment.text = "";
  }

  Future onSubmit(BuildContext context) async {
    try {
      isSavingData = true;
      notifyListeners();
      int index = departmentList.indexWhere((department) => department.departmentName == txtDepartment.text.trim());

      Map<String, dynamic> request = {
        "FirstName": txtFirstName.text.trim(),
        "LastName": txtLastName.text.trim(),
        "Salary": double.parse(txtSalary.text.trim()),
        "HireDate": txtHireDate.text.trim(),
        "DepartmentID": departmentList[index].departmentId
      };
      request["EmployeeID"] = employeeId.trim().isNotEmpty
          ? int.parse(employeeId.trim())
          : employeeList.isNotEmpty
              ? employeeList[0].employeeId + 1
              : 1;
      Employee employee = Employee.fromJson(request);
      bool result = await SqlService().onSave(employee, employeeId.trim().isEmpty);
      if (result) {
        await getEmployees();
        Navigator.pop(context);
        successToast("Employee ${employeeId.trim().isNotEmpty ? 'updated' : 'saved'} successfully.");
      } else {
        errorToast("Failed to save employee. Try again.");
      }
    } catch (err) {
      errorToast("Failed to save employee. Try again.");
    } finally {
      isSavingData = false;
      notifyListeners();
    }
  }

  onEdit(Employee employee) {
    int index = departmentList.indexWhere((department) => department.departmentId == employee.departmentId);
    employeeId = employee.employeeId.toString();
    txtFirstName.text = employee.firstName;
    txtLastName.text = employee.lastName;
    txtSalary.text = employee.salary.toString();
    txtHireDate.text = employee.hireDate;
    txtDepartment.text = departmentList[index].departmentName;
    notifyListeners();
  }

  Future onDelete(int employeeId) async {
    bool result = await SqlService().onDeleteEmployee(employeeId);
    if (result) {
      await getEmployees();
      successToast("Employee deleted successfully.");
    } else {
      errorToast("Failed to delete employee. Try again.");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select a date',
    );
    if (pickedDate != null && pickedDate != initialDate) {
      txtHireDate.text = "${pickedDate.toLocal()}".split(' ')[0];
      notifyListeners();
    }
  }

  void showDepartments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: [
            ...departmentList.map((department) {
              return ListTile(
                onTap: () {
                  Navigator.pop(context);
                  txtDepartment.text = department.departmentName;
                  notifyListeners();
                },
                title: Text(department.departmentName),
              );
            })
          ],
        );
      },
    );
  }

  String getDepartmentName(int departmentId) {
    int index = departmentList.indexWhere((department) => department.departmentId == departmentId);
    return index != -1 ? departmentList[index].departmentName : '-';
  }

  Future getEmployees() async {
    isLoading = true;
    notifyListeners();
    employeeList = await SqlService().getEmployees();
    isLoading = false;
    notifyListeners();
  }

  Future getDepartments() async {
    departmentList = await SqlService().getDepartments();
    notifyListeners();
  }
}
