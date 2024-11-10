import 'package:flutter/material.dart';
import 'package:protectmee/utils/app_styles.dart';

import '../../user/screens/user_home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignup = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // TextEditingControllers to clear fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _toggleForm() {
    setState(() {
      _isSignup = !_isSignup;
      // Clear fields when toggling between signup and login
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _phoneController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      //  await _googleSignIn.signIn();
      // Handle successful Google sign-in here
    } catch (error) {
      print("Google sign-in failed: $error");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isSignup ? 'Create an Account' : 'Welcome Back',
                    style: titleTextStyle,
                  ),
                  spacing3,
                  if (_isSignup) ...[
                    _buildTextField(
                      label: 'Full Name',
                      hintText: 'Enter your full name',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    spacing2,
                  ],
                  _buildTextField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  spacing2,
                  if (_isSignup) ...[
                    _buildTextField(
                      label: 'Phone Number',
                      hintText: 'Enter your phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    spacing2,
                  ],
                  _buildPasswordField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    toggleVisibility: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  if (_isSignup) ...[
                    spacing2,
                    _buildPasswordField(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      toggleVisibility: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                  spacing2,
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                        String message = _isSignup ? 'Sign Up Successful' : 'Sign In Successful';
                        _showSnackbar(message);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D50F5),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      _isSignup ? 'SIGN UP' : 'SIGN IN',
                      style: bodyTextStyle,
                    ),
                  ),
                  spacing2,
                  Center(
                    child: Text(
                      'OR',
                      style: bodyTextStyle,
                    ),
                  ),
                  spacing2,
                  ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Image.asset('assets/google_icon.png', width: 20, height: 20),
                    label:
                    Text(_isSignup ? 'Sign up with Google' : 'Sign in with Google',
                      style: bodyTextStyle.copyWith(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  spacing3,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSignup ? 'Already have an account? ' : 'Don’t have an account? ',
                        style: bodyTextStyle,
                      ),
                      GestureDetector(
                        onTap: _toggleForm,
                        child: Text(
                          _isSignup ? 'Sign In' : 'Sign Up',
                          style: bodyTextStyle.copyWith(color: const Color(0xFF6D1FF2)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator, 
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: bodyTextStyle.copyWith(fontSize: 16)),
        spacing1,
        TextFormField(
          controller: controller,
          decoration: inputDecoration(hintText),
          style: inputTextStyle,
          keyboardType: keyboardType,
          validator: validator, 
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator, 
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: bodyTextStyle.copyWith(fontSize: 16)),
        spacing1,
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: inputDecoration('Enter your password').copyWith(
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: toggleVisibility,
              color: Colors.grey,
            ),
          ),
          style: inputTextStyle,
          validator: validator, 
        ),
      ],
    );
  }
}
