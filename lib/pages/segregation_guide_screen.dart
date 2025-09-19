import 'package:flutter/material.dart';

class SegregationGuideScreen extends StatelessWidget {
  const SegregationGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segregation Guide'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'How to Segregate Waste',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildGuideSection(
              title: 'Organic Waste (Green Bin)',
              items: [
                'Food scraps',
                'Yard waste (leaves, grass)',
                'Paper towels',
              ],
              color: Colors.green.shade100,
            ),
            _buildGuideSection(
              title: 'Recyclable Waste (Blue Bin)',
              items: [
                'Plastic bottles and containers',
                'Glass bottles',
                'Cardboard and paper',
                'Metal cans',
              ],
              color: Colors.blue.shade100,
            ),
            _buildGuideSection(
              title: 'Non-Recyclable Waste (Black Bin)',
              items: [
                'Used diapers and sanitary pads',
                'Plastic bags',
                'Broken ceramics and mirrors',
              ],
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection({required String title, required List<String> items, required Color color}) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
