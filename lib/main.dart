import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/pages/form_desire.dart';
import 'package:registrador_de_desejos/pages/home_screen.dart';
import "package:provider/provider.dart";
import 'package:registrador_de_desejos/providers/app_navigation_provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AppNavigationProvider())
          ],
        child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/home",
      routes: {
        "/home": (context) => HomeScreen(),
        "/form_desire": (context) => FormDesire(),
      }
    );
  }
}

