import 'package:control_board/services/nt_service.dart';
import 'package:flutter/material.dart';
import 'package:nt4/nt4.dart';

class ButtonSender extends StatefulWidget {
  const ButtonSender({
    super.key,
    required this.ntTopic,
    required this.ntService,
    required this.buttonText,
    required this.val
    });
  
  final NT4Topic ntTopic;
  final NTService ntService;
  final String buttonText;
  final int val;


  @override
  State<ButtonSender> createState() => _ButtonSenderState();
}

class _ButtonSenderState extends State<ButtonSender> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.ntService.postValue(widget.ntTopic, widget.val);
        }, 
        child: Text(widget.buttonText));
  }
}