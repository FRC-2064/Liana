import 'package:flutter/widgets.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/services/network_tables/nt_repository.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:provider/provider.dart';

typedef NtValueWidgetBuilder<T> =
    Widget Function(BuildContext context, NtValue<T> value, NtEntry<T> entry);

/// A [Widget] that listens to a specific Network Table topic
/// and rebuilds itself with the latest values.
class NtValueBuilder<T> extends StatelessWidget {
  final NtTopic<T> topic;
  final NtValueWidgetBuilder<T> builder;

  const NtValueBuilder({required this.topic, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    final entry = context.read<NtRepository>().entry(topic);
    return StreamBuilder<NtValue<T>>(
      key: ObjectKey(entry),
      stream: entry.values,
      initialData: entry.current,
      builder: (context, snapshot) {
        return builder(context, snapshot.data ?? entry.current, entry);
      },
    );
  }
}
