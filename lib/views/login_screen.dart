import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //final AuthController _authController = Get.find<AuthController>();
  final AuthController _authController = Get.find<AuthController>();
  bool _obsecurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  "Welcome Back!",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineLarge,
                ),
                SizedBox(height: 8),
                Text(
                  "Sign in to continue chatting with friends and family",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: AppTheme.secondaryColor,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Enter your Email',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please Enter Your Email';
                    }
                    if (!GetUtils.isEmail(value!)) {
                      return 'Please Enter a Valid Email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obsecurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obsecurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obsecurePassword = !_obsecurePassword;
                        });
                      },
                    ),
                    hintText: 'Enter your password',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please Enter Your Password';
                    }
                    if (value!.length < 6) {
                      return 'password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Obx(
                      () =>
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _authController.isLoading ? null : () {
                            // if (formKey.currentState?.validate() ?? false) {
                            //   _authController.signInWithEmailAndPassword(
                            //       _emailController.text.trim(),
                            //       _passwordController.text);
                            // }
                            final valid = formKey.currentState!.validate();
                            if (valid) {
                              _authController.signInWithEmailAndPassword(
                                _emailController.text.trim(),
                                _passwordController.text,
                              );
                            }
                          },
                          child: _authController.isLoading
                              ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text('Sign In'),
                        ),
                      ),
                ),
                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppTheme.borderColor)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall),
                    ),
                    Expanded(child: Divider(color: AppTheme.borderColor,)),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.register),
                      child: Text("Sign Up", style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600
                      )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
