/// 当有多条待同步活动时使用的底部选择面板。
import 'package:flutter/material.dart';
import 'package:shoecloud/shared/utils/time_formatter.dart';

class ActivitySelectionSheet extends StatefulWidget {
  const ActivitySelectionSheet({
    super.key,
    required this.activities,
    required this.onSync,
  });

  final List activities;
  final Future<void> Function(String fileName) onSync;

  @override
  State<ActivitySelectionSheet> createState() => _ActivitySelectionSheetState();
}

class _ActivitySelectionSheetState extends State<ActivitySelectionSheet> {
  late final List _localActivities = List.of(widget.activities);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '待同步活动',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            '右滑同步，左滑忽略。',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _localActivities.isEmpty
                ? const Center(child: Text('没有更多待同步活动'))
                : ListView.builder(
                    itemCount: _localActivities.length,
                    itemBuilder: (context, index) {
                      final item =
                          _localActivities[index] as Map<String, dynamic>;
                      final distanceMeters =
                          (item['distance_m'] as num?)?.toDouble() ?? 0;
                      final durationSeconds =
                          (item['duration_s'] as num?)?.toDouble() ?? 0;

                      return Dismissible(
                        key: Key(item['file_name'].toString()),
                        background: _bg(
                          Colors.green,
                          Icons.sync,
                          Alignment.centerLeft,
                        ),
                        secondaryBackground: _bg(
                          Colors.red,
                          Icons.delete_sweep,
                          Alignment.centerRight,
                        ),
                        onDismissed: (direction) async {
                          final fileName = item['file_name'].toString();
                          setState(() => _localActivities.removeAt(index));
                          if (direction == DismissDirection.startToEnd) {
                            await widget.onSync(fileName);
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              '${item['start_time'].toString().split('T').first} 跑步记录',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Wrap(
                                spacing: 12,
                                children: [
                                  Text(
                                    '${(distanceMeters / 1000).toStringAsFixed(2)} km',
                                  ),
                                  Text(
                                    TimeFormatter.formatPace(
                                      distanceKm: distanceMeters / 1000,
                                      seconds: durationSeconds,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _bg(Color color, IconData icon, Alignment alignment) {
    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
