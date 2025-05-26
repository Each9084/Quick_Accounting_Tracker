import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:accounting_tracker/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import '../data/db/app_database.dart';
import '../service/user_service.dart';
import '../utils/cache_util.dart';
import 'bill_home_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeNotifier = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title:  Text(StringsMain.get("setting")),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title:  Text(StringsMain.get("language_setting"), style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.teal),
            title:  Text(StringsMain.get("about_app"), style: TextStyle(fontSize: 16)),
            subtitle:  Text(StringsMain.get("app_version")),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
            title:  Text(StringsMain.get("clear_cache")),
            subtitle:  Text(StringsMain.get("clear_data_init_explain")),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title:  Text(StringsMain.get("clear_data_init_title")),
                  content:  Text(StringsMain.get("clear_data_init_text")),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child:  Text(StringsMain.get("cancel")),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      child:  Text(StringsMain.get("confirm_clear")),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AppDatabase.deleteDatabaseFile();
                await UserService.ensureLocalUserExists();
                Phoenix.rebirth(context); // 重启 App
              }
            },
          ),
        ],
      ),
    );
  }
}
