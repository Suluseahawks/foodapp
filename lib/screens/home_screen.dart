import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'order_plan_screen.dart';
import 'query_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Ordering App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFoodScreen()),
                );
              },
              child: const Text('Manage Food Items'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPlanScreen()),
                );
              },
              child: const Text('Create Order Plan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QueryScreen()),
                );
              },
              child: const Text('Query Order Plans'),
            ),
          ],
        ),
      ),
    );
  }
}
