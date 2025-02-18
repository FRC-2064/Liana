import 'package:flutter/material.dart';

class BoolIndicator extends StatefulWidget {
  const BoolIndicator(
      {super.key, required this.name, required this.boolListenable});
  final String name;
  final Stream<bool> boolListenable;
  @override
  State<BoolIndicator> createState() => _BoolIndicatorState();
}

class _BoolIndicatorState extends State<BoolIndicator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.boolListenable,
      builder: (context, snapshot) => Card(
        child: Column(
          children: [
            Text(widget.name),
            Container(
              height: 50,
              width: 50,
              color: switch (snapshot.data) {
                true => Colors.green,
                false => Colors.red,
                null => Colors.grey,
              },
            ),
          ],
        ),
      ),
    );
  }
}
