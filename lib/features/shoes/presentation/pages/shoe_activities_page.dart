/// 展示单鞋活动列表，并支持撤销同步。
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecloud/features/activities/models/shoe_activity.dart';
import 'package:shoecloud/features/session/presentation/controllers/app_session_controller.dart';
import 'package:shoecloud/features/shoes/data/shoe_repository.dart';
import 'package:shoecloud/features/shoes/models/shoe.dart';
import 'package:shoecloud/shared/utils/time_formatter.dart';
import 'package:shoecloud/shared/widgets/app_feedback.dart';

class ShoeActivitiesPage extends StatefulWidget {
  const ShoeActivitiesPage({super.key});

  @override
  State<ShoeActivitiesPage> createState() => _ShoeActivitiesPageState();
}

class _ShoeActivitiesPageState extends State<ShoeActivitiesPage> {
  final _repository = Get.find<ShoeRepository>();
  final _session = Get.find<AppSessionController>();
  late final Shoe _shoe;
  bool _editing = false;
  bool _loading = true;
  List<ShoeActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    _shoe = args['shoe'] as Shoe;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _repository.fetchActivities(_shoe.activitiesLink);
    if (!mounted) {
      return;
    }
    setState(() {
      _activities = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_shoe.nickname} 的活动'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _editing = !_editing),
            icon: Icon(_editing ? Icons.check_circle : Icons.edit_note),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _activities.isEmpty
          ? const Center(child: Text('暂无活动记录'))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return _editing
                      ? Dismissible(
                          key: Key(activity.activityId),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => _deleteActivity(activity),
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: _ActivityCard(activity: activity),
                        )
                      : _ActivityCard(activity: activity);
                },
              ),
            ),
    );
  }

  Future<bool> _deleteActivity(ShoeActivity activity) async {
    final success = await _repository.deleteSyncedActivity(
      userId: _session.userId,
      shoeId: _shoe.shoeId,
      activityId: activity.activityId,
    );
    if (!mounted) {
      return false;
    }
    if (success) {
      setState(() {
        _activities = _activities
            .where((item) => item.activityId != activity.activityId)
            .toList();
      });
      AppFeedback.showSuccess(context, '已撤销同步');
      return true;
    }

    AppFeedback.showError(context, '撤销失败');
    return false;
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});

  final ShoeActivity activity;

  @override
  Widget build(BuildContext context) {
    final displayTime = activity.startTime.length >= 16
        ? activity.startTime.replaceFirst('T', ' ').substring(0, 16)
        : activity.startTime.replaceFirst('T', ' ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_run, color: Color(0xFF2E7D32)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTime,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '配速 ${TimeFormatter.formatPace(distanceKm: activity.distanceKm, seconds: activity.durationSeconds)} · 时长 ${TimeFormatter.formatActivityDuration(activity.durationSeconds)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            activity.distanceKm.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(width: 4),
          const Text('km'),
        ],
      ),
    );
  }
}
