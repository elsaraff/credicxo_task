import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

navigateTo(context, widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

navigateAndFinish(context, widget) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((match) => debugPrint(match.group(0).toString()));
}

extension ParseToString on ConnectivityResult {
  String toValue() {
    return toString().split('.').last;
  }
}
