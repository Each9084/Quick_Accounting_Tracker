import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double income;
  final double expense;

  const SummaryCard({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    //注意这里的expense本身就是负的 最终 = 收入(正)+支出(负),自动减了
    final total = income + expense;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          const Text(
            "Total Banlance",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(
            height: 6,
          ),
          //小数点后2位
          Text(
            "£ ${total.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem("Income", income, Colors.green,Icons.attach_money),
              _buildInfoItem("Expenses", expense, Colors.redAccent,Icons.money_off),
            ],
          ),
          const SizedBox(height: 10,),

        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, double amount, Color color,IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color),
        SizedBox(
          width: 4,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text("£ ${amount.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}
