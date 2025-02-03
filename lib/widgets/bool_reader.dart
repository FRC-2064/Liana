import 'package:flutter/material.dart';
import 'package:nt4/nt4.dart';

class BoolReader extends StatefulWidget {
  const BoolReader({
    super.key,
    required this.topic,
    required this.name
  });

  final NT4Topic topic;
  final String name;
  @override
  State<BoolReader> createState() => _BoolReaderState();

}

class _BoolReaderState extends State<BoolReader> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.name),
          Container(
            color: Colors.red,
          )
        ],
      ),
    );
  }
}