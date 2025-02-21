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
      body: FutureBuilder<List<Expense>>(
        future: Provider.of<ExpenseService>(context, listen: false).getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No expenses found.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else {
            final expenses = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ExpenseCard(expense: expenses[index]);  // Correct usage
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
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue[800],
        elevation: 4,
      ),
    );
  }
}