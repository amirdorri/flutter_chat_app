import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();

    // نکته کلیدی فیکس: این متد قبلاً خودش هم Get.offAllNamed رو صدا
    // میزد، دقیقاً همون کاری که AuthController._handleAuthStateChanged
    // هم انجام میده (اون یکی بلافاصله موقع اولین مقدار authStateChanges
    // اجرا میشه). این یعنی دو تا navigation مستقل و جدا به یه مسیر
    // (/profile) انجام میشد، که باعث میشد GetX دو بار binding صفحه‌ی
    // پروفایل رو اجرا کنه: یه بار ProfileController ساخته میشد،
    // بلافاصله با navigation دوم دیسپوز میشد و یه نمونه‌ی دوم جایگزینش
    // میشد. برای همین گاهی یه رفرنس قدیمی از TextEditingController
    // دیسپوزشده جایی می‌موند و باعث کرش میشد.
    //
    // الان دیگه SplashScreen خودش navigate نمیکنه. AuthController تنها
    // منبع تصمیم‌گیری navigation ـه (چه موقع استارتاپ، چه موقع لاگین/
    // لاگ‌اوت واقعی). این صفحه فقط انیمیشن رو نشون میده تا زمانی که
    // AuthController خودش تصمیم بگیره و از این صفحه رد بشه.
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: ((context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chat_bubble_rounded,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
                    ),

                    SizedBox(height: 32),
                    Text(
                      "Chat App",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Connect with friends Instantly",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 64),
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
