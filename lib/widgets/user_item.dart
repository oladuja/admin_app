import 'dart:async';
import 'dart:math';

import 'package:admin_app/chat/chat_screen.dart';
import 'package:admin_app/helper/cloud.dart';
import 'package:admin_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  UserItem({
    super.key,
    required this.id,
  });
  final String id;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(id),
      builder: (_, snapshot) {
        try {
          User user = User.fromJson(snapshot.data!.data()!);
          // logger.i(snapshot.data!.data()!);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.data == null) {
            return Container();
          }
          return FutureBuilder(
            future: getlastMessage(id),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              }

              if (snapshot.hasError) {
                return const Center(child: Text('An error has occured'),);
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text('Loading'));
              }

              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const ChatScreen(),
                      settings: RouteSettings(arguments: user)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0XFFC420D2),
                                Color(0XFF0A84FF),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        snapshot.data!.data()!['message'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      trailing: Column(
                        children: [
                          LastMessageTime(
                              time:
                                  snapshot.data!.data()!['timeOfLastMessage']),
                          // const Spacer(),
                          // CircleAvatar(
                          //   radius: 12,
                          //   backgroundColor:
                          //       const Color.fromARGB(255, 211, 59, 206)
                          //           .withOpacity(0.96),
                          //   child: Text(
                          //     Random().nextInt(3).toString(),
                          //     style: const TextStyle(color: Colors.white),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white, thickness: 1.2),
                  ],
                ),
              );
            },
          );
        } catch (e) {
          return Container();
        }
      },
    );
  }
}

class LastMessageTime extends StatefulWidget {
  const LastMessageTime({
    super.key,
    required this.time,
  });

  final Timestamp time;

  @override
  State<LastMessageTime> createState() => _LastMessageTimeState();
}

class _LastMessageTimeState extends State<LastMessageTime> {
  @override
  Widget build(BuildContext context) {
    var time = timeago.format(
      DateTime.fromMicrosecondsSinceEpoch(widget.time.microsecondsSinceEpoch),
      locale: 'en_short',
    );
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
    return Text(
      time + ((time == 'now') ? '' : ' ago'),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
