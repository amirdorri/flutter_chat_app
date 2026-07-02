import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //final AuthController _authController = Get.find<AuthController>();
  final AuthController _authController = Get.find<AuthController>();
  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
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
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
                    SizedBox(width: 8),
                    Text(
                      "Create Account",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Fill in your details to get started",
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
                  controller: _displayNameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Enter your Name',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please Enter Your Name';
                    }
                    return null;
                  },
                ),

                /////
                SizedBox(height: 16),
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
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obsecureConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obsecureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obsecureConfirmPassword = !_obsecureConfirmPassword;
                        });
                      },
                    ),
                    hintText: 'confirm your password',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'please confirm your password';
                    }
                    // اصلاح شده: مقایسه مستقیم مقدار این فیلد با فیلد پسورد
                    if (value != _passwordController.text) {
                      return 'passwords do not match';
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
                              _authController.registerWithEmailAndPassword(
                                _emailController.text.trim(),
                                _passwordController.text,
                                _displayNameController.text,
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
                              : Text('Create Account'),
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
                      "Already have an account? ",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: Text("Sign In", style: Theme
                          .of(context)
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
