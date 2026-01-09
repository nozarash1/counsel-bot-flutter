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

  // Theme Colors
  final Color _coffeeDark = const Color(0xFF3E2723); // Deep Espresso
  final Color _coffeeMedium = const Color(0xFF5D4037); // Lighter Brown
  final Color _creamBackground = const Color(0xFFFDFBF7); // Paper/Cream
  final Color _textDark = const Color(0xFF2D1E1B); // Almost Black

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decorative Icon
                Icon(
                  Icons.rate_review_rounded,
                  size: 60,
                  color: _creamBackground.withOpacity(0.8),
                ),
                const SizedBox(height: 20),

                // Main Content Card
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
                        // Card Header
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

                        // Form Label
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

                        // Text Field (Multiline)
                        TextFormField(
                          controller: feedbackController,
                          maxLines: 5, // Allow multiple lines for feedback
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

                        // Submit Button
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
                )
              ],
            ),
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

    final api = Uri.parse('$url/flutter_login_post/');

    try {
      final request = await http.post(api, body: {
        'feedback': feedback,
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
              msg: 'Feedback submitted successfully',
              backgroundColor: Colors.green.shade800,
              textColor: Colors.white
          );
          // Optional: Clear the field after success
          feedbackController.clear();
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