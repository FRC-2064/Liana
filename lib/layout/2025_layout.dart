import 'package:flutter/material.dart';
import 'package:control_board/services/nt_service.dart';
import 'package:control_board/widgets/button_sender.dart';
import 'package:nt4/nt4.dart';

class MainLayout extends StatelessWidget {
  final NTService client;
  final Map<String, NT4Topic> ntTopics;

  const MainLayout({super.key, required this.client, required this.ntTopics});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ntTopics.entries.map((entry) {
          return ButtonSender(
            ntTopic: entry.value,
            ntService: client,
            buttonText: entry.key,
            val: ntTopics.keys.toList().indexOf(entry.key),
          );
        }).toList(),
      ),
    );
  }
}
