import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:flutter/material.dart';

class VersionTimelinePage extends StatelessWidget {
  final List<VersionLog> versionLogs = [
    VersionLog(version: "开始", date: "2024-07-23", content: "• 概念提出与设计雏形"),
    VersionLog(version: "v0.1.0", date: "2024-08-21", content: "• 首次发布：基本账单功能、满足基本数据库、创建了一个 Bill 表。"),
    VersionLog(version: "v0.1.1", date: "2024-08-26", content: "• 测试\n• 第一阶段结束"),
    VersionLog(version: "v0.2.1", date: "2025-05-10", content: "• 重拾项目\n• 重构所有逻辑"),
    VersionLog(version: "v0.2.1", date: "2025-05-14", content: "• 完成数据库重构，增至三张表\n• 数据库测试版本"),
    VersionLog(version: "v0.2.2", date: "2025-05-16", content: "• 重构 UI，增加视觉效果"),
    VersionLog(version: "v0.2.3", date: "2025-05-20", content: "• 发布自定义键盘版本，符合操作逻辑\n• 解耦\n• 引入 IOC 依赖注入"),
    VersionLog(version: "v0.2.4", date: "2025-05-25", content: "• 引入国际化\n• 优化缓存，节省性能"),
    VersionLog(version: "v0.2.4", date: "2025-06-05", content: "• 修复数据库插入bug\n• 优化黑夜模式场景下颜色显示问题\n• 加入app图标 app名称可随中英文切换"),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(StringsMain.get("version_update")),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        itemCount: versionLogs.length,
        reverse: true,
        itemBuilder: (context, index) {
          final log = versionLogs[index];
          final isLeft = index % 2 == 0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLeft) _buildTimeLineIndicator(context, index),
              Expanded(
                child: Align(
                  alignment:
                  isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.indigo.shade800
                          : Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(log.version,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        if (log.date.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(log.date,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ),
                        const SizedBox(height: 8),
                        Text(log.content),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLeft) _buildTimeLineIndicator(context, index),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeLineIndicator(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8),
      child: Column(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              shape: BoxShape.circle,
            ),
          ),
          if (index != versionLogs.length - 1)
            Container(
              width: 2,
              height: 50,
              color: Colors.grey.shade400,
            ),
        ],
      ),
    );
  }
}

class VersionLog {
  final String version;
  final String date;
  final String content;

  VersionLog({
    required this.version,
    required this.date,
    required this.content,
  });
}
