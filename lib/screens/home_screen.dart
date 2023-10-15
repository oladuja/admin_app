import 'package:admin_app/chat/chat_home_screen.dart';
import 'package:admin_app/utils/spacer.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/constants/colors.dart';
import 'package:admin_app/screens/speaker_join_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: purple,
                  child: const Text(
                    "Messages",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatHomeScreen(),
                          ),
                        )
                      }),
              const VerticalSpacer(15),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: purple,
                  child: const Text(
                    "Create a meeting",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SpeakerJoinScreen(isCreateMeeting: true),
                          ),
                        )
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
