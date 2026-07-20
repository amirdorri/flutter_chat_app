import 'package:chat_app/controllers/main_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/views/splash_screen.dart';
import 'package:chat_app/views/auth/forgot_password_screen.dart';
import 'package:chat_app/views/auth/login_screen.dart';
import 'package:chat_app/views/main_screen.dart';
import 'package:get/get.dart';

import '../controllers/friend_controller.dart';
import '../controllers/friend_request_controller.dart';
import '../controllers/profile_controller.dart';
import '../views/auth/register_screen.dart';
import '../views/friend_request_screen.dart';
import '../views/friends_screen.dart';
import '../views/profile/change_password_screen.dart';
import '../views/profile/profile_screen.dart';

class AppPages {
  static const initial = AppRoutes.splash;
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),

    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),

    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
    ),

    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      binding: BindingsBuilder(() {
        Get.put(MainController());
      }),
    ),

    GetPage(
      name: AppRoutes.friends,
      page: () => const FriendsScreen(),
      binding: BindingsBuilder(() {
        Get.put(FriendsController());
      }),
    ),

    GetPage(
      name: AppRoutes.friendsRequests,
      page: () => const FriendRequestsScreen(),
      binding: BindingsBuilder(() {
        Get.put((FriendRequestsController));
      }),
    ),

    //   GetPage(
    //     name: AppRoutes.home,
    //     page: () => const HomeScreen(),
    // binding: BindingsBuilder((){
    // Get.put(HoemController());
    // }
    //   ),

    //   GetPage(
    //     name: AppRoutes.chat,
    //     page: () => const ChatScreen(),
    // binding: BindingsBuilder((){
    // Get.put(ChatController());
    // }
    //   ),
    //   GetPage(
    //     name: AppRoutes.usersList,
    //     page: () => const UsersListScreen(),
    // binding: BindingsBuilder((){
    // Get.put(UserListController());
    // }
    //   ),

    //
    //   ),

    //   GetPage(
    //     name: AppRoutes.notifications,
    //     page: () => const NotificationsScreen(),
    //     binding: BindingsBuilder((){
    //       Get.put(NotificationsController());
    //     }
    //
    //     )
    //   ),
  ];
}
