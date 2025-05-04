// lib/pages/contact_page.dart

import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // Form key & controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String? _projectType;
  bool _isSubmitting = false;

  // Colour constants
  static const Color _bgColor = Color(0xFFFAFAFA);
  static const Color _fieldBgColor = Colors.white;
  static const Color _fieldBorderColor = Color(0xFFCCCCCC);
  static const Color _textColor = Color(0xFF333333);
  static const Color _buttonColor = Color(0xFFFF8C42);
  static const Color _buttonTextColor = Colors.white;

  // Project type options
  final List<String> _projectTypes = [
    'App',
    'Branding',
    'Game',
    'Strategy',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      // Call your Firebase Function (replace with your function name)
      final callable = FirebaseFunctions.instance
          .httpsCallable('sendConsultationRequest');
      await callable.call(<String, dynamic>{
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'projectType': _projectType,
        'message': _messageController.text.trim(),
      });

      _showFlushbar(
        title: 'Request Sent',
        message: 'Thank you! We\'ll be in touch soon.',
        isError: false,
      );
      _formKey.currentState!.reset();
      setState(() => _projectType = null);
    } catch (e) {
      _showFlushbar(
        title: 'Submission Failed',
        message: 'Please try again later.',
        isError: true,
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showFlushbar({
    required String title,
    required String message,
    required bool isError,
  }) {
    Flushbar(
      title: title,
      message: message,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: _buttonTextColor,
      ),
      backgroundColor: isError ? Colors.redAccent : _buttonColor,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Conversion header
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFAFAFA), Color(0xFFE5E5E5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // Alternatively, use a concrete texture image:
                // image: DecorationImage(
                //   image: AssetImage('assets/concrete_texture.jpg'),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Got a project, idea, or collaboration in mind?\nLet\'s build it together.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // CTA Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: _fieldBgColor,
                  border: Border.all(color: _fieldBorderColor),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: const TextStyle(color: _textColor),
                          filled: true,
                          fillColor: _fieldBgColor,
                          border: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: _fieldBorderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(color: _textColor),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: _textColor),
                          filled: true,
                          fillColor: _fieldBgColor,
                          border: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: _fieldBorderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(color: _textColor),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          final regex =
                          RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          return regex.hasMatch(v.trim())
                              ? null
                              : 'Enter a valid email';
                        },
                      ),
                      const SizedBox(height: 16),

                      // Project Type dropdown
                      DropdownButtonFormField<String>(
                        value: _projectType,
                        decoration: InputDecoration(
                          labelText: 'Project Type',
                          labelStyle: const TextStyle(color: _textColor),
                          filled: true,
                          fillColor: _fieldBgColor,
                          border: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: _fieldBorderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(color: _textColor),
                        items: _projectTypes
                            .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                            .toList(),
                        onChanged: (val) => setState(() {
                          _projectType = val;
                        }),
                        validator: (v) =>
                        v == null ? 'Please select a project type' : null,
                      ),
                      const SizedBox(height: 16),

                      // Message field
                      TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          labelStyle: const TextStyle(color: _textColor),
                          filled: true,
                          fillColor: _fieldBgColor,
                          border: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: _fieldBorderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(color: _textColor),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Please enter a message'
                            : null,
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _buttonColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              color: _buttonTextColor,
                              fontSize: 16,
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: _buttonTextColor,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'Send Request',
                            style: TextStyle(
                                color: _buttonTextColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
