import 'package:flutter/material.dart';
import 'package:journal_project/providers/journal_provider.dart';
import 'package:journal_project/routes/route_config.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => JournalProvider(),
        child: MaterialApp.router(
          // Remove the debug banner
          debugShowCheckedModeBanner: false,
          title: 'Journal App',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          routerConfig: MyAppRouter().router,
        ));
  }
}
