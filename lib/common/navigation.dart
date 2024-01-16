import 'package:flutter/cupertino.dart';

final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(String routeName, Object arguments) {
    navigatorkey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static back() => navigatorkey.currentState?.pop();
}