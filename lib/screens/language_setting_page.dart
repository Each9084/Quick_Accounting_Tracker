import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import '../l10n/language_notifier.dart';

class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LanguageNotifier>().locale;

    return Scaffold(
      appBar: AppBar(
        title: const Text('语言设置'),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildLanguageOption(
            context,
            title: "简体中文",
            locale: const Locale('zh'),
            isSelected: currentLocale.languageCode == 'zh',
          ),
          const Divider(),
          _buildLanguageOption(
            context,
            title: "English",
            locale: const Locale('en'),
            isSelected: currentLocale.languageCode == 'en',
          ),

        ],
      ),

    );
  }

  Widget _buildLanguageOption(BuildContext context,
      {required String title, required Locale locale, required bool isSelected}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.indigo)
          : null,
      onTap: () {
        context.read<LanguageNotifier>().setLocale(locale);
        //重启整个 App 使语言切换生效
        Phoenix.rebirth(context);
      },
    );
  }
}
