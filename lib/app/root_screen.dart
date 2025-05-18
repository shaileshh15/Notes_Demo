import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/providers/notes_provider.dart';
import 'package:task/screens/pin_login_screen.dart';
import 'package:task/screens/pin_setup_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotesProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Provider.of<AuthProvider>(context, listen: false).hasPin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (snapshot.data!) {
          return const PinLoginScreen();
        } else {
          return const PinSetupScreen();
        }
      },
    );
  }
}
