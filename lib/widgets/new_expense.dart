import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({
    required this.addNewExpense,
    required this.listOfExpenses,
    super.key,
  });

  final List<Expense> listOfExpenses;
  final void Function(Expense expense) addNewExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleControler = TextEditingController();
  final _amountControler = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePiker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseDate() {
    final enteredAmount = double.tryParse(_amountControler.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleControler.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // show error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, data and category was entered.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
      return;
    }

    widget.addNewExpense(Expense(
        title: _titleControler.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleControler.dispose();
    _amountControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleControler,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountControler,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_selectedDate == null
                      ? 'No date selected'
                      : formatter.format(_selectedDate!)),
                  IconButton(
                      onPressed: _presentDatePiker,
                      icon: const Icon(
                        Icons.calendar_month,
                      ))
                ],
              )),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(children: [
            DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                }),
            const Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            OutlinedButton(
                onPressed: _submitExpenseDate,
                child: const Text('Save Expense!')),
          ]),
        ],
      ),
    );
  }
}
