import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:plantoguard/constants.dart';
import 'dart:convert';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _image;
  String? _label;
  double? _confidence;
  String? _diseaseName;
  String? _cause;
  String? _solution;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _label = null;
        _confidence = null;
        _diseaseName = null;
        _cause = null;
        _solution = null;
      });
      _uploadImage(File(picked.path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:5000/predict'),
    );
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        setState(() {
          _label = data['label'];
          _confidence = data['confidence'];

          if (data['data'] != null) {
            final disease = data['data'];
            _diseaseName = disease['name'];
            _cause = disease['cause'];
            _solution = disease['solution'];
          }
        });
      } else {
        setState(() {
          _label = "Prediction failed";
        });
      }
    } catch (e) {
      setState(() {
        _label = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _label = null;
        _confidence = null;
        _diseaseName = null;
        _cause = null;
        _solution = null;
      });
      _uploadImage(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Constants.primaryColor.withOpacity(.15),
                    ),
                    child: Icon(Icons.close, color: Constants.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            right: 20,
            left: 20,
            child: Container(
              width: size.width * .8,
              height: size.height * .8,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_image != null) Image.file(_image!, height: 200),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.image),
                                label: const Text("Gallery"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (_label != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Result Prediction:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _label ?? "",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_confidence != null)
                                  Text(
                                    "Confidence: ${(_confidence! * 100).toStringAsFixed(2)}%",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                const SizedBox(height: 20),
                                if (_diseaseName != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name Disease:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(_diseaseName!),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Cause:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(_cause ?? "-"),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Solution:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(_solution ?? "-"),
                                    ],
                                  ),
                              ],
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
