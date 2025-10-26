import 'package:liana/widgets/network_tables/button_builders/hexagon_builder.dart';
import 'package:liana/widgets/network_tables/nt_status_button.dart';
import 'package:flutter/material.dart';

class Test2026Layout extends StatefulWidget {
  const Test2026Layout({super.key});
  @override
  State<Test2026Layout> createState() => _Test2026LayoutState();
}

class _Test2026LayoutState extends State<Test2026Layout> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NtStatusButton<int>(
          topicName: "Robot/Location",
          defaultValue: 0,
          text: "Location 1",
          valueToSet: 1,
        ),
        const SizedBox(width: 30),
        NtStatusButton<int>(
          topicName: "Robot/Location",
          defaultValue: 0,
          text: "Location 2",
          valueToSet: 2,
        ),
        const SizedBox(width: 30),
        NtStatusButton<String>(
          topicName: "Robot/Name",
          defaultValue: "",
          text: "NA",
          valueToSet: "NA",
        ),
        const SizedBox(width: 30),
        NtStatusButton<String>(
          topicName: "Robot/Name",
          defaultValue: "",
          text: "NB",
          valueToSet: "NB",
        ),
        const SizedBox(width: 30),
        NtStatusButton<String>(
          topicName: "Robot/Type",
          defaultValue: "",
          text: "NC",
          valueToSet: "NC",
          height: 200,
          width: 200,
          builder: HexagonBuilder(),
        ),
      ],
    );
  }
}
