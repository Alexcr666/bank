import 'package:bank_todo/ui/login/login_screen.dart';
import 'package:bank_todo/ui/main/main_screen.dart';
import 'package:bank_todo/ui/sendMoney/sendMoney_screen.dart';
import 'package:bank_todo/ui/transferMoney/transferMoney_screen.dart';
import 'package:flutter/material.dart';

final mainRoutes = {
  'login': (BuildContext context) => LoginScreen(),
  'main': (BuildContext context) => MainScreen(),
  'transferMoney': (BuildContext context) => transferMoneyScreen(),
  'sendMoney': (BuildContext context) => sendMoneyScreen()
};
