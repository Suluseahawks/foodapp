import 'package:flutter/material.dart';
import 'package:foodapp/database/database_helper.dart';
import 'package:intl/intl.dart';

class OrderPlanScreen extends StatefulWidget {
  @override
  _OrderPlanScreenState createState() => _OrderPlanScreenState();
}

class _OrderPlanScreenState extends State<OrderPlanScreen> {
  DateTime? _selectedDate;
  double _targetCost = 0.0;
  List<Map<String, dynamic>> _foodItems = [];
  final List<int> _selectedFoodIds = [];
  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  // Load food items from the database
  Future<void> _loadFoodItems() async {
    final db = DatabaseHelper();
    final foodItems = await db.getAllFoodItems();
    setState(() {
      _foodItems = foodItems;
    });
  }

  // Update the total cost based on selected food items
  void _updateTotalCost() {
    _totalCost = 0.0;
    for (var foodItem in _selectedFoodIds) {
      final food = _foodItems.firstWhere((item) => item['id'] == foodItem);
      _totalCost += food['cost'];
    }
    setState(() {});
  }

  // Save the order plan
  Future<void> _saveOrderPlan() async {
    if (_selectedDate == null || _targetCost <= 0.0 || _totalCost > _targetCost) {
      // Show an error if the conditions aren't met
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please ensure the target cost is not exceeded and a date is selected.')),
      );
      return;
    }

    // Create a string of selected food item names
    String selectedItems = _selectedFoodIds
        .map((id) => _foodItems.firstWhere((item) => item['id'] == id)['name'])
        .join(', ');

    final db = DatabaseHelper();
    await db.saveOrderPlan(
      DateFormat('yyyy-MM-dd').format(_selectedDate!),
      _targetCost,
      selectedItems,
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Plan Saved!')));
    // Optionally, navigate back to the home screen or reset the form
    Navigator.pop(context);
  }

  // Pick a date using the Date Picker
  Future<void> _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date picker section
            ListTile(
              title: const Text('Select Date'),
              subtitle: Text(_selectedDate == null
                  ? 'No date selected'
                  : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),

            // Target cost input field
            TextField(
              decoration: const InputDecoration(labelText: 'Target Cost per Day'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _targetCost = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16),

            // List of food items to select
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = _foodItems[index];
                  return CheckboxListTile(
                    title: Text(foodItem['name']),
                    subtitle: Text('Cost: \$${foodItem['cost']}'),
                    value: _selectedFoodIds.contains(foodItem['id']),
                    onChanged: (isSelected) {
                      setState(() {
                        if (isSelected == true) {
                          _selectedFoodIds.add(foodItem['id']);
                        } else {
                          _selectedFoodIds.remove(foodItem['id']);
                        }
                        _updateTotalCost();
                      });
                    },
                  );
                },
              ),
            ),

            // Show total cost
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Total Cost: \$$_totalCost', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // Save button
            ElevatedButton(
              onPressed: _saveOrderPlan,
              child: const Text('Save Order Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
