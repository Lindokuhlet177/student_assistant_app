/**
*Student Numbers:224108179, 222016851, 221030087, 220019475, 223025046, 221008989
*Student Names: JL Davids, VM Malejane, KP Tshabalala, LJ Thabethe, TG Mofokeng, LM Twala
*/

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'student';
  int? _selectedYear;
  bool _isLoading = false;
  String _errorMessage = '';

  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == 'student' && _selectedYear == null) {
      setState(() => _errorMessage = 'Please select your year of study.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = ''; });

    try {
      // Step 1: Create auth user
      final response = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final userId = response.user?.id;
      if (userId == null) throw Exception('Registration failed.');

      // Step 2: Insert profile
      await _supabase.from('profiles').insert({
        'id': userId,
        'full_name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'year_of_study': _selectedRole == 'student' ? _selectedYear : null,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please log in.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add, size: 64, color: Colors.indigo),
                    const SizedBox(height: 16),
                    const Text('Register', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 32),

                    // Full name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Full name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please confirm your password';
                        if (v != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Role selector
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Register as', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'student'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'student' ? Colors.indigo : Colors.white,
                                border: Border.all(color: Colors.indigo),
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                              ),
                              child: Center(
                                child: Text(
                                  'Student',
                                  style: TextStyle(
                                    color: _selectedRole == 'student' ? Colors.white : Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _selectedRole = 'admin'; _selectedYear = null; }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'admin' ? Colors.indigo : Colors.white,
                                border: Border.all(color: Colors.indigo),
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                              ),
                              child: Center(
                                child: Text(
                                  'Admin',
                                  style: TextStyle(
                                    color: _selectedRole == 'admin' ? Colors.white : Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Year of study (students only)
                    if (_selectedRole == 'student') ...[
                      DropdownButtonFormField<int>(
                        value: _selectedYear,
                        decoration: const InputDecoration(
                          labelText: 'Year of Study',
                          prefixIcon: Icon(Icons.school_outlined),
                          border: OutlineInputBorder(),
                        ),
                        items: [1, 2, 3].map((y) => DropdownMenuItem(
                          value: y,
                          child: Text('Year $y'),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedYear = v),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Error message
                    if (_errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_errorMessage, style: const TextStyle(color: Colors.red))),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Create Account', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
