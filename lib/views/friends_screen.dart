import 'package:chat_app/views/widgets/friend_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/friend_controller.dart';
import '../theme/app_theme.dart';

class FriendsScreen extends GetView<FriendsController> {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: controller.openFriendRequests,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.borderColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search Friends',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() {
                  return controller.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.clearSearch();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        )
                      : const SizedBox.shrink();
                }),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppTheme.cardColor,
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshFriends,
              child: Obx(() {
                if (controller.isLoading && controller.friends.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredFriends.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredFriends.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    final friend = controller.filteredFriends[index];
                    return FriendListItem(
                      friend: friend,
                      lastSeenText: controller.getLastSeenText(friend),
                      onTap: () => controller.startChat(friend),
                      onRemove: () => controller.removeFriend(friend),
                      onBlock: () => controller.blockFriend(friend),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.people_outline,
                size: 50,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              controller.searchQuery.isNotEmpty
                  ? 'No friend found'
                  : 'No friends yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.searchQuery.isNotEmpty
                  ? 'Try a different search term'
                  : 'Add friends to start chatting',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor),
              textAlign: TextAlign.center,
            ),
            if (controller.searchQuery.isEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: controller.openFriendRequests,
                icon: const Icon(Icons.person_add),
                label: const Text('View Friend Requests'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// class FriendsScreen extends GetView<FriendsController> {
//   const FriendsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Friends'),
//         leading: SizedBox(),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.person_add_alt_1),
//             onPressed: controller.openFriendRequests,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Theme.of(context).scaffoldBackgroundColor,
//               border: Border(
//                 bottom: BorderSide(
//                   color: AppTheme.borderColor.withValues(alpha: 0.5),
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: TextField(
//               onChanged: controller.updateSearchQuery,
//               decoration: InputDecoration(
//                 hintText: 'Search Friends',
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: Obx(() {
//                   return controller.searchQuery.isNotEmpty
//                       ? IconButton(
//                     icon: const Icon(Icons.clear),
//                     onPressed: () {
//                       controller.clearSearch();
//                       FocusManager.instance.primaryFocus?.unfocus();
//                     },
//                   )
//                       : const SizedBox.shrink();
//                 }),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: AppTheme.borderColor)
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: AppTheme.borderColor)
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: AppTheme.primaryColor, width: 2)
//                 ),
//                 filled: true,
//                 fillColor: AppTheme.cardColor,
//               ),
//             ),
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: controller.refreshFriends,
//               child: Obx(() {
//                 if (controller.isLoading && controller.friends.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (controller.filteredFriends.isEmpty) {
//                   return _buildEmptyState();
//                 }
//
//                 return ListView.separated(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: controller.filteredFriends.length,
//                   separatorBuilder: (context, index) {
//                     return const SizedBox(height: 8);
//                   },
//                   itemBuilder: (context, index) {
//                     final friend = controller.filteredFriends[index];
//                     return FriendListItem(
//                       friend: friend,
//                       lastSeenText: controller.getLastSeenText(friend),
//                       onTap: () => controller.startChat(friend),
//                       onRemove: () => controller.removeFriend(friend),
//                       onBlock: () => controller.blockFriend(friend),
//                     );
//                   },
//                 );
//               }),
//             ),
//           )
//
//         ],
//       ),
//     );
//   }
//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: AppTheme.primaryColor.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: Icon(
//                 Icons.people_outline,
//                 size: 50,
//                 color: AppTheme.primaryColor,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               controller.searchQuery.isNotEmpty
//                   ? 'No friend found'
//                   : 'No friends yet',
//               style: Theme.of(Get.context!).textTheme.headlineMedium?.copyWith(
//                 color: AppTheme.textPrimaryColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               controller.searchQuery.isNotEmpty
//                   ? 'Try a different search term'
//                   : 'Add friends to start chatting',
//               style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
//                 color: AppTheme.secondaryColor,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             if(controller.searchQuery.isEmpty)...[
//               SizedBox(height: 16),
//               ElevatedButton.icon(
//                 onPressed: controller.openFriendRequests,
//                   label: Text('View Friend Requests'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppTheme.primaryColor,
//                 foregroundColor: Colors.white
//               ),
//               )
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
