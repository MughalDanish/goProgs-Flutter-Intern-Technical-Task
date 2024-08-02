import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goprogs_flutter_intern_task/pages/budget_category/view_budget_category.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){

    // Firebase Initialization
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: 'AIzaSyA9JxcIJOacwWydSZH8WEzLsror5FtryYY',
            appId: '1:912930977203:android:8fbbc7fce768b46483c7c6',
            messagingSenderId: '912930977203',
            projectId: 'goprogs-flutter-intern-task'));
  }
  else{
    await Firebase.initializeApp();
  }

  //This device preview use to see app on multiple devices like OS/Android/Linux/Desktop.
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewBudgetCategory(),//main screen
    );
  }
}
