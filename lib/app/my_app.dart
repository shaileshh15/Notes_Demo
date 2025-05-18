import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/app/root_screen.dart';
import 'package:task/providers/theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secure Notes',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const RootScreen(),
    );
  }
}