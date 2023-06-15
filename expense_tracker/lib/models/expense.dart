import 'package:uuid/uuid.dart';

const _uuid = Uuid();

enum Category { food, work, travel, leisure }

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = _uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
}
