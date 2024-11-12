// // import 'package:flutter/material.dart';
// // import 'package:protectmee/utils/app_styles.dart';

// // import '../../../user/screens/user_home_screen.dart';

// // class AuthScreen extends StatefulWidget {
// //   const AuthScreen({super.key});

// //   @override
// //   _AuthScreenState createState() => _AuthScreenState();
// // }

// // class _AuthScreenState extends State<AuthScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   bool _isSignup = false;
// //   bool _obscurePassword = true;
// //   bool _obscureConfirmPassword = true;

// //   // TextEditingControllers to clear fields
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _confirmPasswordController = TextEditingController();

// //   void _toggleForm() {
// //     setState(() {
// //       _isSignup = !_isSignup;
// //       // Clear fields when toggling between signup and login
// //       _emailController.clear();
// //       _passwordController.clear();
// //       _nameController.clear();
// //       _phoneController.clear();
// //       _confirmPasswordController.clear();
// //     });
// //   }

// //   Future<void> _signInWithGoogle() async {
// //     try {
// //       //  await _googleSignIn.signIn();
// //       // Handle successful Google sign-in here
// //     } catch (error) {
// //       print("Google sign-in failed: $error");
// //     }
// //   }

// //   void _showSnackbar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         duration: const Duration(seconds: 2),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF0E0E0E),
// //       body: Center(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
// //           child: Container(
// //             constraints: const BoxConstraints(maxWidth: 480),
// //             child: Form(
// //               key: _formKey,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     _isSignup ? 'Create an Account' : 'Welcome Back',
// //                     style: titleTextStyle,
// //                   ),
// //                   spacing3,
// //                   if (_isSignup) ...[
// //                     _buildTextField(
// //                       label: 'Full Name',
// //                       hintText: 'Enter your full name',
// //                       controller: _nameController,
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter your full name';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     spacing2,
// //                   ],
// //                   _buildTextField(
// //                     label: 'Email',
// //                     hintText: 'Enter your email',
// //                     controller: _emailController,
// //                     keyboardType: TextInputType.emailAddress,
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your email';
// //                       }
// //                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
// //                         return 'Please enter a valid email address';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   spacing2,
// //                   if (_isSignup) ...[
// //                     _buildTextField(
// //                       label: 'Phone Number',
// //                       hintText: 'Enter your phone number',
// //                       controller: _phoneController,
// //                       keyboardType: TextInputType.phone,
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter your phone number';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     spacing2,
// //                   ],
// //                   _buildPasswordField(
// //                     label: 'Password',
// //                     controller: _passwordController,
// //                     obscureText: _obscurePassword,
// //                     toggleVisibility: () {
// //                       setState(() => _obscurePassword = !_obscurePassword);
// //                     },
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your password';
// //                       }
// //                       if (value.length < 6) {
// //                         return 'Password must be at least 6 characters long';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   if (_isSignup) ...[
// //                     spacing2,
// //                     _buildPasswordField(
// //                       label: 'Confirm Password',
// //                       controller: _confirmPasswordController,
// //                       obscureText: _obscureConfirmPassword,
// //                       toggleVisibility: () {
// //                         setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
// //                       },
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please confirm your password';
// //                         }
// //                         if (value != _passwordController.text) {
// //                           return 'Passwords do not match';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                   ],
// //                   spacing2,
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       if (_formKey.currentState!.validate()) {
// //                         // Handle form submission
// //                         String message = _isSignup ? 'Sign Up Successful' : 'Sign In Successful';
// //                         _showSnackbar(message);
// //                         Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
// //                       }
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFF8D50F5),
// //                       minimumSize: const Size(double.infinity, 50),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                     ),
// //                     child: Text(
// //                       _isSignup ? 'SIGN UP' : 'SIGN IN',
// //                       style: bodyTextStyle,
// //                     ),
// //                   ),
// //                   spacing2,
// //                   Center(
// //                     child: Text(
// //                       'OR',
// //                       style: bodyTextStyle,
// //                     ),
// //                   ),
// //                   spacing2,
// //                   ElevatedButton.icon(
// //                     onPressed: _signInWithGoogle,
// //                     icon: Image.asset('assets/google_icon.png', width: 20, height: 20),
// //                     label:
// //                     Text(_isSignup ? 'Sign up with Google' : 'Sign in with Google',
// //                       style: bodyTextStyle.copyWith(color: Colors.black),
// //                     ),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.white,
// //                       minimumSize: const Size(double.infinity, 50),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                     ),
// //                   ),
// //                   spacing3,
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         _isSignup ? 'Already have an account? ' : 'Don’t have an account? ',
// //                         style: bodyTextStyle,
// //                       ),
// //                       GestureDetector(
// //                         onTap: _toggleForm,
// //                         child: Text(
// //                           _isSignup ? 'Sign In' : 'Sign Up',
// //                           style: bodyTextStyle.copyWith(color: const Color(0xFF6D1FF2)),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTextField({
// //     required String label,
// //     required String hintText,
// //     required TextEditingController controller,
// //     TextInputType keyboardType = TextInputType.text,
// //     String? Function(String?)? validator, 
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: bodyTextStyle.copyWith(fontSize: 16)),
// //         spacing1,
// //         TextFormField(
// //           controller: controller,
// //           decoration: inputDecoration(hintText),
// //           style: inputTextStyle,
// //           keyboardType: keyboardType,
// //           validator: validator, 
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildPasswordField({
// //     required String label,
// //     required TextEditingController controller,
// //     required bool obscureText,
// //     required VoidCallback toggleVisibility,
// //     String? Function(String?)? validator, 
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: bodyTextStyle.copyWith(fontSize: 16)),
// //         spacing1,
// //         TextFormField(
// //           controller: controller,
// //           obscureText: obscureText,
// //           decoration: inputDecoration('Enter your password').copyWith(
// //             suffixIcon: IconButton(
// //               icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
// //               onPressed: toggleVisibility,
// //               color: Colors.grey,
// //             ),
// //           ),
// //           style: inputTextStyle,
// //           validator: validator, 
// //         ),
// //       ],
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../utils/app_styles.dart';
// import '../../controller/register_user_controller.dart.dart';
// import '../../data/models/user_model.dart';

// class AuthScreen extends ConsumerStatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends ConsumerState<AuthScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isSignup = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0E0E0E),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 480),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _isSignup ? 'Create an Account' : 'Welcome Back',
//                     style: titleTextStyle,
//                   ),
//                   if (_isSignup) ...[
//                     _buildTextField(
//                       label: 'Full Name',
//                       hintText: 'Enter your full name',
//                       controller: _nameController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your full name';
//                         }
//                         return null;
//                       },
//                     ),
//                      _buildTextField(
//                     label: 'Email',
//                     hintText: 'Enter your email',
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                   ),
                   
