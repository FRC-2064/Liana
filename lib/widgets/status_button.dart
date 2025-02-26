import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  const StatusButton({
    required this.name,
    required this.setFunction,
    required this.listenable,
    required this.setVal,
    super.key});

  final String name;
  final VoidCallback setFunction;
  final Stream listenable;
  final dynamic setVal;
  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: widget.listenable,
        builder: (context, snapshot) {
          bool isSelected = snapshot.data == widget.setVal;
          return Card(
            color: switch (snapshot.data) {
              null => Colors.grey,
              _ => isSelected ? Colors.green : Colors.red,
            },
            child: TextButton(
                onPressed: widget.setFunction,
                child: Text(widget.name)),
          );
        });
  }
}
