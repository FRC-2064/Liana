import 'package:control_board/widgets/bool_reader.dart';
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
      child: Row(
        children: [Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Coral Level'),
            // Coral Levels
            ButtonSender(
              ntTopic: ntTopics['Level']!,
              ntService: client,
              buttonText: 'Algae Remove',
              val: 0
            ),
            ButtonSender(
              ntTopic: ntTopics['Level']!,
              ntService: client,
              buttonText: 'Level 1',
              val: 1
            ),
            ButtonSender(
              ntTopic: ntTopics['Level']!,
              ntService: client,
              buttonText: 'Level 2',
              val: 2
            ),
            ButtonSender(
              ntTopic: ntTopics['Level']!,
              ntService: client,
              buttonText: 'Level 3',
              val: 3
            ),
            ButtonSender(
              ntTopic: ntTopics['Level']!,
              ntService: client,
              buttonText: 'Level 4',
              val: 4
            )
          ]
        ),
        Column(
          children: [
            Text('Reef Location'),
            // Reef Location
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'A',
              val: 'A'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'B',
              val: 'B'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'C',
              val: 'C'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'D',
              val: 'D'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'E',
              val: 'E'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'F',
              val: 'F'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'G',
              val: 'G'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'H',
              val: 'H'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'I',
              val: 'I'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'J',
              val: 'J'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'K',
              val: 'K'
            ),
            ButtonSender(
              ntTopic: ntTopics['ScoreLocation']!,
              ntService: client,
              buttonText: 'L',
              val: 'L'
            ),
          ],
        ),
        Column(
          children: [
            Text('Cage Location'),
            // Test button
            ButtonSender(
              ntTopic: ntTopics['Cage']!,
              ntService: client, 
              buttonText: 'Left Cage', 
              val: 'LEFT'
              ),
              ButtonSender(
              ntTopic: ntTopics['Cage']!,
              ntService: client, 
              buttonText: 'Center Cage', 
              val: 'CENTER'
              ),
              ButtonSender(
                ntTopic: ntTopics['Cage']!,
                ntService: client, 
                buttonText: 'Right Cage', 
                val: 'RIGHT'
              )
          ],
        )
        ]
      ),
    );
  }
}
