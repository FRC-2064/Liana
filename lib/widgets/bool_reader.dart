
import 'package:control_board/services/nt_service.dart';
import 'package:flutter/material.dart';
import 'package:nt4/nt4.dart';

class BoolReader extends StatefulWidget {
  const BoolReader({
    super.key,
    required this.topic,
    required this.name,
    required this.client,
  });
  final NTService client;
  final NT4Topic topic;
  final String name;
  @override
  State<BoolReader> createState() => _BoolReaderState();

}

class _BoolReaderState extends State<BoolReader> {
  bool _value = false;
  NT4Subscription? _subscription;
  dynamic item = "";

  @override
  void initState() {
    super.initState();
    print("wack item ${widget.client.client.subscribeAndRetrieveData("Dashboard/ControlBoard/Robot/HasAlgae")}");
    _subscribeToTopic();
  }

    void _subscribeToTopic() {
      _subscription = widget.client.subscribeValue(widget.topic);
      _subscription?.stream().listen((data) {
        print(data);
        if (data is bool) {
          setState(() {
            _value = data;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(item),
          Text(widget.name),
          Container(
            height: 50,
            width: 50,
            color: _value ? Colors.green : Colors.red,
          )
        ],
      ),
    );
  }
}