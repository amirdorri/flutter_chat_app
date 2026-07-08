import 'package:chat_app/controllers/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security_rounded,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Update your password',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Enter your current password and choose a new secure password',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppTheme.secondaryColor,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 40),
                Obx(
                      () => TextFormField(
                    controller: controller.currentPasswordController,
                    obscureText: controller.obscureCurrentPassword,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: controller.toggleCurrentPasswordVisibility,
                        icon: Icon(
                          controller.obscureCurrentPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      hintText: 'Enter your current password',
                    ),
                    validator: controller.validateCurrentPassword,
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                      () => TextFormField(
                    controller: controller.newPasswordController,
                    obscureText: controller.obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: controller.toggleNewPasswordVisibility,
                        icon: Icon(
                          controller.obscureNewPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      hintText: 'Enter your new password',
                    ),
                    validator: controller.validateNewPassword,
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                      () => TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: controller.toggleConfirmPasswordVisibility,
                        icon: Icon(
                          controller.obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      hintText: 'confirm your new password',
                    ),
                    validator: controller.validateConfirmPassword,
                  ),
                ),
                SizedBox(height: 40),
                Obx(
                      () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.isLoading
                          ? null
                          : controller.changePassword,
                      icon: controller.isLoading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Icon(Icons.security),

                      label: Text(
                        controller.isLoading
                            ? 'Updating...'
                            : 'Update Password',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// class ChangePasswordScreen extends StatelessWidget {
//   const ChangePasswordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ChangePasswordController());
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Change Password')),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(24),
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 Center(
//                   child: Container(
//                     height: 100,
//                     width: 100,
//                     decoration: BoxDecoration(
//                       color: AppTheme.primaryColor.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.security_rounded,
//                       size: 40,
//                       color: AppTheme.primaryColor,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Text(
//                   'Update your password',
//                   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Enter your current password and choose a new secure password',
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                     color: AppTheme.secondaryColor,
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//                 SizedBox(height: 40),
//                 Obx(
//                   () => TextFormField(
//                     controller: controller.currentPasswordController,
//                     obscureText: controller.obscureCurrentPassword,
//                     decoration: InputDecoration(
//                       labelText: 'Current Password',
//                       prefixIcon: Icon(Icons.lock_outline),
//                       suffixIcon: IconButton(
//                         onPressed: controller.toggleCurrentPasswordVisibility,
//                         icon: Icon(
//                           controller.obscureCurrentPassword
//                               ? Icons.visibility_outlined
//                               : Icons.visibility_off_outlined,
//                         ),
//                       ),
//                       hintText: 'Enter your current password',
//                     ),
//                     validator: controller.validateCurrentPassword,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Obx(
//                   () => TextFormField(
//                     controller: controller.newPasswordController,
//                     obscureText: controller.obscureNewPassword,
//                     decoration: InputDecoration(
//                       labelText: 'New Password',
//                       prefixIcon: Icon(Icons.lock_outline),
//                       suffixIcon: IconButton(
//                         onPressed: controller.toggleNewPasswordVisibility,
//                         icon: Icon(
//                           controller.obscureNewPassword
//                               ? Icons.visibility_outlined
//                               : Icons.visibility_off_outlined,
//                         ),
//                       ),
//                       hintText: 'Enter your new password',
//                     ),
//                     validator: controller.validateNewPassword,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Obx(
//                   () => TextFormField(
//                     controller: controller.confirmPasswordController,
//                     obscureText: controller.obscureConfirmPassword,
//                     decoration: InputDecoration(
//                       labelText: 'Confirm New Password',
//                       prefixIcon: Icon(Icons.lock_outline),
//                       suffixIcon: IconButton(
//                         onPressed: controller.toggleConfirmPasswordVisibility,
//                         icon: Icon(
//                           controller.obscureConfirmPassword
//                               ? Icons.visibility_outlined
//                               : Icons.visibility_off_outlined,
//                         ),
//                       ),
//                       hintText: 'confirm your new password',
//                     ),
//                     validator: controller.validateConfirmPassword,
//                   ),
//                 ),
//                 SizedBox(height: 40),
//                 Obx(
//                   () => SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: controller.isLoading
//                           ? null
//                           : controller.changePassword,
//                       icon: controller.isLoading
//                           ? SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Icon(Icons.security),
//
//                       label: Text(
//                         controller.isLoading
//                             ? 'Updating...'
//                             : 'Update Password',
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
