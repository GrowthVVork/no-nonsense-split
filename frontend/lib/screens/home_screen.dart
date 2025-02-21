import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'No-Nonsense Split',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Consumer<ExpenseService>(
        builder: (context, expenseService, child) {
          if (expenseService.expenses.isEmpty) {
            return Center(
              child: Text(
                'No expenses found.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: expenseService.expenses.length,
              itemBuilder: (context, index) {
                return ExpenseCard(expense: expenseService.expenses[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          ).then((_) {
            // Refresh the list after returning from the Add Expense screen
            Provider.of<ExpenseService>(context, listen: false).fetchExpenses();
          });
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue[800],
        elevation: 4,
      ),
    );
  }
}