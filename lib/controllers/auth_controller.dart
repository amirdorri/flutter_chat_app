import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Rx<User?> _user = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isInitialized = false.obs;
  String? _lastKnownUid;

  User? get user => _user.value;
  UserModel? get userModel => _userModel.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isAuthenticated => _user.value != null;
  bool get isInitialized => _isInitialized.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_authService.authStateChanges);
    ever(_user, _handleAuthStateChanged);
  }

  void _handleAuthStateChanged(User? user) {
    final newUid = user?.uid;
    if (newUid == _lastKnownUid) {
      if (!_isInitialized.value) {
        _isInitialized.value = true;
      }
      return;
    }

    _lastKnownUid = newUid;

    if (user == null) {
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      if (Get.currentRoute != AppRoutes.profile) { //main
        Get.offAllNamed(AppRoutes.profile); //main
      }
    }

    if (!_isInitialized.value) {
      _isInitialized.value = true;
    }
  }

  void checkInitialAuthState() {
    final currentUser = FirebaseAuth.instance.currentUser;
    _lastKnownUid = currentUser?.uid;
    if (currentUser != null) {
      _user.value = currentUser;
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
    _isInitialized.value = true;
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.successColor.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      UserModel? userModel = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if (userModel != null) {
        _userModel.value = userModel;
        _lastKnownUid = FirebaseAuth.instance.currentUser?.uid;
        _showSuccessSnackbar('Welcome Back!', 'You have successfully signed in.');
        Get.offAllNamed(AppRoutes.main); //profile
      }
    } catch (e) {
      _error.value = e.toString();
      _showErrorSnackbar('Login Failed', 'Unable to sign in. Please check your credentials.');
      debugPrint('Error signing in: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email,
      String password,
      String displayName,
      ) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      UserModel? userModel = await _authService.registerWithEmailAndPassword(
        email,
        password,
        displayName,
      );
      if (userModel != null) {
        _userModel.value = userModel;
        _lastKnownUid = FirebaseAuth.instance.currentUser?.uid;
        // فراخوانی پیام موفقیت
        _showSuccessSnackbar('Account Created', 'Your account has been successfully created.');
        Get.offAllNamed(AppRoutes.main);
      }
    } catch (e) {
      _error.value = e.toString();
      _showErrorSnackbar('Registration Failed', 'Unable to create your account. Please try again.');
      debugPrint('Error creating account: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await _authService.signOut();
      _userModel.value = null;
      _lastKnownUid = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = e.toString();
      _showErrorSnackbar('Sign Out Failed', 'An error occurred while signing out.');
      debugPrint('Error signing out: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      _isLoading.value = true;
      await _authService.deleteAccount();
      _userModel.value = null;
      _lastKnownUid = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = e.toString();
      _showErrorSnackbar('Action Failed', 'An error occurred while deleting your account.');
      debugPrint('Error deleting account: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void clearError() => _error.value = '';
}
// import 'dart:math';
//
// import 'package:chat_app/models/user_model.dart';
// import 'package:chat_app/routes/app_routes.dart';
// import 'package:chat_app/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// class AuthController  extends GetxController {
//   final AuthService _authService = AuthService();
//   final Rx<User?> _user = Rx<User?>(null);
//   final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
//   final RxBool _isLoading = false.obs;
//   final RxString _error = ''.obs;
//   final RxBool _isInitialized = false.obs;
//   User? get user => _user.value;
//   UserModel? get userModel => _userModel.value;
//   bool get isLoading => _isLoading.value;
//   String get error => _error.value;
//   bool get isAuthenticated => _user.value != null;
//   bool get isInitialized => _isInitialized.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _user.bindStream(_authService.authStateChanges);
//     ever(_user, _handleAuthChanged);
//   }
//
// void _handleAuthChanged(User? user) {
//   if (user == null) {
//     if (Get.currentRoute != AppRoutes.login) {
//       Get.offAllNamed(AppRoutes.login);
//     }
//   } else {
//     if (Get.currentRoute != AppRoutes.main) {
//       Get.offAllNamed(AppRoutes.main);
//     }
//   }
//
//   if (!_isInitialized.value) {
//     _isInitialized.value = true;
//   }
// }
//   // void _handleAuthChanged(User? user) async {
//   //   if (user == null) {
//   //     if (Get.currentRoute != AppRoutes.login) {
//   //       Get.offAllNamed(AppRoutes.login);
//   //     } else {
//   //       if (Get.currentRoute != AppRoutes.main) {
//   //         Get.offAllNamed(AppRoutes.main);
//   //       }
//   //     }
//   //     if (!_isInitialized.value) {
//   //       _isInitialized.value = true;
//   //     }
//   //   }
//   // }
//
//   void checkInitialAuthState() {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       _user.value = currentUser;
//       Get.offAllNamed(AppRoutes.main);
//     } else {
//       Get.offAllNamed(AppRoutes.login);
//     }
//     _isInitialized.value = true;
//   }
//
//   Future<void> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       _isLoading.value = true;
//       _error.value = '';
//       UserModel? userModel = await _authService.signInWithEmailAndPassword(
//         email,
//         password,
//       );
//       if (userModel != null) {
//         _userModel.value = userModel;
//         Get.offAllNamed(AppRoutes.main);
//       }
//     } catch (e) {
//       _error.value = e.toString();
//       Get.snackbar('Error', 'Failed To Login');
//       print('Error signing in: $e');
//     } finally {
//       _isLoading.value = false;
//     }
//   }
//
//   Future<void> registerWithEmailAndPassword(
//     String email,
//     String password,
//     String displayName,
//   ) async {
//     try {
//       _isLoading.value = true;
//       _error.value = '';
//       UserModel? userModel = await _authService.registerWithEmailAndPassword(
//         email,
//         password,
//         displayName,
//       );
//       if (userModel != null) {
//         _userModel.value = userModel;
//         Get.offAllNamed(AppRoutes.main);
//       }
//     } catch (e) {
//       _error.value = e.toString();
//       Get.snackbar('Error', 'failed to create account');
//       print('Error creating account: $e');
//     } finally {
//       _isLoading.value = false;
//     }
//   }
//
//
//   Future<void> signOut() async {
//     try {
//       _isLoading.value = true;
//       await _authService.signOut();
//       _userModel.value = null;
//       Get.offAllNamed(AppRoutes.login);
//
//     } catch (e) {
//       _error.value = e.toString();
//       Get.snackbar('Error', 'failed to sign out');
//       print('Error signing out: $e');
//     } finally {
//       _isLoading.value = false;
//     }
//
//   }
//   Future<void> deleteAccount() async {
//     try {
//       _isLoading.value = true;
//       await _authService.deleteAccount();
//       _userModel.value = null;
//       Get.offAllNamed(AppRoutes.login);
//
//     } catch (e) {
//       _error.value = e.toString();
//       Get.snackbar('Error', 'failed to delete account');
//       print('Error deleting account: $e');
//     } finally {
//       _isLoading.value = false;
//     }
//   }
//
//   void clearError() => _error.value = '';
// }
