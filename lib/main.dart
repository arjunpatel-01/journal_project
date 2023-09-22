import 'package:flutter/material.dart';
import 'package:journal_project/routes/route_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Journal App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routerConfig: MyAppRouter().router,
    );
  }
}
