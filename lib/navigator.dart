import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  NavigatorState get _state => navigatorKey.currentState;

  Future<dynamic> navigate(String routeName) {
    print("Navigating to page $routeName");
    _state.pushNamed(routeName);
  }

  Future<bool> pop() => _state.maybePop();
}