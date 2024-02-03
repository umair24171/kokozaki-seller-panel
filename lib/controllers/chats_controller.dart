// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kokozaki_seller_panel/helper/firebase_features.dart';
// import 'package:kokozaki_seller_panel/models/chat_model.dart';

// class ChatsController extends GetxController {
//   Rx<List<ChatModel>> chats = Rx<List<ChatModel>>([]);
//   Rx<List<ChatModel>> chatMessages = Rx<List<ChatModel>>([]);

//   getConversationId(String receiverId) =>
//       currentUser.hashCode <= receiverId.hashCode
//           ? '${currentUser}_$receiverId'
//           : '${receiverId}_${currentUser}';

//   Future<void> getChats(String receiverId) async {
//     try {
//       var value = await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(getConversationId(receiverId))
//           .collection('messages')
//           .orderBy('time', descending: true)
//           .get();

//       if (value.docs.isNotEmpty) {
//         chats.value =
//             value.docs.map((e) => ChatModel.fromMap(e.data())).toList();
//         update(); // Notify listeners
//       } else {
//         chats.value = [];
//       }
//     } catch (e) {
//       print("Error fetching chats: $e");
//       chats.value = [];
//     }
//   }

//   // Future<void> getChatMessages(String chatId) async {
//   //   try {
//   //     var value = await FirebaseFirestore.instance
//   //         .collection('chats')
//   //         .doc(currentUser)
//   //         .collection('chatList')
//   //         .doc(chatId)
//   //         .collection('messages')
//   //         .get();

//   //     if (value.docs.isNotEmpty) {
//   //       chatMessages.value =
//   //           value.docs.map((e) => ChatModel.fromMap(e.data()!)).toList();
//   //       update(); // Notify listeners
//   //     } else {
//   //       chatMessages.value = [];
//   //     }
//   //   } catch (e) {
//   //     print("Error fetching chat messages: $e");
//   //     chatMessages.value = [];
//   //   }
//   // }
// }
