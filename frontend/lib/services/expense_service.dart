import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

class ExpenseService extends ChangeNotifier {
  final String _baseUrl = 'http://localhost:8080';

  Future<List<Expense>> getExpenses() async {
    final response = await http.get(Uri.parse('$_baseUrl/expenses'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Expense.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<Expense> addExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/expenses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(expense.toJson()),
    );
    if (response.statusCode == 201) {
      return Expense.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add expense');
    }
  }

  Future<void> deleteExpense(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/expenses/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete expense');
    }
  }
}