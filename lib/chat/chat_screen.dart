import 'package:admin_app/helper/cloud.dart';
import 'package:admin_app/models/msg.dart';
import 'package:admin_app/models/user.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'chat-screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
          // color: Colors.black,
        ),
        // backgroundColor: Colors.white,
        title: Text(
          user.name,
          style: const TextStyle(
            // color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.transparent,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: firebaseFirestore
                    .collection('chats')
                    .doc('admin')
                    .collection('message-sent')
                    .doc(user.id)
                    .collection('messages')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text('Loading messages'));
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No message'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.active) {
                      // logger.i(snapshot.data!.docs);
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        // reverse: true,
                        itemBuilder: (context, index) {
                          Message message = Message.fromJson(
                              snapshot.data!.docs[index].data());
                          return BubbleNormal(
                            bubbleRadius: 20,
                            tail: true,
                            isSender: (message.isSender == 'admin'),
                            color: (message.isSender == 'admin')
                                ? const Color(0XFFf3f3f3)
                                : const Color(0xffc420d2),
                            text: message.message,
                            textStyle: TextStyle(
                              color: (message.isSender == 'admin')
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
                    }
                    return const CircularProgressIndicator();
                  } catch (e) {
                    print(e);
                    return Container();
                  }
                },
              ),
            ),
             Align(
              alignment: Alignment.bottomCenter,
              child: SendMessage(user: user,),
            ),
          ],
        ),
      ),
    );
  }
}

class SendMessage extends StatefulWidget {
  final User user;
  const SendMessage({super.key, required this.user});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (_) {
          setState(() {
            controller.text += '\n';
          });
        },
        enabled: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          enabled: true,
          isDense: true,
          hintText: 'Type your message...',
          hintStyle: const TextStyle(
            // color: Colors.grey,
            fontSize: 14,
          ),
          suffixIcon: GestureDetector(
            onTap: () async {
              if (controller.text.trim().isNotEmpty) {
                FocusScope.of(context).unfocus();
                try {
                  await sendMessage(controller.text.trim(), widget.user.id);
                  controller.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                  print(e);
                }
              }
            },
            child: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: FaIcon(
                  FontAwesomeIcons.solidPaperPlane,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
