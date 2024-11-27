import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date validation
import '../database/database_helper.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen({super.key});

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final TextEditingController _dateController = TextEditingController();
  Map<String, dynamic>? _orderPlan;

  void _queryOrderPlan() async {
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a date!')),
      );
      return;
    }

    // Validate the date format (YYYY-MM-DD)
    try {
      DateFormat('yyyy-MM-dd').parseStrict(_dateController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid date (YYYY-MM-DD)!')),
      );
      return;
    }

    final orderPlan =
        await DatabaseHelper().getOrderPlanByDate(_dateController.text);
    setState(() {
      _orderPlan = orderPlan;
    });

    if (orderPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No order plan found for this date!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Order Plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Enter Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _queryOrderPlan,
              child: const Text('Query Order Plan'),
            ),
            const SizedBox(height: 24),
            _orderPlan == null
                ? const Text('No data available', textAlign: TextAlign.center)
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: ${_orderPlan!['date']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Target Cost: \$${_orderPlan!['target_cost']}'),
                          Text('Items: ${_orderPlan!['items']}'),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
