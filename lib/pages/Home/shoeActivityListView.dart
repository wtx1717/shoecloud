import 'package:flutter/material.dart';
import 'package:shoecloud/api/syncActivity.dart';
import 'package:shoecloud/viewmodels/shoeActivity.dart';
import 'package:shoecloud/viewmodels/shoeInfo.dart';

class shoeActivityListView extends StatefulWidget {
  const shoeActivityListView({super.key});

  @override
  State<shoeActivityListView> createState() => _shoeActivityListViewState();
}

class _shoeActivityListViewState extends State<shoeActivityListView> {
  late ShoeInfo shoeInfo;
  bool _isInitialized = false;
  List<ShoeActivity> activityList = [];
  bool isLoading = true;
  bool isEditMode = false; // 控制是否开启编辑模式

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['shoeInfo'] is ShoeInfo) {
        shoeInfo = args['shoeInfo'];
        _loadData();
      }
      _isInitialized = true;
    }
  }

  Future<void> _loadData() async {
    try {
      final data = await getShoeActivitiesAPI(shoeInfo.activitiesLink);
      setState(() {
        activityList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("加载活动列表失败: $e");
    }
  }

  /// 风格统一的消息提示
  void _showStyledSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF2E7D32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // 执行删除逻辑 (将文件移至待同步)
  Future<void> _handleDeleteActivity(ShoeActivity activity) async {
    setState(() => isLoading = true);

    try {
      final bool success = await deleteSyncedActivityAPI(
        userId: "user_example",
        shoeId: shoeInfo.shoeId,
        activityId: activity.activityId,
      );

      if (success) {
        setState(() {
          activityList.removeWhere(
            (item) => item.activityId == activity.activityId,
          );
        });
        _showStyledSnackBar("已撤销同步，活动已移回待同步文件夹");
      } else {
        _showStyledSnackBar("删除失败，请稍后重试", isError: true);
      }
    } catch (e) {
      _showStyledSnackBar("删除过程中出错: $e", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _formatDuration(double seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = (seconds % 60).round();
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  String _calculatePace(double distance, double seconds) {
    if (distance <= 0) return "0'00\"";
    double paceMinPerKm = (seconds / 60) / distance;
    int minutes = paceMinPerKm.floor();
    int secs = ((paceMinPerKm - minutes) * 60).round();
    return "$minutes'${secs.toString().padLeft(2, '0')}\"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: Text(
          "${shoeInfo.nickname} 的活动",
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
        actions: [
          IconButton(
            icon: Icon(
              isEditMode ? Icons.check_circle : Icons.edit_note,
              size: 28,
            ),
            onPressed: () => setState(() => isEditMode = !isEditMode),
            tooltip: isEditMode ? "完成" : "编辑活动",
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            )
          : activityList.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadData,
              color: const Color(0xFF2E7D32),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activityList.length,
                itemBuilder: (context, index) {
                  final activity = activityList[index];
                  return isEditMode
                      ? _buildDismissibleItem(activity)
                      : _buildActivityItem(activity);
                },
              ),
            ),
    );
  }

  // 构建可滑动的删除组件
  Widget _buildDismissibleItem(ShoeActivity activity) {
    return Dismissible(
      key: Key(activity.activityId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // 使用你指定的弹窗风格进行确认
        return await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: const Color(0xFFE8F5E9),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 顶部图标装饰
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF9C4), // 淡黄圆底
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.history, // 撤销含义的图标
                      size: 40,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "撤销同步？",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "该活动将从云端移除并移至待同步列表，跑鞋里程将自动扣除。",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2E7D32)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            "再想想",
                            style: TextStyle(color: Color(0xFF2E7D32)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("确 定"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onDismissed: (direction) => _handleDeleteActivity(activity),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_sweep, color: Colors.white, size: 28),
      ),
      child: Stack(
        children: [
          _buildActivityItem(activity),
          Positioned(
            right: 10,
            top: 10,
            child: Icon(
              Icons.remove_circle,
              color: Colors.red.withOpacity(0.8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_run_outlined,
            size: 60,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text("暂无运动记录", style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ShoeActivity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_run_rounded,
              color: Color(0xFF2E7D32),
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.startTime.replaceFirst('T', ' ').substring(0, 16),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "配速 ${_calculatePace(activity.distanceKm, activity.durationS)} · 时长 ${_formatDuration(activity.durationS)}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            activity.distanceKm.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(width: 4),
          const Text("km", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
