import 'dart:convert';
import 'package:expense_tracker/view/chart/chart_page.dart';
import 'package:expense_tracker/view/model/expenses_model.dart';
import 'package:expense_tracker/view/widget/expenses_list_builer_widget.dart';
import 'package:expense_tracker/view/widget/new_expenses_manage_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});
  @override
  State<ExpensesPage> createState() {
    return _ExpensesPageState();
  }
}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<ExpensesModel> _registeredExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

// to save data into local storage
  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseJson = _registeredExpenses
        .map(
          (e) => jsonEncode(e.toJSON()),
        )
        .toList();
    await prefs.setStringList('expense', expenseJson);
  }

// to get from the local storage
  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseData = prefs.getStringList('expense') ?? [];
    setState(() {
      _registeredExpenses.addAll(expenseData
          .map((e) => ExpensesModel.fromJson(jsonDecode(e)))
          .toList());
    });
  }

  void _addExpenseOption() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (cnxt) => NewExpensesWidget(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(ExpensesModel exoense) {
    setState(() {
      _registeredExpenses.add(exoense);
    });
    _saveExpenses(); // save expense after adding
  }

  void _removeExpense(ExpensesModel expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    _saveExpenses(); //save expense after removing
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _editExpense(ExpensesModel oldExpense, ExpensesModel updatedExpense) {
    final expenseIndex = _registeredExpenses.indexOf(oldExpense);
    setState(() {
      _registeredExpenses[expenseIndex] = updatedExpense;
    });
    _saveExpenses();
  }

  void _showEditExpenseBottomSheet(ExpensesModel oldExpense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (cntx) => NewExpensesWidget(
        onAddExpense: (updatedExpense) {
          _editExpense(oldExpense, updatedExpense);
        },
        initialExpense: oldExpense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        'No expenses found. Start adding some',
        style: TextStyle(fontSize: 20),
      ),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesListBuilderWidget(
        expenses: _registeredExpenses,
        onTapRemoveExpense: _removeExpense,
        onTapEditExpense: (oldExpense) {
          _showEditExpenseBottomSheet(oldExpense);
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/expenzy.png',
          color: const Color.fromARGB(255, 242, 244, 246),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          if (_registeredExpenses.isNotEmpty)
            Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpenseOption,
        child: Image.asset(
          'assets/images/add.png',
          height: 28,
        ),
      ),
    );
  }
}
