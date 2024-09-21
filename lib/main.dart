import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:manager_app/provider/employee_provider.dart';
import 'package:manager_app/views/save_employee.dart';
import 'package:provider/provider.dart';
import 'provider/connectivity_provider.dart';
import 'utils/route_observer.dart';
import 'views/home_screen.dart';
import 'widgets/no_internet.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(.9)),
      child: Consumer<ConnectivityProvider>(
        builder: (context, connectivityService, child) {
          ConnectivityResult status = connectivityService.connectionStatus;
          if (status == ConnectivityResult.none) {
            navigatorKey.currentState?.pushNamed('/no-internet');
          } else {
            if (navigatorKey.currentState?.canPop() ?? false) {
              String currentRoute = routeObserver.getCurrentRouteName();
              if(currentRoute == '/no-internet'){
                navigatorKey.currentState?.pop();
              }
            }
          }
          return MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [routeObserver],
            title: 'Manager App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              useMaterial3: false,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(), // Your main home page
              '/save-employee': (context) => const SaveEmployee(),
              '/no-internet': (context) => const NoInternetWidget(), // No internet page
            },
          );
        },
      ),
    );
  }


  String getCurrentRouteName() {
    if (navigatorKey.currentState == null) {
      return 'Unknown';
    }

    ModalRoute? currentRoute = ModalRoute.of(navigatorKey.currentState!.context);
    return currentRoute?.settings.name ?? 'Unknown';
  }
}
