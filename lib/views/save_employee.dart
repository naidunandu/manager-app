import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_app/models/employee_model.dart';
import 'package:provider/provider.dart';

import '../provider/employee_provider.dart';

class SaveEmployee extends StatelessWidget {
  const SaveEmployee({super.key, this.employee});
  final Employee? employee;

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text("${provider.employeeId.isNotEmpty ? 'Edit' : 'Add'} Employee"),
          ),
          body: Form(
            key: provider.formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: provider.txtFirstName,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(labelText: "First Name"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: provider.txtLastName,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(labelText: "Last Name"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: provider.txtSalary,
                  decoration: const InputDecoration(labelText: "Salary"),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter salary';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onTap: () {
                    provider.selectDate(context);
                  },
                  controller: provider.txtHireDate,
                  decoration: InputDecoration(
                    labelText: "Hire Date",
                    suffixIcon: IconButton(
                      onPressed: () {
                        provider.selectDate(context);
                      },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select hire date';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onTap: () {
                    provider.showDepartments(context);
                  },
                  controller: provider.txtDepartment,
                  decoration: InputDecoration(
                    labelText: "Department",
                    suffixIcon: IconButton(
                      onPressed: () {
                        provider.showDepartments(context);
                      },
                      icon: const Icon(Icons.list),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select department';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 30),
                CupertinoButton(
                  color: Colors.green,
                  onPressed: provider.isSavingData
                      ? null
                      : () async {
                          if (provider.formKey.currentState!.validate()) {
                            await provider.onSubmit(context);
                          }
                        },
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
