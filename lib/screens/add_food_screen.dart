import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  List<Map<String, dynamic>> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  void _loadFoodItems() async {
    final items = await _databaseHelper.getAllFoodItems();
    setState(() {
      _foodItems = items;
    });
  }

  void _addFoodItem() async {
    String name = _nameController.text.trim();
    String costText = _costController.text.trim();

    if (name.isEmpty || costText.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    double? cost = double.tryParse(costText);
    if (cost == null) {
      _showError("Please enter a valid cost.");
      return;
    }

    await _databaseHelper.insertFoodItem(name, cost);
    _nameController.clear();
    _costController.clear();

    _showSuccess("Food item added successfully!");
    _loadFoodItems();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addFoodItem,
              child: Text('Add Food'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final food = _foodItems[index];
                  return ListTile(
                    title: Text(food['name']),
                    subtitle: Text('Cost: \$${food['cost'].toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
