import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/models/chat_model.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Map<String, dynamic>? admin;
  final TextEditingController messageController = TextEditingController();
  getConversationId(String receiverId) =>
      FirebaseAuth.instance.currentUser!.uid.hashCode <= receiverId.hashCode
          ? '${FirebaseAuth.instance.currentUser!.uid}_$receiverId'
          : '${receiverId}_${FirebaseAuth.instance.currentUser!.uid}';
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('admin').get().then((value) {
      admin = value.docs.first.data();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: primaryColor,
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhHDkrsXcQg5G2k-2zXv91GX36h1v2GEGVVk5moI1aFO-03WqIpA0HRXrzklJmk2LMIBg&usqp=CAU'),
        ),
        title: Text('Admin Kokozaki'),
      ),
      body: Row(
        children: [
          if (admin != null)
            Expanded(
                child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(getConversationId(admin!['uid']))
                          .collection('messages')
                          .orderBy('time', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No Data Found'),
                            );
                          }
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                ChatModel chat = ChatModel.fromMap(
                                    snapshot.data!.docs[index].data());
                                bool isMe = chat.senderId ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? true
                                    : false;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 100),
                                  child: MessageBubble(
                                      sender: chat.name,
                                      text: chat.message,
                                      isMe: isMe),
                                );
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
                TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    suffixIcon: IconButton(
                        onPressed: () async {
                          String randomId = const Uuid().v4();
                          DocumentSnapshot<Map<String, dynamic>> snapshot =
                              await FirebaseFirestore.instance
                                  .collection('sellers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get();
                          final data = snapshot.data();
                          ChatModel chatModel = ChatModel(
                              id: randomId,
                              name: data!['marketName'],
                              message: messageController.text,
                              time: DateTime.now(),
                              avatarUrl: data['imageUrl'],
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              receiverId: admin!['uid']);

                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(getConversationId(admin!['uid']))
                              .collection('messages')
                              .doc(randomId)
                              .set(chatModel.toMap());
                          messageController.clear();
                        },
                        icon: const Icon(Icons.send)),
                  ),
                )
              ],
            )),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  const MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          children: [
            Text(
              sender,
              style: TextStyle(fontSize: 12),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isMe ? primaryColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  text,
                  style: TextStyle(color: isMe ? Colors.white : Colors.white),
                )),
          ],
        ));
  }
}
