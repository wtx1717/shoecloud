import 'package:flutter/material.dart';

class ActivitySelectionSheet extends StatefulWidget {
  final List activities;
  final Function(String fileName) onSync; // 右滑同步的回调

  const ActivitySelectionSheet({
    super.key,
    required this.activities,
    required this.onSync,
  });

  @override
  State<ActivitySelectionSheet> createState() => _ActivitySelectionSheetState();
}

class _ActivitySelectionSheetState extends State<ActivitySelectionSheet> {
  late List _localList;

  @override
  void initState() {
    super.initState();
    _localList = List.from(widget.activities);
  }

  String _formatPace(double distanceM, double durationS) {
    if (distanceM == 0) return "0'00\"";
    double km = distanceM / 1000;
    double minutesPerKm = (durationS / 60) / km;
    int mins = minutesPerKm.floor();
    int secs = ((minutesPerKm - mins) * 60).round();
    return "$mins'${secs.toString().padLeft(2, '0')}\"";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "待同步活动 (右滑同步 / 左滑忽略)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _localList.isEmpty
                ? const Center(child: Text("没有更多活动了"))
                : ListView.builder(
                    itemCount: _localList.length,
                    itemBuilder: (context, index) {
                      final item = _localList[index];
                      return Dismissible(
                        key: Key(item['file_name']),
                        // 左滑（忽略）背景：红色
                        secondaryBackground: _buildDismissBackground(
                          Icons.delete_sweep,
                          Colors.red,
                          Alignment.centerRight,
                        ),
                        // 右滑（同步）背景：绿色
                        background: _buildDismissBackground(
                          Icons.sync,
                          Colors.green,
                          Alignment.centerLeft,
                        ),
                        onDismissed: (direction) {
                          String fileName = item['file_name'];
                          setState(() => _localList.removeAt(index));

                          if (direction == DismissDirection.startToEnd) {
                            widget.onSync(fileName); // 触发同步逻辑
                          }
                        },
                        child: _buildActivityCard(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBackground(
    IconData icon,
    Color color,
    Alignment alignment,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildActivityCard(Map item) {
    double distKm = item['distance_m'] / 1000;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(
          item['start_time'].split('T')[0] + " 跑步记录",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            _dataItem(Icons.straighten, "${distKm.toStringAsFixed(2)} km"),
            const SizedBox(width: 15),
            _dataItem(
              Icons.speed,
              _formatPace(item['distance_m'], item['duration_s']),
            ),
          ],
        ),
        trailing: const Icon(Icons.swipe_right, color: Colors.grey, size: 20),
      ),
    );
  }

  Widget _dataItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
