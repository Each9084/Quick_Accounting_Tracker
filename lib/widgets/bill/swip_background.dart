import 'package:flutter/material.dart';
import 'package:accounting_tracker/l10n/Strings.dart';

class SwipeBackground extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Alignment alignment;

  const SwipeBackground({
    super.key,
    this.icon = Icons.delete_outline,
    this.color = Colors.redAccent,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(width: 8),
          Text(
            StringsMain.get("delete"),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
