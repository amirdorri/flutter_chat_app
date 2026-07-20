import 'dart:ui';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/friend_request_model.dart';
import 'auth_controller.dart';

class FriendRequestsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<FriendRequestModel> _receivedRequests =
      <FriendRequestModel>[].obs;
  final RxList<FriendRequestModel> _sentRequests = <FriendRequestModel>[].obs;
  final RxMap<String, UserModel> _users = <String, UserModel>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxInt _selectedTabIndex = 0.obs;

  RxList<FriendRequestModel> get receivedRequests => _receivedRequests;

  RxList<FriendRequestModel> get sentRequests => _sentRequests;

  RxMap<String, UserModel> get users => _users;

  bool get isLoading => _isLoading.value;

  String get error => _error.value;

  int get selectedTabIndex => _selectedTabIndex.value;

  @override
  void onInit() {
    super.onInit();
    _loadFriendRequests();
    _loadUsers();
  }

  void _loadFriendRequests() async {
    final currentUserId = _authController.user?.uid;
    if (currentUserId != null) {
      _receivedRequests.bindStream(
        _firestoreService.getFriendRequestsStream(currentUserId),
      );
      _sentRequests.bindStream(
        _firestoreService.getSentFriendRequestsStream(currentUserId),
      );
    }
  }

  void _loadUsers() {
    _users.bindStream(
      _firestoreService.getAllUsersStream().map((userList) {
        Map<String, UserModel> userMap = {};
        for (var user in userList) {
          userMap[user.id] = user;
        }
        return userMap;
      }),
    );
  }

  void changeTab(int index) {
    _selectedTabIndex.value = index;
  }

  UserModel? getUser(String userId) {
    return _users[userId];
  }

  Future<void> acceptFriendRequest(FriendRequestModel request) async {
    try {
      _isLoading.value = true;
      await _firestoreService.respondToFriendRequest(
        request.id,
        FriendRequestStatus.accepted,
      );
      Get.snackbar('Success', 'Friend request accepted');
    } catch (e) {
      Get.log(e.toString());
      _error.value = 'Failed to accept friend request';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> declineFriendRequest(FriendRequestModel request) async {
    try {
      _isLoading.value = true;
      await _firestoreService.respondToFriendRequest(
        request.id,
        FriendRequestStatus.declined,
      );
      Get.snackbar('Success', 'Friend request declined');
    } catch (e) {
      Get.log(e.toString());
      _error.value = 'Failed to decline friend request';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      _isLoading.value = true;
      await _firestoreService.unblockUser(_authController.user!.uid, userId);
      Get.snackbar('Success', 'user unblocked');
    } catch (e) {
      Get.log(e.toString());
      _error.value = 'Failed to unblocked the user';
    } finally {
      _isLoading.value = false;
    }
  }

  String getRequestTimeText(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }
    if (difference.inHours < 1) {
      return '${difference.inMinutes} m ago';
    }
    if (difference.inDays < 1) {
      return '${difference.inHours} h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays} d ago';
    }

    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    return '$day/$month/${createdAt.year}';
  }

  String getStatusText(FriendRequestStatus status) => switch (status) {
    FriendRequestStatus.pending => 'Pending',
    FriendRequestStatus.accepted => 'Accepted',
    FriendRequestStatus.declined => 'Declined',
  };

  Color getStatusColor(FriendRequestStatus status) => switch (status) {
    FriendRequestStatus.pending => Colors.orange,
    FriendRequestStatus.accepted => AppTheme.successColor,
    FriendRequestStatus.declined => AppTheme.errorColor,
  };

  void clearError() => _error.value = '';
  
}
