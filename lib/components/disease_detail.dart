import 'package:flutter/material.dart';
import '../models/disease.dart';

class DiseaseDetailDisplayer extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailDisplayer({Key? key, required this.disease})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              disease.imageURL,
              height: 500,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            disease.label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Plant: ${disease.plantName}",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          const Text(
            "Cause",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            disease.cause ?? 'No cause provided.',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16),
          const Text(
            "Solution",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            disease.solution ?? 'No solution provided.',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
