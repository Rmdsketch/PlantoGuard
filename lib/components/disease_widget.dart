import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:plantoguard/constants.dart';
import 'package:plantoguard/models/disease.dart';
import 'package:plantoguard/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiseaseWidget extends StatelessWidget {
  const DiseaseWidget({
    Key? key,
    required this.diseaseList,
    this.onRefresh,
  }) : super(key: key);

  final List<Disease> diseaseList;
  final VoidCallback? onRefresh;

  Future<void> _deleteDisease(BuildContext context, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Disease'),
        content: const Text('Are you sure you want to delete this disease?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final response = await ApiService.deleteDisease(id, token);
      if (response['success']) {
        onRefresh?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: AwesomeSnackbarContent(
              title: 'Deleted!',
              message: 'Disease has been deleted.',
              contentType: ContentType.success,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: 'Error',
              message: response['message'] ?? 'Failed to delete disease.',
              contentType: ContentType.failure,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }
    }
  }

  void _showDiseaseForm(BuildContext context, {Disease? disease}) {
    final _formKey = GlobalKey<FormState>();
    final labelController = TextEditingController(text: disease?.label ?? '');
    final plantNameController =
        TextEditingController(text: disease?.plantName ?? '');
    final imagePathController =
        TextEditingController(text: disease?.imagePath ?? '');
    final causeController = TextEditingController(text: disease?.cause ?? '');
    final solutionController =
        TextEditingController(text: disease?.solution ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(disease == null ? 'Add New Disease' : 'Edit Disease'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: labelController,
                  decoration: const InputDecoration(labelText: 'Label'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: plantNameController,
                  decoration: const InputDecoration(labelText: 'Disease Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: imagePathController,
                  decoration: const InputDecoration(
                      labelText: 'Image Path (e.g. /static/images/...)'),
                ),
                TextFormField(
                  controller: causeController,
                  decoration:
                      const InputDecoration(labelText: 'Cause (optional)'),
                ),
                TextFormField(
                  controller: solutionController,
                  decoration:
                      const InputDecoration(labelText: 'Solution (optional)'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token') ?? '';

                final data = {
                  "label": labelController.text,
                  "name": plantNameController.text,
                  "image": imagePathController.text,
                  "cause": causeController.text,
                  "solution": solutionController.text,
                };

                late Map<String, dynamic> response;
                if (disease == null) {
                  response = await ApiService.createDisease(
                    data: data,
                    token: token,
                  );
                } else {
                  response = await ApiService.updateDisease(
                    id: disease.diseaseId,
                    updatedData: data,
                    token: token,
                  );
                }

                Navigator.pop(context);

                final snackBar = SnackBar(
                  content: AwesomeSnackbarContent(
                    title: response['success'] ? 'Success!' : 'Failed!',
                    message: response['success']
                        ? (disease == null
                            ? 'Disease added successfully.'
                            : 'Disease updated successfully.')
                        : response['message'] ?? 'Something went wrong.',
                    contentType: response['success']
                        ? ContentType.success
                        : ContentType.failure,
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                if (response['success']) {
                  onRefresh?.call();
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () => _showDiseaseForm(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
              ),
            ),
          ),
        ),
        ...List.generate(diseaseList.length, (index) {
          final disease = diseaseList[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Constants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    disease.imageURL,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        disease.plantName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Constants.blackColor,
                        ),
                      ),
                      Text(
                        disease.label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit',
                      color: Colors.orange,
                      onPressed: () {
                        _showDiseaseForm(context, disease: disease);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Delete',
                      color: Colors.red,
                      onPressed: () {
                        _deleteDisease(context, disease.diseaseId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}