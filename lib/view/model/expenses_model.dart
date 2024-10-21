import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

class ExpensesModel {
  ExpensesModel({
    required this.amount,
    required this.title,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  // To convert the model data to JSON format
  Map<String, dynamic> toJSON() => {
        'amount': amount,
        'title': title,
        'date': date.toIso8601String(),
        'category': category.name,
      };

  // To convert from JSON to Model data
  factory ExpensesModel.fromJson(Map<String, dynamic> json) {
    return ExpensesModel(
      amount: json['amount'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      category: Category.values.firstWhere(
        (cat) => cat.name == json['category'],
      ),
    );
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  final Category category;
  final List<ExpensesModel> expenses;

  ExpenseBucket.forCategory(List<ExpensesModel> allExpense, this.category)
      : expenses = allExpense.where((e) => e.category == category).toList();

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}

enum Category { food, travel, communication, groceries }

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.communication: Icons.phone_iphone_sharp,
  Category.groceries: Icons.local_grocery_store_sharp,
  Category.travel: Icons.airplane_ticket,
};
