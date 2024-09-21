import 'package:flutter/material.dart';

class RouteObserverWidget extends RouteObserver<PageRoute<dynamic>> {
  String currentRouteName = '';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      currentRouteName = route.settings.name ?? 'Unknown';
      print('Current route name: $currentRouteName');
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute is PageRoute) {
      currentRouteName = previousRoute.settings.name ?? 'Unknown';
      print('Current route name: $currentRouteName');
    }
    super.didPop(route, previousRoute);
  }

  String getCurrentRouteName() {
    return currentRouteName;
  }
}

final RouteObserverWidget routeObserver = RouteObserverWidget();