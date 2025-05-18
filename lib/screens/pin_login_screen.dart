

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../screens/pin_setup_screen.dart';
import '../providers/auth_provider.dart';
import 'notes_list_screen.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});
  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  String? _error;

  @override
  void initState() {
    super.initState();
    _pinFocusNode.addListener(() {
      if (_error != null) {
        setState(() {
          _error = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final contentWidth = size.width < 500 ? size.width * 0.92 : 400.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: isPortrait ? size.height * 0.10 : size.height * 0.05,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Unlock Your Notes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Enter your 4-digit PIN to access your secure notes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: size.height * 0.06),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            obscureText: true,
                            style: TextStyle(fontSize: size.width * 0.09),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: size.height * 0.025,
                              ),
                              hintText: '••••',
                              hintStyle: TextStyle(
                                fontSize: size.width * 0.09,
                                color: Colors.black38,
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.length != 4 || int.tryParse(val) == null) {
                                setState(() {
                                  _error = 'Please enter a valid 4-digit PIN';
                                });
                                return '';
                              }
                              return null;
                            },
                          ),
                        ),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _error!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: size.width * 0.037,
                              ),
                            ),
                          ),
                        SizedBox(height: size.height * 0.04),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.lock_open, size: size.width * 0.065),
                            label: Text(
                              'Unlock',
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool ok = await Provider.of<AuthProvider>(context, listen: false)
                                    .verifyPin(_pinController.text);
                                if (ok) {
                                  if (mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const NotesListScreen()),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    _error = 'Incorrect PIN';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Incorrect PIN. Please try again.'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: Colors.black45,
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.025,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Reset App?'),
                                content: const Text(
                                  'This will delete all notes and reset your PIN. Continue?',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      'Reset',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await Provider.of<AuthProvider>(context, listen: false).resetAll();
                              await Provider.of<NotesProvider>(context, listen: false).clearAll();
                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const PinSetupScreen()),
                                );
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black54,
                          ),
                          child: Text(
                            'Forgot PIN?',
                            style: TextStyle(
                              fontSize: size.width * 0.038,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





