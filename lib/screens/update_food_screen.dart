import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class UpdateFoodScreen extends StatefulWidget {
  final int foodId;
  final String initialName;
  final double initialCost;

  const UpdateFoodScreen({
    required this.foodId,
    required this.initialName,
    required this.initialCost,
    super.key,
  });

  @override
  _UpdateFoodScreenState createState() => _UpdateFoodScreenState();
}

class _UpdateFoodScreenState extends State<UpdateFoodScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late TextEditingController _nameController;
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _costController = TextEditingController(text: widget.initialCost.toStringAsFixed(2));
  }

  void _updateFoodItem() async {
    String updatedName = _nameController.text.trim();
    String updatedCostText = _costController.text.trim();

    if (updatedName.isEmpty || updatedCostText.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    double? updatedCost = double.tryParse(updatedCostText);
    if (updatedCost == null) {
      _showError("Please enter a valid cost.");
      return;
    }

    await _databaseHelper.updateFoodItem(widget.foodId, updatedName, updatedCost);

    _showSuccess("Food item updated successfully!");
    Navigator.pop(context, true); // Pass 'true' to indicate successful update
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
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Food Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: _costController,
              decoration: const InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateFoodItem,
              child: const Text('Update Food'),
            ),
          ],
        ),
      ),
    );
  }
}
