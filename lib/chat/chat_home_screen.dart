import 'package:admin_app/widgets/user_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc('admin')
                    .collection('message-sent')
                    .snapshots(),
                builder: (context, snapshot) {
                  try {
                    List<String> messageIds = [];
                    for (var element in snapshot.data!.docs) {
                      messageIds.add(element.id);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text('Loading'));
                    }

                    if (snapshot.data == null) {
                      return Container();
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        'No messages yet',
                      ));
                    }

                    if (snapshot.connectionState == ConnectionState.active) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => UserItem(
                          id: messageIds[index],
                        ),
                        itemCount: messageIds.length,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  } catch (e) {
                    return const Center(
                      child: Center(child: Text('An Error has occurred')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
