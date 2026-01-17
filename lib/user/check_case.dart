import 'dart:convert';

import 'package:counsel/user/home.dart';
import 'package:counsel/user/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class check_case extends StatefulWidget {
  const check_case({super.key});

  @override
  State<check_case> createState() => _check_caseState();
}

class _check_caseState extends State<check_case> {
  TextEditingController caseController = TextEditingController();

  // Define your theme colors based on the images provided
  final Color _coffeeDark = const Color(0xFF3E2723); // Deep Espresso
  final Color _coffeeMedium = const Color(0xFF5D4037); // Lighter Brown
  final Color _creamBackground = const Color(0xFFFDFBF7); // Paper/Cream
  final Color _textDark = const Color(0xFF2D1E1B); // Almost Black

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _coffeeDark, // Dark background like the Login image
      appBar: AppBar(
        title: const Text(
          'THE CHAMBERS',
          style: TextStyle(
              fontFamily: 'serif', // Serif font for that formal "Legal" look
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
                  Icons.gavel_rounded, // Courtroom/Legal icon
                  size: 60,
                  color: _creamBackground.withOpacity(0.8),
                ),
                const SizedBox(height: 20),

                // Main Content Card
                Card(
                  elevation: 8,
                  color: _creamBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), // Sharp corners for formal look
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
                                "CASE LOOKUP",
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
                        const SizedBox(height: 40),

                        // Form Label
                        Text(
                          "CASE IDENTIFIER",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _coffeeMedium,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),

                         // Text Field
                        TextFormField(
                          controller: caseController,
                          style: TextStyle(color: _textDark, fontWeight: FontWeight.w500),
                          cursorColor: _coffeeDark,
                          decoration: InputDecoration(
                            hintText: 'Enter Case Number',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

                        // Action Button
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
                              'SEARCH RECORDS',
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
                  "Secure System Access",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
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
    String ccase = caseController.text.trim();

    if (ccase.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please fill in the Case Identifier',
          backgroundColor: _coffeeDark,
          textColor: Colors.white);
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    final api = Uri.parse('$url/fetch_case/');

    try {
      final request = await http.post(api, body: {
        'case': ccase,
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Success');
          // Navigate or Perform next action here

    //       "section":ob.section,
    // "details":ob.details,
    // "punishment":ob.punish
          print(data['section']);
          print(data['details']);
          print(data['punishment']);




        } else {
          Fluttertoast.showToast(msg: 'Failed: Case not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Connection error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}