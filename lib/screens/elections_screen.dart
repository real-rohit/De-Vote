import 'package:flutter/material.dart';

class ElectionsScreen extends StatelessWidget {
  final List<String> elections = [
    "Presidential Election",
    "State Assembly Election",
    "Local Body Election",
  ];

  ElectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Elections")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: elections.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(elections[index]),
              trailing: ElevatedButton(
                onPressed: () {
                  // Navigate to voting page for the selected election
                  Navigator.pushNamed(context, '/vote');
                },
                child: Text("Vote"),
              ),
            ),
          );
        },
      ),
    );
  }
}
