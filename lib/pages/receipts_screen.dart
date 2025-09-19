import 'package:flutter/material.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a static example. In a real app, this data would come from an API.
    final List<Map<String, String>> receipts = [
      {'id': 'REC-001', 'date': '2023-10-25', 'amount': '\$5.00', 'type': 'Organic Waste'},
      {'id': 'REC-002', 'date': '2023-10-22', 'amount': '\$4.50', 'type': 'Recyclable Waste'},
      {'id': 'REC-003', 'date': '2023-10-18', 'amount': '\$5.00', 'type': 'Organic Waste'},
      {'id': 'REC-004', 'date': '2023-10-15', 'amount': '\$3.75', 'type': 'E-Waste'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloadable Receipts'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: receipts.length,
        itemBuilder: (context, index) {
          final receipt = receipts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.receipt, color: Colors.blueGrey),
              title: Text('Receipt ID: ${receipt['id']}'),
              subtitle: Text('Date: ${receipt['date']} - Amount: ${receipt['amount']}'),
              trailing: IconButton(
                icon: const Icon(Icons.file_download),
                onPressed: () {
                  // Implement PDF download functionality here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Downloading receipt ${receipt['id']}...')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
