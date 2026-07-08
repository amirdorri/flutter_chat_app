import 'package:chat_app/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ChangePasswordController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _obscureCurrentPassword = true.obs;
  final RxBool _obscureNewPassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  bool get isLoading => _isLoading.value;

  String get error => _error.value;

  bool get obscureCurrentPassword => _obscureCurrentPassword.value;

  bool get obscureNewPassword => _obscureNewPassword.value;

  bool get obscureConfirmPassword => _obscureConfirmPassword.value;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentPasswordVisibility() {
    _obscureCurrentPassword.value = !_obscureCurrentPassword.value;
  }

  void toggleNewPasswordVisibility() {
    _obscureNewPassword.value = !_obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
  }

  Future<void> changePassword() async {
    debugPrint('CPW: changePassword() called');

    if (!formKey.currentState!.validate()) {
      debugPrint('CPW: form validation failed, aborting');
      return;
    }
    debugPrint('CPW: form validated OK');

    try {
      _isLoading.value = true;
      _error.value = '';

      final user = FirebaseAuth.instance.currentUser;
      debugPrint('CPW: currentUser = ${user?.uid}, email = ${user?.email}');

      if (user == null) {
        debugPrint('CPW: user is null, throwing');
        throw Exception('No user logged in');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text,
      );
      debugPrint('CPW: credential built, about to reauthenticate');

      await user.reauthenticateWithCredential(credential);
      debugPrint('CPW: reauthenticateWithCredential SUCCESS');

      await user.updatePassword(newPasswordController.text);
      debugPrint('CPW: updatePassword SUCCESS');

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      debugPrint('CPW: fields cleared');

      const snackbarDuration = Duration(seconds: 3);
      Get.snackbar(
        "Success",
        "Password Changed Successfully",
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: snackbarDuration,
      );
      debugPrint('CPW: success snackbar shown');

      // مهم: باید صبر کنیم تا خود اسنک‌بار کامل duration ـش رو طی کنه
      // و خودش بسته بشه، بعد Get.back() رو صدا بزنیم. اگه زودتر
      // Get.back() رو صدا بزنیم، چون route عوض میشه، همون overlay
      // اسنک‌بار هم زودتر از موعد بسته میشه.
      _isLoading.value = false;
      await Future.delayed(snackbarDuration);
      debugPrint('CPW: waited full snackbar duration, calling Get.back()');
      Get.back();
      debugPrint('CPW: Get.back() called, function returning');
      return;
    } on FirebaseAuthException catch (e) {
      debugPrint('CPW: FirebaseAuthException caught -> code=${e.code}, message=${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current password is incorrect';
          break;
        case 'weak-password':
          errorMessage = 'New password is too weak';
          break;
        case 'requires-recent-login':
          errorMessage =
          'Please sign out and sign in before changing password';
          break;
        case 'invalid-credential':
          errorMessage = 'Current password is incorrect';
          break;
        case 'user-mismatch':
          errorMessage = 'Credential does not match current user';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error, check your connection';
          break;
        default:
          errorMessage = "Failed to change password (${e.code})";
      }
      _error.value = errorMessage;
      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stack) {
      debugPrint('CPW: generic catch -> $e');
      debugPrint('CPW: stack trace -> $stack');
      _error.value = "Failed To Change Password";
      Get.snackbar(
        "Error",
        _error.value,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      debugPrint('CPW: finally block, isLoading -> false');
      _isLoading.value = false;
    }
  }

  String? validateCurrentPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your current password';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a new password';
    }
    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value == currentPasswordController.text) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please confirm your new password';
    }
    if (value != newPasswordController.text) {
      return 'Password does not match';
    }
    return null;
  }

  void clearError() => _error.value = '';
}

// class ChangePasswordController extends GetxController {
//   final AuthController _authController = Get.find<AuthController>();
//   final TextEditingController currentPasswordController =
//       TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   final RxBool _isLoading = false.obs;
//   final RxString _error = ''.obs;
//   final RxBool _obscureCurrentPassword = true.obs;
//   final RxBool _obscureNewPassword = true.obs;
//   final RxBool _obscureConfirmPassword = true.obs;
//
//   bool get isLoading => _isLoading.value;
//
//   String get error => _error.value;
//
//   bool get obscureCurrentPassword => _obscureCurrentPassword.value;
//
//   bool get obscureNewPassword => _obscureNewPassword.value;
//
//   bool get obscureConfirmPassword => _obscureConfirmPassword.value;
//
//   @override
//   void onClose() {
//     currentPasswordController.dispose();
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }
//
//   void toggleCurrentPasswordVisibility() {
//     _obscureCurrentPassword.value = !_obscureCurrentPassword.value;
//   }
//
//   void toggleNewPasswordVisibility() {
//     _obscureNewPassword.value = !_obscureNewPassword.value;
//   }
//
//   void toggleConfirmPasswordVisibility() {
//     _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
//   }
//
//   Future<void> changePassword() async {
//     if (!formKey.currentState!.validate()) return;
//     try {
//       _isLoading.value = true;
//       _error.value = '';
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception('No user logged in');
//       }
//       final credential = EmailAuthProvider.credential(
//         email: user.email!,
//         password: currentPasswordController.text,
//       );
//       await user.reauthenticateWithCredential(credential);
//       await user.updatePassword(newPasswordController.text);
//       Get.snackbar(
//         "Success",
//         "Password Changed Successfully",
//         backgroundColor: Colors.green.withOpacity(0.1),
//         colorText: Colors.green,
//         duration: Duration(seconds: 3),
//       );
//       currentPasswordController.clear();
//       newPasswordController.clear();
//       confirmPasswordController.clear();
//
//       Get.back();
//     } on FirebaseAuthException catch (e) {
//       String errorMessage;
//       switch (e.code) {
//         case 'wrong-password':
//           errorMessage = 'Current password is incorrect';
//           break;
//         case 'weak-password':
//           errorMessage = 'New password is too weak';
//           break;
//         case 'requires-recent-login':
//           errorMessage = 'Please sign out and sign in before changing password';
//           break;
//
//         default:
//           errorMessage = "Failed to change password";
//       }
//       _error.value = errorMessage;
//       Get.snackbar(
//         "Error",
//         errorMessage,
//         backgroundColor: Colors.red.withOpacity(0.1),
//         colorText: Colors.red,
//         duration: Duration(seconds: 3),
//       );
//     } catch (e) {
//       _error.value = "Failed To Change Password";
//       print(e.toString());
//       Get.snackbar(
//         "Error",
//         _error.value,
//         backgroundColor: Colors.red.withOpacity(0.1),
//         colorText: Colors.red,
//         duration: Duration(seconds: 3),
//       );
//     } finally {
//       _isLoading.value = false;
//     }
//   }
//
//   String? validateCurrentPassword(String? value) {
//     if(value?.isEmpty ?? true){
//       return 'Please enter your current password';
//     }
//     return null;
//   }
//
//   String? validateNewPassword(String? value) {
//     if(value?.isEmpty ?? true){
//       return 'Please enter a new password';
//     }
//     if(value!.length < 6){
//       return 'Password must be at least 6 characters';
//     }
//     if(value == currentPasswordController.text){
//       return 'New password must be different from current password';
//     }
//     return null;
//   }
//
//   String? validateConfirmPassword(String? value) {
//     if(value?.isEmpty ?? true){
//       return 'Please confirm your new password';
//     }
//     if(value != newPasswordController.text){
//       return 'Password does not match';
//     }
//     return null;
//   }
//
//   void clearError() => _error.value = '';
// }
