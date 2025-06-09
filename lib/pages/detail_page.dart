import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plantoguard/constants.dart';
import 'package:plantoguard/models/disease.dart';
import 'package:plantoguard/components/disease_detail.dart';

class DetailPage extends StatefulWidget {
  final int diseaseId;
  const DetailPage({Key? key, required this.diseaseId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Disease? disease;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDiseaseDetail();
  }

  Future<void> fetchDiseaseDetail() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:5000/disease/id/${widget.diseaseId}'));
    if (response.statusCode == 200) {
      setState(() {
        disease = Disease.fromJson(json.decode(response.body));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (disease == null) {
      return const Scaffold(
        body: Center(child: Text("Data not found")),
      );
    }

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
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Constants.primaryColor.withOpacity(.15),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              width: size.width * .8,
              height: size.height * .8,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: DiseaseDetailDisplayer(disease: disease!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}