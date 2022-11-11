import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'api/api.dart';
import 'login/ui/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final ApiService api = ApiService(storage);

  runApp(
    ChangeNotifierProvider(
      create: (context) => api,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
