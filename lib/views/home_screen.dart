import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:manager_app/provider/employee_provider.dart';
import 'package:manager_app/widgets/no_internet.dart';
import 'package:provider/provider.dart';

import '../provider/connectivity_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false).getDepartments();
      Provider.of<EmployeeProvider>(context, listen: false).getEmployees();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityService, child) {
        ConnectivityResult status = connectivityService.connectionStatus;
        if (status == ConnectivityResult.none) {
          return const NoInternetWidget();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<EmployeeProvider>(context, listen: false).getDepartments();
            Provider.of<EmployeeProvider>(context, listen: false).getEmployees();
          });
          return Consumer<EmployeeProvider>(builder: (context, provider, child) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.person_search_rounded), SizedBox(width: 5), Text("Manager")],
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await provider.getEmployees();
                    },
                    icon: const Icon(Icons.sync),
                  )
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Employees Listing",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (provider.isLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: kElevationToShadow[1],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 10),
                              Text("Loading")
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (provider.employeeList.isNotEmpty)
                    Expanded(
                      child: ListView(
                        children: [
                          DataTable(
                            dividerThickness: .5,
                            // border: TableBorder(
                            //   top: const BorderSide(color: Colors.grey, width: .5),
                            //   borderRadius: BorderRadius.circular(8),
                            // ),
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Full Name',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Salary',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataColumn(
                                label: Text(""),
                              ),
                            ],
                            rows: provider.employeeList.map(
                              (employee) {
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${employee.firstName} ${employee.lastName}"),
                                          Text(
                                            provider.getDepartmentName(employee.departmentId),
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(employee.salary.toString()),
                                          Text(
                                            "Hire Date: ${employee.hireDate.toString()}",
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              provider.onEdit(employee);
                                              Navigator.pushNamed(
                                                context,
                                                '/save-employee',
                                              ).then((value) => provider.getEmployees());
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          )
                        ],
                      ),
                    ),
                  if (provider.employeeList.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        ":: NOT RECORD ::",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                onPressed: () {
                  provider.onReset();
                  Navigator.pushNamed(
                    context,
                    '/save-employee',
                  ).then((value) => provider.getEmployees());
                },
                icon: const Icon(Icons.add),
                label: const Text("Create"),
              ),
            );
          });
        }
      },
    );
  }
}
