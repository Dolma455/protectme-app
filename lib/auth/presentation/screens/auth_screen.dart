import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../admin/presentation/screens/admin_home_screen.dart';
import '../../../helpcenterr/presentation/screens/helpcenter_home_screen.dart';
import '../../../utils/app_styles.dart';
import '../../controller/login_user_controller.dart';
import '../../data/models/login_user_model.dart';
import '../../../user/presentation/screens/user_home_screen.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/repository/register_user_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignup = false;
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
                  Text(_isSignup ? 'Create an Account' : 'Welcome Back', style: titleTextStyle),
                  if (_isSignup) ...[
                    _buildTextField(
                      label: 'Full Name',
                      hintText: 'Enter your full name',
                      controller: _fullNameController,
                    ),
                    spacing2,
                    _buildTextField(
                      label: 'Phone Number',
                      hintText: 'Enter your phone number',
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                    ),
                    spacing2,
                    _buildTextField(
                      label: 'Address',
                      hintText: 'Enter your address',
                      controller: _addressController,
                    ),
                  ],
                  spacing2,
                  _buildTextField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  spacing2,
                  _buildPasswordField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    toggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 16),
                  Consumer(
                    builder: (context, ref, child) {
                      final loginUserState = ref.watch(loginControllerProvider);

                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_isSignup) {
                                  final registerModel = RegisterUserModel(
                                    fullName: _fullNameController.text,
                                    email: _emailController.text,
                                    phoneNumber: _phoneNumberController.text,
                                    address: _addressController.text,
                                    password: _passwordController.text,
                                  );
                                  // Call register user logic here
                                  ref.read(registerUserRepositoryProvider).registerUserRepo(registerModel).then((result) {
                                    result.fold(
                                      (error) {
                                        _showSnackbar(error.message, Colors.red);
                                      },
                                      (response) {
                                        // Handle successful registration
                                        _showSnackbar('Registration successful', Colors.green);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const UserHomeScreen()),
                                        );
                                      },
                                    );
                                  });
                                } else {
                                  final loginModel = LoginUserModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  ref.read(loginControllerProvider.notifier).login(loginModel.email, loginModel.password).then((message) {
                                    _showSnackbar(message, Colors.green);
                                    if (message.contains('Admin')) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
                                      );
                                    } else if (message.contains('Normal User')) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const UserHomeScreen()),
                                      );
                                    } else if (message.contains('HelpCenter')) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HelpCenterHomeScreen()),
                                      );
                                    } else {
                                      _showSnackbar('Unknown role: $message', Colors.red);
                                    }
                                  }).catchError((error) {
                                    _showSnackbar(error.toString(), Colors.red);
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8D50F5),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(_isSignup ? 'SIGN UP' : 'SIGN IN', style: bodyTextStyle),
                          ),
                          if (loginUserState is AsyncLoading) const CircularProgressIndicator(),
                          if (loginUserState is AsyncError)
                            Text('Error: ${loginUserState.error}', style: const TextStyle(color: Colors.red)),
                        ],
                      );
                    },
                  ),
                  spacing2,
                  Center(child: Text('OR', style: bodyTextStyle)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_isSignup ? 'Already have an account? ' : 'Don’t have an account? ', style: bodyTextStyle),
                      GestureDetector(
                        onTap: () => setState(() => _isSignup = !_isSignup),
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

  Widget _buildTextField({required String label, required String hintText, required TextEditingController controller, TextInputType keyboardType = TextInputType.text}) {
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
        ),
      ],
    );
  }

  Widget _buildPasswordField({required String label, required TextEditingController controller, required bool obscureText, required VoidCallback toggleVisibility}) {
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
        ),
      ],
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
