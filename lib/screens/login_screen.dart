import 'package:flutter/material.dart';
import 'package:my_market/resource/authen_method.dart';
import 'package:my_market/screens/mobScreen_layout.dart';
import 'package:my_market/screens/signup_screen.dart';
import 'package:my_market/screens/webscreen_layout.dart';
import 'package:my_market/util/utils.dart';
import 'package:my_market/widgets/text_field_input.dart';
import 'package:my_market/services/auth_service.dart';
import 'package:my_market/widgets/powered_by_footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'responsive_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isloading = false;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _checkBiometricLogin();
  }

  Future<void> _checkBiometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final useBiometrics = prefs.getBool('use_biometrics') ?? false;
    
    if (useBiometrics) {
      final credentials = await _authService.getCredentials();
      if (credentials['email'] != null && credentials['password'] != null) {
        final canUseBiometrics = await _authService.isBiometricsAvailable();
        if (canUseBiometrics) {
          final authenticated = await _authService.authenticateWithBiometrics();
          if (authenticated) {
            _emailController.text = credentials['email']!;
            _passwordController.text = credentials['password']!;
            loginUser();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isloading = true;
    });

    try {
      String res = await AuthMethods().loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (res == 'success') {
        if (_rememberMe) {
          await _authService.saveCredentials(
            _emailController.text.trim(),
            _passwordController.text,
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('use_biometrics', true);
        } else {
          await _authService.clearCredentials();
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('use_biometrics', false);
        }

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobScreenLayout: MobScreenLayout(),
              ),
            ),
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          showSnackBar(
            context,
            res,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context,
          'An error occurred: ${e.toString()}',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: MediaQuery.of(context).size.width > 900
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.fromLTRB(20, 50, 20, 5),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image(
                    image: const AssetImage("images/stall.png"),
                    width: 90,
                    height: 90,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "My Market",
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'Merriweather',
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 64),
                TextFieldInput(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  validator: _validateEmail,
                ),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: !_passwordVisible,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15,
                    ),
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: Divider.createBorderSide(context),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: Divider.createBorderSide(context),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: Divider.createBorderSide(context),
                    ),
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember me and use biometric login'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (_emailController.text.isEmpty) {
                          showSnackBar(
                            context,
                            'Please enter your email first',
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                        try {
                          await AuthMethods().resetPassword(
                            email: _emailController.text.trim(),
                          );
                          if (context.mounted) {
                            showSnackBar(
                              context,
                              'Password reset email has been sent!',
                              backgroundColor: Colors.green,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showSnackBar(
                              context,
                              'Failed to send reset email: ${e.toString()}',
                              backgroundColor: Colors.red,
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Color(0xFF95D6A4),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'NotoSans',
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF95D6A4),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isloading ? null : loginUser,
                    child: _isloading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'NotoSans',
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUP(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color(0xFF95D6A4),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'NotoSans',
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin/login');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                  child: const Text(
                    'Admin Login',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                const PoweredByFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
