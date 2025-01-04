import 'package:expense_tracker/view/model/expenses_model.dart';
import 'package:expense_tracker/view/widget/expenses_card_widget.dart';
import 'package:flutter/material.dart';

class ExpensesListBuilderWidget extends StatelessWidget {
  const ExpensesListBuilderWidget(
      {super.key,
      required this.expenses,
      required this.onTapRemoveExpense,
      required this.onTapEditExpense});
  final List<ExpensesModel?> expenses;
  final void Function(ExpensesModel expense) onTapRemoveExpense;
  final void Function(ExpensesModel expense) onTapEditExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTapEditExpense(expenses[index]!),
          child: Dismissible(
            key: ValueKey(expenses[index]),
            background: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    Theme.of(context).colorScheme.error.withValues(alpha: .8),
              ),
            ),
            onDismissed: (direction) {
              onTapRemoveExpense(expenses[index]!);
            },
            child: ExpensesCardWidget(
              expenses: expenses[index],
            ),
          ),
        );
      },
    );
  }
}
