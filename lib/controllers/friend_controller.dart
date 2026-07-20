import 'dart:async';
import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/models/friendship_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../views/friend_request_screen.dart';
import 'friend_request_controller.dart';

class FriendsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<FriendshipModel> _friendships = <FriendshipModel>[].obs;
  final RxList<UserModel> _friends = <UserModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxList<UserModel> _filteredFriends = <UserModel>[].obs;
  StreamSubscription? _friendshipsSubscription;

  List<FriendshipModel> get friendships => _friendships.toList();

  List<UserModel> get friends => _friends;

  List<UserModel> get filteredFriends => _filteredFriends;

  bool get isLoading => _isLoading.value;

  String get error => _error.value;

  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    _loadFriends();
    debounce(
      _searchQuery,
      (_) => _filterFriends(),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    _friendshipsSubscription?.cancel();
    super.onClose();
  }

  void _loadFriends() {
    final currentUserId = _authController.user?.uid;
    if (currentUserId != null) {
      _friendshipsSubscription?.cancel();

      _friendshipsSubscription = _firestoreService
          .getFriendsStream(currentUserId)
          .listen((friendshipList) {
            _friendships.value = friendshipList;
            _loadFriendDetails(currentUserId, friendshipList);
          });
    }
  }

  Future<void> _loadFriendDetails(
    String currentUserId,
    List<FriendshipModel> friendshipList,
  ) async {
    try {
      _isLoading.value = true;

      List<UserModel> friendUsers = [];

      final futures = friendshipList.map((friendship) async {
        String friendId = friendship.getOtherUserId(currentUserId);
        return await _firestoreService.getUser(friendId);
      }).toList();

      final results = await Future.wait(futures);
      for (var friend in results) {
        if (friend != null) {
          friendUsers.add(friend);
        }
      }
      _friends.value = friendUsers;
      _filterFriends();
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void _filterFriends() {
    final query = _searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      _filteredFriends.assignAll(_friends);
    } else {
      final result = _friends.where((friend) {
        final name = friend.displayName.toLowerCase();
        final email = friend.email.toLowerCase();

        return name.contains(query) || email.contains(query);
      }).toList();

      _filteredFriends.assignAll(result);
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
    _filterFriends(); // not sure
  }

  void clearSearch() => _searchQuery.value = '';

  Future<void> refreshFriends() async {
    final currentUserId = _authController.user?.uid;
    if (currentUserId != null) {
      _loadFriends();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> removeFriend(UserModel friend) async {
    try {
      final bool? result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Remove Friend'),
          content: Text(
            'Are you sure you want to remove ${friend.displayName} from your friends?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Remove'),
            ),
          ],
        ),
      );

      if (result == true) {
        final currentUserId = _authController.user?.uid;
        if (currentUserId != null) {
          await _firestoreService.removeFriendship(currentUserId, friend.id);
          _friends.removeWhere((item) => item.id == friend.id);
          _filteredFriends.removeWhere((item) => item.id == friend.id);

          Get.snackbar(
            'Success',
            '${friend.displayName} has been removed from your friends.',
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
            duration: const Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove friend: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: Duration(seconds: 4),
        colorText: Colors.redAccent,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> blockFriend(UserModel friend) async {
    try {
      final bool? result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Block User'),
          content: Text(
            'Are you sure you want to block ${friend.displayName}? You will no longer be able to see their updates.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Block'),
            ),
          ],
        ),
      );

      if (result == null || !result) return;

      final currentUserId = _authController.user?.uid;
      if (currentUserId == null) return;

      _isLoading.value = true;

      await _firestoreService.blockUser(currentUserId, friend.id);

      _friends.removeWhere((item) => item.id == friend.id);
      _filteredFriends.removeWhere((item) => item.id == friend.id);
      Get.snackbar(
        'Success',
        '${friend.displayName} has been blocked.',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to block user',
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.redAccent,
        duration: const Duration(seconds: 4),
      );
      debugPrint('Error blocking user: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void startChat(UserModel friend) {
    try {
      final currentUserId = _authController.user?.uid;

      if (currentUserId != null) {
        Get.toNamed(
          AppRoutes.chat,
          arguments: {'chatId': null, 'otherUser': friend, 'isNewChat': true},
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open chat screen.',
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.redAccent,
      );
      debugPrint('Error navigating to chat: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  String getLastSeenText(UserModel user) {
    if (user.isOnline) {
      return 'Online';
    } else {
      final now = DateTime.now();
      final difference = now.difference(user.lastSeen);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return 'Last seen ${difference.inMinutes} m ago';
      } else if (difference.inDays < 1) {
        return 'Last seen ${difference.inHours} h ago';
      } else if (difference.inDays < 7) {
        return 'Last seen ${difference.inHours} d ago';
      } else {
        return 'Last seen ${user.lastSeen.day}/${user.lastSeen.month}/${user.lastSeen.year}';
      }
    }
  }

  //void openFriendRequests() => Get.toNamed(AppRoutes.friendsRequests);
  void openFriendRequests() {
    Get.put(FriendRequestsController());
    Get.to(() => const FriendRequestsScreen());
  }
  void _clearError() => _error.value = '';
}
