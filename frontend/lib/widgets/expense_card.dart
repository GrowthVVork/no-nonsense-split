import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'package:provider/provider.dart';
import '../services/expense_service.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          expense.description,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '\$${expense.amount.toStringAsFixed(2)} - ${DateFormat('yyyy-MM-dd HH:mm:ss').format(expense.date)}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            try {
              await Provider.of<ExpenseService>(context, listen: false).deleteExpense(expense.id!);
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete expense: $error')),
              );
            }
          },
        ),
      ),
    );
  }
}