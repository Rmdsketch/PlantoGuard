import 'package:flutter/material.dart';
import 'package:plantoguard/constants.dart';
import 'package:plantoguard/models/disease.dart';
import 'package:plantoguard/pages/detail_page.dart';
import 'package:plantoguard/components/disease_widget.dart';
import 'package:plantoguard/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Disease> _diseaseList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDiseases();
  }

  Future<void> _fetchDiseases() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await ApiService.getDiseases(token);
    setState(() {
      _diseaseList = response.map((json) => Disease.fromJson(json)).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: Disease Highlight
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20),
                    child: Text(
                      'Disease Highlight',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),

                  // Horizontal Highlight Cards
                  SizedBox(
                    height: size.height * .35,
                    child: ListView.builder(
                      itemCount: _diseaseList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final disease = _diseaseList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: DetailPage(diseaseId: disease.diseaseId),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                          child: Container(
                            width: 220,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(disease.imageURL),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      disease.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      disease.cause ?? '-',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: DetailPage(
                                                  diseaseId: disease.diseaseId),
                                              type: PageTransitionType
                                                  .bottomToTop,
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.visibility,
                                            size: 16),
                                        label: const Text("See Details",
                                            style: TextStyle(fontSize: 13)),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              Constants.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Section Title: New Diseases
                  Container(
                    padding:
                        const EdgeInsets.only(left: 16, bottom: 10, top: 20),
                    child: Text(
                      'New Diseases',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),

                  // Disease List with add/edit/delete
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DiseaseWidget(
                      diseaseList: _diseaseList,
                      onRefresh: _fetchDiseases,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}