import 'package:chat_app/controllers/friend_request_controller.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:chat_app/views/widgets/friend_request_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendRequestsScreen extends GetView<FriendRequestsController> {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          //tab selector
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Obx( () => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.selectedTabIndex == 0
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              color: controller.selectedTabIndex == 0
                                  ? Colors.white
                                  : AppTheme.textSecondaryColor,
                            ),
                            SizedBox(width:8),
                            Text(
                              'Received (${controller.receivedRequests.length})',
                              style: TextStyle(
                                color: controller.selectedTabIndex == 0
                                    ? Colors.white
                                    : AppTheme.textSecondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(1 ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: controller.selectedTabIndex == 1
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send,
                              color: controller.selectedTabIndex == 1
                                  ? Colors.white
                                  : AppTheme.textSecondaryColor,
                            ),
                            SizedBox(width:8),
                            Text(
                              'Sent (${controller.sentRequests.length})',
                              style: TextStyle(
                                color: controller.selectedTabIndex == 1
                                    ? Colors.white
                                    : AppTheme.textSecondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx ((){
              return IndexedStack(
                index: controller.selectedTabIndex,
                children: [
                  _buildReceivedRequestsTab(),
                  _buildSentRequestsTab(),

                ],
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildReceivedRequestsTab() {
    return Obx(() {
      if (controller.receivedRequests.isEmpty) {
        return _buildEmptyState(
          icon: Icons.inbox_outlined,
          title: 'No Friend Requests',
          message:
          'When someone sends you a friend request, it will appear here.',
        );
      }

      return ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: controller.receivedRequests.length,
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          final request = controller.receivedRequests[index];
          final sender = controller.getUser(request.senderId);
          if(sender == null) return SizedBox.shrink();
          return FriendRequestItem(
            request: request,
            user: sender,
            timeText: controller.getRequestTimeText(request.createdAt),
            isReceived: true,
            onAccept: () => controller.acceptFriendRequest(request),
            onDecline: () => controller.declineFriendRequest(request),
          );
        },
      );
    });
  }

  Widget _buildSentRequestsTab() {
    return Obx(() {
      if (controller.receivedRequests.isEmpty) {
        return _buildEmptyState(
          icon: Icons.inbox_outlined,
          title: 'No sent Requests',
          message:
          'Friend requests you send will appear here.',
        );
      }
      return ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: controller.sentRequests.length,
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          final request = controller.sentRequests[index];
          final receiver = controller.getUser(request.senderId);
          if(receiver == null) return SizedBox.shrink();
          return FriendRequestItem(
            request: request,
            user: receiver,
            timeText: controller.getRequestTimeText(request.createdAt),
            isReceived: false,
            statusText: controller.getStatusText(request.status),
            statusColor: controller.getStatusColor(request.status),
          );
        },
      );
    });
  }


  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}