//                   ],
                 
//                   if(_isSignup) ...[
//                      _buildTextField(
//                       label: 'Phone Number',
//                       hintText: 'Enter your phone number',
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     _buildTextField(
//                       label: 'Address',
//                       hintText: 'Enter your address',
//                       controller: _addressController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your address';
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
                 
//                   _buildPasswordField(
//                     label: 'Password',
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     toggleVisibility: () {
//                       setState(() => _obscurePassword = !_obscurePassword);
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters long';
//                       }
//                       return null;
//                     },
//                   ),
//                   // if (_isSignup) ...[
//                   //   _buildPasswordField(
//                   //     label: 'Confirm Password',
//                   //     controller: _confirmPasswordController,
//                   //     obscureText: _obscureConfirmPassword,
//                   //     toggleVisibility: () {
//                   //       setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
//                   //     },
//                   //     validator: (value) {
//                   //       if (value == null || value.isEmpty) {
//                   //         return 'Please confirm your password';
//                   //       }
//                   //       if (value != _passwordController.text) {
//                   //         return 'Passwords do not match';
//                   //       }
//                   //       return null;
//                   //     },
//                   //   ),
//                   // ],
//                   Consumer(
//                     builder: (context, ref, child) {
//                       final registerUserState = ref.watch(registerUserNotifierProvider);

//                       return Column(
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 final userModel = RegisterUserModel(
//                                   fullName: _nameController.text,
//                                   email: _emailController.text,
//                                   phoneNumber: _phoneController.text,
//                                   address: _addressController.text,
//                                   password: _passwordController.text,
//                                 );
//                                 ref.read(registerUserNotifierProvider.notifier).registerUser(userModel);
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF8D50F5),
//                               minimumSize: const Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                             ),
//                             child: Text(_isSignup ? 'SIGN UP' : 'SIGN IN', style: bodyTextStyle),
//                           ),
//                           if (registerUserState is AsyncLoading) const CircularProgressIndicator(),
//                           if (registerUserState is AsyncError) Text('Error: ${registerUserState.error}', style: const TextStyle(color: Colors.red)),
//                           if (registerUserState is AsyncData) Text('Registration successful: ${registerUserState.value?.message}', style: const TextStyle(color: Colors.green)),
//                         ],
//                       );
//                     },
//                   ),
//                   Center(child: Text('OR', style: bodyTextStyle)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(_isSignup ? 'Already have an account? ' : 'Don’t have an account? ', style: bodyTextStyle),
//                       GestureDetector(
//                         onTap: _toggleForm,
//                         child: Text(
//                           _isSignup ? 'Sign In' : 'Sign Up',
//                           style: bodyTextStyle.copyWith(color: const Color(0xFF6D1FF2)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required String hintText,
//     required TextEditingController controller,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: bodyTextStyle.copyWith(fontSize: 16)),
//         spacing1,
//         TextFormField(
//           controller: controller,
//           decoration: inputDecoration(hintText),
//           style: inputTextStyle,
//           keyboardType: keyboardType,
//           validator: validator,
//         ),
//         spacing1,
//       ],
//     );
//   }

//   Widget _buildPasswordField({
//     required String label,
//     required TextEditingController controller,
//     required bool obscureText,
//     required VoidCallback toggleVisibility,
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: bodyTextStyle.copyWith(fontSize: 16)),
//         spacing1,
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           decoration: inputDecoration('Enter your password').copyWith(
//             suffixIcon: IconButton(
//               icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
//               onPressed: toggleVisibility,
//               color: Colors.grey,
//             ),
//           ),
//           style: inputTextStyle,
//           validator: validator,
//         ),
//         spacing1,
//       ],
//     );
//   }

//   void _toggleForm() {
//     setState(() {
//       _isSignup = !_isSignup;
//     });
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/auth/data/models/user_model.dart';
import '../../../utils/app_styles.dart';
import '../../controller/register_user_controller.dart';
import '../../controller/login_user_controller.dart';
import '../../controller/register_user_controller.dart.dart';
import '../../data/models/register_user_model.dart';
import '../../data/models/login_user_model.dart';
import '../../../admin/presentation/screens/admin_home_screen.dart';
import '../../../user/screens/user_home_screen.dart';
import '../../../helpcenterr/screens/helpcenter_home_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignup = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                    _buildTextField(
                      label: 'Address',
                      hintText: 'Enter your address',
                      controller: _addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
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
                  Consumer(
                    builder: (context, ref, child) {
                      final registerUserState = ref.watch(registerUserNotifierProvider);
                      final loginUserState = ref.watch(loginUserNotifierProvider);

                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_isSignup) {
                                  final userModel = RegisterUserModel(
                                    fullName: _nameController.text,
                                    email: _emailController.text,
                                    phoneNumber: _phoneController.text,
                                    address: _addressController.text,
                                    password: _passwordController.text,
                                  );
                                  ref.read(registerUserNotifierProvider.notifier).registerUser(userModel);
                                } else {
                                  final loginModel = LoginUserModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  ref.read(loginUserNotifierProvider.notifier).loginUser(loginModel).then((message) {
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
                                    } else if (message.contains('Police')) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HelpCenterHomeScreen()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                    }
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
                          if (registerUserState is AsyncLoading || loginUserState is AsyncLoading)
                            const CircularProgressIndicator(),
                          if (registerUserState is AsyncError)
                            Text('Error: ${registerUserState.error}', style: const TextStyle(color: Colors.red)),
                          if (loginUserState is AsyncError)
                            Text('Error: ${loginUserState.error}', style: const TextStyle(color: Colors.red)),
                          if (registerUserState is AsyncData)
                            Text('Registration successful: ${registerUserState.value}', style: const TextStyle(color: Colors.green)),
                          if (loginUserState is AsyncData)
                            Text('Login successful: ${loginUserState.value}', style: const TextStyle(color: Colors.green)),
                        ],
                      );
                    },
                  ),
                  Center(child: Text('OR', style: bodyTextStyle)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_isSignup ? 'Already have an account? ' : 'Don’t have an account? ', style: bodyTextStyle),
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
        spacing1,
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
        spacing1,
      ],
    );
  }

  void _toggleForm() {
    setState(() {
      _isSignup = !_isSignup;
    });
  }
}