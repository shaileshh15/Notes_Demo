import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'notes_list_screen.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});
  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  bool _showError = false;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _pinFocusNode.addListener(() {
      setState(() {
        _showError = false;
        _errorText = '';
      });
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Secure Your Notes',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Set a 4-digit PIN to protect your notes. This PIN will be required to access your notes.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          TextFormField(
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            obscureText: true,
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 20),
                              hintText: '••••',
                              hintStyle: TextStyle(
                                fontSize: 24,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.length != 4 || int.tryParse(val) == null) {
                                setState(() {
                                  _showError = true;
                                  _errorText = 'Please enter a valid 4-digit PIN';
                                });
                                return 'Please enter a valid 4-digit PIN';
                              }
                              return null;
                            },
                          ),
                          if (_showError)
                            Positioned(
                              bottom: -12,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  _errorText,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await Provider.of<AuthProvider>(context, listen: false).setPin(_pinController.text);
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const NotesListScreen()),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Set PIN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
 