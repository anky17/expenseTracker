import 'package:expense_tracker/view/model/expenses_model.dart';
import 'package:flutter/material.dart';

class ExpensesCardWidget extends StatelessWidget {
  const ExpensesCardWidget({super.key, required this.expenses});
  final ExpensesModel? expenses;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expenses?.title.toString() ?? "n/a",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                Text('Rs. ${expenses?.amount.toStringAsFixed(2) ?? "0"}'),
                const Spacer(),
                Icon(categoryIcons[expenses?.category]),
                const SizedBox(width: 5),
                Text(expenses?.formattedDate ?? "n/a")
              ],
            )
          ],
        ),
      ),
    );
  }
}
