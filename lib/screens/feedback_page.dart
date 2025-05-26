import 'package:accounting_tracker/l10n/Strings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  Future<void> _openGitHubIssues(BuildContext context) async {
    final url = Uri.parse('https://github.com/Each9084/Quick_Accounting_Tracker/issues');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(StringsMain.get("cant_open_github"))),
      );
    }
  }


  Future<void> _sendEmail(BuildContext context) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'each9084@gmail.com',
      query: 'subject=Quick Accounting Tracker 反馈&body=请输入您的反馈内容：',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(StringsMain.get("cant_open_emailApp"))),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title:  Text(StringsMain.get("feedback_advice")),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                     Text(
                       StringsMain.get("welcome_report"),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/img/weChat_QRCode.jpg',
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.bug_report_outlined, color: Colors.deepOrange),
              title:  Text(StringsMain.get("submit_issue")),
              subtitle:  Text(StringsMain.get("click_into_issueBlock_report")),
              onTap: () => _openGitHubIssues(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.indigo.shade50,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: Colors.teal),
              title:  Text(StringsMain.get("send_email")),
              subtitle: const Text("each9084@gmail.com"),
              onTap: () => _sendEmail(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.indigo.shade50,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.video_collection_outlined, color: Colors.pinkAccent),
              title:  Text(StringsMain.get("message_by_bilibili")),
              subtitle:  Text(StringsMain.get("click_to_space")),
              onTap: () async {
                final url = Uri.parse('https://space.bilibili.com/34878493?spm_id_from=333.337.0.0');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(StringsMain.get("cant_open_bilibili"))),
                  );
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.indigo.shade50,
            ),

          ],
        ),
      ),
    );
  }
}
