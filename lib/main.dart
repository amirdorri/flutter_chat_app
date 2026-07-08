import 'package:chat_app/routes/app_pages.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Chat App",
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      // نکته کلیدی فیکس: AuthController رو دیگه توی main() و قبل از
      // runApp() نمی‌سازیم. به جاش اینجا، توی initialBinding میسازیمش.
      // GetX تضمین میکنه که این binding دقیقاً موقع build شدن خود
      // GetMaterialApp اجرا بشه، یعنی Get.key از قبل مقداردهی شده و
      // آماده‌ست. اینجوری وقتی AuthController.onInit() صدا زده میشه و
      // بلافاصله میخواد Get.offAllNamed(...) رو اجرا کنه، دیگه
      // "contextless navigation without a GetMaterialApp or Get.key"
      // exception نمیخوریم.
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),
    );
  }
}
// void main() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   Get.put(AuthController(), permanent: true);
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: "Chat App",
//       theme: AppTheme.lightTheme,
//       themeMode: ThemeMode.light,
//       initialRoute: AppPages.initial,
//       getPages: AppPages.routes,
//       debugShowCheckedModeBanner: false,
//
//     );
//   }
// }
