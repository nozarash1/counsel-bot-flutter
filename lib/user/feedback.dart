import 'dart:convert';
import 'package:counsel/user/home.dart';
import 'package:counsel/user/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class feedback extends StatefulWidget {
  const feedback({super.key});

  @override
  State<feedback> createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  TextEditingController feedbackController = TextEditingController();

  List<dynamic> feedbackList = [];
  bool isLoading = true;

  final Color _coffeeDark = const Color(0xFF3E2723);
  final Color _coffeeMedium = const Color(0xFF5D4037);
  final Color _creamBackground = const Color(0xFFFDFBF7);
  final Color _textDark = const Color(0xFF2D1E1B);

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    if (url == null) {
      setState(() { isLoading = false; });
      return;
    }

    final api = Uri.parse('$url/View_Appfeedback/');

    try {
      final response = await http.get(api);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            feedbackList = data['data'];
            isLoading = false;
          });
        }
      } else {
        setState(() { isLoading = false; });
      }
    } catch (e) {
      setState(() { isLoading = false; });
      Fluttertoast.showToast(msg: 'Error loading feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _coffeeDark,
      appBar: AppBar(
        title: const Text(
          'THE CHAMBERS',
          style: TextStyle(
              fontFamily: 'serif',
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.rate_review_rounded,
                size: 60,
                color: _creamBackground.withOpacity(0.8),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 8,
                color: _creamBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "YOUR FEEDBACK",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'serif',
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 60,
                              height: 3,
                              color: _coffeeMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "COMMENTS & SUGGESTIONS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _coffeeMedium,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: feedbackController,
                        maxLines: 5,
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.w500),
                        cursorColor: _coffeeDark,
                        decoration: InputDecoration(
                          hintText: 'Please describe your experience...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _coffeeDark, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: sendData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _coffeeDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'SUBMIT REVIEW',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Your opinion matters to us",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "RECENT FEEDBACK",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : feedbackList.isEmpty
                  ? const Center(
                child: Text(
                  "No feedback submitted yet.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  var item = feedbackList[index];
                  return Card(
                    elevation: 2,
                    color: _creamBackground,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['username']?.toString().toUpperCase() ?? 'ANONYMOUS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _coffeeDark,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                item['Date']?.toString() ?? '',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _coffeeMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['Feedback']?.toString() ?? '',
                            style: TextStyle(
                              color: _textDark,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendData() async {
    String feedback = feedbackController.text.trim();

    if (feedback.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter your feedback',
        backgroundColor: _coffeeDark,
        textColor: Colors.white,
      );
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    final api = Uri.parse('$url/send_Appfeedback/');

    try {
      final request = await http.post(api, body: {
        'Feedback': feedback,
        'lid': lid ?? "",
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
              msg: 'Feedback submitted successfully',
              backgroundColor: Colors.green.shade800,
              textColor: Colors.white
          );
          feedbackController.clear();
          fetchFeedback();
        } else {
          Fluttertoast.showToast(msg: 'Submission failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Connection error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}