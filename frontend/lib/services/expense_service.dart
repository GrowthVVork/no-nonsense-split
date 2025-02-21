import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/expense.dart';

class ExpenseService extends ChangeNotifier {
  final String _baseUrl = 'http://localhost:8080';
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    final response = await http.get(Uri.parse('$_baseUrl/expenses'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _expenses = data.map((json) => Expense.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<void> addExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/expenses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(expense.toJson()),
    );
    if (response.statusCode == 201) {
      await fetchExpenses();
    } else {
      throw Exception('Failed to add expense');
    }
  }

  Future<void> deleteExpense(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/expenses/$id'),
    );
    if (response.statusCode == 200) {
      await fetchExpenses();
    } else {
      throw Exception('Failed to delete expense');
    }
  }
}