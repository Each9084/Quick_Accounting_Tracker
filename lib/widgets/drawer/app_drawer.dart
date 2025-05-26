import 'dart:math';
import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/feedback_page.dart';
import '../../screens/version_timeline_page.dart';
import '../../theme/theme_notifier.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _staggeredController;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _staggeredController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // 启动交错动画
    _staggeredController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _staggeredController.dispose();
    super.dispose();
  }

  // 抽取动画 Widget
  Widget _buildAnimatedTile({required Widget child, required int index}) {
    //交错间隔速度
    final intervalStart = index * 0.15;

    final intervalEnd = (intervalStart + 0.4).clamp(0.0, 1.0); //加了 clamp 限制 防止超过1
    final animation = CurvedAnimation(
      parent: _staggeredController,
      //子动画的时机
      curve:
          Interval(intervalStart, intervalEnd, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.indigo.shade900,
        child: Column(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _WaveInDrawerPainter(_waveController.value),
                        size: Size(double.infinity, double.infinity),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 75,
                    left: 16,
                    child: _buildAnimatedTile(
                      index: 0,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.indigo),
                          ),
                          const SizedBox(width: 12),
                           Text(
                            StringsMain.get("user_info"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildAnimatedTile(
              index: 1,
              child: ListTile(
                leading: const Icon(Icons.book_outlined, color: Colors.white),
                title:  Text(StringsMain.get("ledger"), style: TextStyle(color: Colors.white)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('not implement yet'),
                      backgroundColor: Colors.orangeAccent,
                    ),
                  );
                },
              ),
            ),

            _buildAnimatedTile(
              index: 2,
              child: ListTile(
                leading:
                    const Icon(Icons.category_outlined, color: Colors.white),
                title:
                     Text(StringsMain.get("category_management"), style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/category');
                },
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              thickness: 1.5,
            ),

// 新增：夜间模式切换
            _buildAnimatedTile(
              index: 3,
              child: Consumer<ThemeNotifier>(
                builder: (context, themeNotifier, _) {
                  final isDark = themeNotifier.themeMode == ThemeMode.dark;
                  return SwitchListTile(
                    title:  Text(StringsMain.get("night_mode"), style: TextStyle(color: Colors.white)),
                    secondary: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: isDark?Colors.grey:Colors.orangeAccent, // 图标颜色也改为橙色
                    ),
                    activeColor: Colors.orangeAccent,        // 打开时按钮颜色
                    activeTrackColor: Colors.orange.shade100, // 打开时轨道颜色
                    inactiveThumbColor: Colors.grey.shade400, // 关闭时按钮颜色
                    inactiveTrackColor: Colors.grey.shade600, // 关闭时轨道颜色
                    value: isDark,
                    onChanged: (_) {
                      themeNotifier.toggleTheme(); // 切换主题
                    },
                  );
                },
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              thickness: 1.5,
            ),

            _buildAnimatedTile(
              index: 4,
              child: ListTile(
                leading: const Icon(Icons.feedback_outlined, color: Colors.white),
                title:  Text(StringsMain.get("feedback_advice"), style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // 关闭 Drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackPage()),
                  );
                },
              ),
            ),
            _buildAnimatedTile(
              index: 5,
              child: ListTile(
                leading: const Icon(Icons.timeline_outlined, color: Colors.white),
                title:  Text(StringsMain.get("version_update"), style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VersionTimelinePage()),
                  );
                },
              ),
            ),

            _buildAnimatedTile(
              index: 6,
              child: ListTile(
                leading: const Icon(Icons.settings_outlined, color: Colors.white),
                title:  Text(StringsMain.get("setting"), style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),




          ],
        ),
      ),
    );
  }
}

// 波浪背景
class _WaveInDrawerPainter extends CustomPainter {
  final double progress;

  _WaveInDrawerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final waveHeight = 15.0;
    final waveLength = size.width;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blueAccent, Colors.yellowAccent, Colors.purpleAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fullCycleOffset = progress * 2 * pi;

    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final normalizedX = x / waveLength * 2 * pi;
      final y =
          waveHeight * sin(normalizedX + fullCycleOffset) + size.height - 30;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveInDrawerPainter oldDelegate) => true;
}
