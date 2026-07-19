import 'package:chat_app/controllers/profile_controller.dart';
import 'package:chat_app/controllers/user_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'friend_controller.dart';

class MainController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  final PageController pageController = PageController();

  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();
    //init all required controllers here
    //Get.lazyPut(() => HomeController());
    Get.lazyPut(() => FriendsController());
    Get.lazyPut(() => UsersListController());
    Get.lazyPut(() => ProfileController());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changeTabIndex(int index) {
    _currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    _currentIndex.value = index;
  }

  int getUnreadCount() {
    try {
      //final homeController = Get.find<HomeController>();
      // return homeController.getTotalUnreadCount();
      return 5; // Placeholder return value since HomeController is commented out
    } catch (e) {
      return 0;
    }
  }

  int getNotificationCount() {
    try {
      //final homeController = Get.find<HomeController>();
      // return homeController.getUnreadNotificationsCount();
      return 7; // Placeholder return value since HomeController is commented out
    } catch (e) {
      return 0;
    }
  }
}
