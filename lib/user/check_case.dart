// // import 'dart:convert';
// //
// // import 'package:counsel/user/home.dart';
// // import 'package:counsel/user/registration.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http/http.dart' as http;
// //
// // class check_case extends StatefulWidget {
// //   const check_case({super.key});
// //
// //   @override
// //   State<check_case> createState() => _check_caseState();
// // }
// //
// // class _check_caseState extends State<check_case> {
// //   TextEditingController caseController = TextEditingController();
// //
// //   // Define your theme colors based on the images provided
// //   final Color _coffeeDark = const Color(0xFF3E2723); // Deep Espresso
// //   final Color _coffeeMedium = const Color(0xFF5D4037); // Lighter Brown
// //   final Color _creamBackground = const Color(0xFFFDFBF7); // Paper/Cream
// //   final Color _textDark = const Color(0xFF2D1E1B); // Almost Black
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: _coffeeDark, // Dark background like the Login image
// //       appBar: AppBar(
// //         title: const Text(
// //           'THE CHAMBERS',
// //           style: TextStyle(
// //               fontFamily: 'serif', // Serif font for that formal "Legal" look
// //               letterSpacing: 1.5,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //               fontSize: 16
// //           ),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //       ),
// //       body: Center(
// //         child: SingleChildScrollView(
// //           child: Padding(
// //             padding: const EdgeInsets.all(24.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 // Decorative Icon
// //                 Icon(
// //                   Icons.gavel_rounded, // Courtroom/Legal icon
// //                   size: 60,
// //                   color: _creamBackground.withOpacity(0.8),
// //                 ),
// //                 const SizedBox(height: 20),
// //
// //                 // Main Content Card
// //                 Card(
// //                   elevation: 8,
// //                   color: _creamBackground,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(4), // Sharp corners for formal look
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // Card Header
// //                         Center(
// //                           child: Column(
// //                             children: [
// //                               Text(
// //                                 "CASE LOOKUP",
// //                                 style: TextStyle(
// //                                   fontSize: 22,
// //                                   fontFamily: 'serif',
// //                                   fontWeight: FontWeight.bold,
// //                                   color: _textDark,
// //                                   letterSpacing: 1.2,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 8),
// //                               Container(
// //                                 width: 60,
// //                                 height: 3,
// //                                 color: _coffeeMedium,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         const SizedBox(height: 40),
// //
// //                         // Form Label
// //                         Text(
// //                           "CASE IDENTIFIER",
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.bold,
// //                             color: _coffeeMedium,
// //                             letterSpacing: 1.0,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //
// //                          // Text Field
// //                         TextFormField(
// //                           controller: caseController,
// //                           style: TextStyle(color: _textDark, fontWeight: FontWeight.w500),
// //                           cursorColor: _coffeeDark,
// //                           decoration: InputDecoration(
// //                             hintText: 'Enter Case Number',
// //                             hintStyle: TextStyle(color: Colors.grey.shade400),
// //                             filled: true,
// //                             fillColor: Colors.white,
// //                             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
// //                             enabledBorder: OutlineInputBorder(
// //                               borderSide: BorderSide(color: Colors.grey.shade300),
// //                               borderRadius: BorderRadius.circular(4),
// //                             ),
// //                             focusedBorder: OutlineInputBorder(
// //                               borderSide: BorderSide(color: _coffeeDark, width: 2),
// //                               borderRadius: BorderRadius.circular(4),
// //                             ),
// //                           ),
// //                         ),
// //
// //                         const SizedBox(height: 30),
// //
// //                         // Action Button
// //                         SizedBox(
// //                           width: double.infinity,
// //                           height: 50,
// //                           child: ElevatedButton(
// //                             onPressed: sendData,
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: _coffeeDark,
// //                               foregroundColor: Colors.white,
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(4),
// //                               ),
// //                               elevation: 2,
// //                             ),
// //                             child: const Text(
// //                               'SEARCH RECORDS',
// //                               style: TextStyle(
// //                                 fontSize: 14,
// //                                 fontWeight: FontWeight.bold,
// //                                 letterSpacing: 1.5,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //
// //
// //                 const SizedBox(height: 20),
// //                 Text(
// //                   "Secure System Access",
// //                   style: TextStyle(
// //                     color: Colors.white.withOpacity(0.5),
// //                     fontSize: 12,
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void sendData() async {
// //     String ccase = caseController.text.trim();
// //
// //     if (ccase.isEmpty) {
// //       Fluttertoast.showToast(
// //           msg: 'Please fill in the Case Identifier',
// //           backgroundColor: _coffeeDark,
// //           textColor: Colors.white);
// //       return;
// //     }
// //
// //     final sh = await SharedPreferences.getInstance();
// //     String? url = sh.getString('url');
// //
// //     final api = Uri.parse('$url/fetch_case/');
// //
// //     try {
// //       final request = await http.post(api, body: {
// //         'case': ccase,
// //       });
// //
// //       if (request.statusCode == 200) {
// //         var data = jsonDecode(request.body);
// //         if (data['status'] == 'ok') {
// //           Fluttertoast.showToast(msg: 'Success');
// //     //       Navigate or Perform next action here
// //     //
// //     //       "section":ob.section,
// //     // "details":ob.details,
// //     // "punishment":ob.punish
// //           print(data['section']);
// //           print(data['details']);
// //           print(data['punishment']);
// //
// //
// //
// //
// //         } else {
// //           Fluttertoast.showToast(msg: 'Failed: Case not found');
// //         }
// //       } else {
// //         Fluttertoast.showToast(msg: 'Connection error');
// //       }
// //     } catch (e) {
// //       Fluttertoast.showToast(msg: 'Error: $e');
// //     }
// //   }
// // }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class CheckCase extends StatefulWidget {
//   const CheckCase({super.key});
//
//   @override
//   State<CheckCase> createState() => _CheckCaseState();
// }
//
// class _CheckCaseState extends State<CheckCase> {
//   // Theme colors
//   final Color _coffeeDark = const Color(0xFF3E2723);
//   final Color _coffeeMedium = const Color(0xFF5D4037);
//   final Color _creamBackground = const Color(0xFFFDFBF7);
//   final Color _textDark = const Color(0xFF2D1E1B);
//
//   final TextEditingController _caseController = TextEditingController();
//   bool _showChatInterface = false;
//
//   // Restored Questions
//   late List<Map<String, dynamic>> _questions = [
//     {"id": 1, "text": "Was the incident reported to the authorities within 24 hours?"},
//     {"id": 2, "text": "Was there any physical evidence found at the scene?"},
//     {"id": 3, "text": "Are there any witnesses willing to testify?"},
//   ];
//
//   final Map<int, String> _responses = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _coffeeDark,
//       appBar: AppBar(
//         title: const Text(
//           'THE CHAMBERS',
//           style: TextStyle(
//             fontFamily: 'serif',
//             letterSpacing: 1.5,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             if (_showChatInterface) {
//               setState(() => _showChatInterface = false);
//             } else {
//               Navigator.pop(context);
//             }
//           },
//         ),
//       ),
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 400),
//         transitionBuilder: (Widget child, Animation<double> animation) {
//           return FadeTransition(
//             opacity: animation,
//             child: SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(0, 0.05),
//                 end: Offset.zero,
//               ).animate(animation),
//               child: child,
//             ),
//           );
//         },
//         child: _showChatInterface ? _buildChatInterface() : _buildLandingInterface(),
//       ),
//     );
//   }
//   void sendData() async {
//     String ccase = _caseController.text.trim();
//
//     if (ccase.isEmpty) {
//       Fluttertoast.showToast(
//           msg: 'Please fill in the Case Identifier',
//           backgroundColor: _coffeeDark,
//           textColor: Colors.white);
//       return;
//     }
//
//     final sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//
//     final api = Uri.parse('$url/fetch_case/');
//
//     try {
//       final request = await http.post(api, body: {
//         'case': ccase,
//       });
//
//       if (request.statusCode == 200) {
//         var data = jsonDecode(request.body);
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: 'Success');
//     //       Navigate or Perform next action here
//     //
//     //       "section":ob.section,
//     // "details":ob.details,
//     // "punishment":ob.punish
//           sh.setString("sid", data['sid'].toString());
//           print(data['section']);
//           print(data['details']);
//           print(data['punishment']);
// print( data["data"]);
// print( data["data"]);
//           _questions = List<Map<String, dynamic>>.from(data["data"]);
//           setState(() => _showChatInterface = true);
//
//
//         } else {
//           Fluttertoast.showToast(msg: 'Failed: Case not found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Connection error');
//       }
//     } catch (e) {
//       print(e);
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
//   // Exact UI from the image
//   Widget _buildLandingInterface() {
//     return Center(
//       key: const ValueKey('landing'),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             // Icon from image
//             Icon(Icons.gavel_rounded, size: 60, color: _creamBackground.withOpacity(0.2)),
//             const SizedBox(height: 40),
//
//             // White Card
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
//               decoration: BoxDecoration(
//                 color: _creamBackground,
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     "CASE LOOKUP",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontFamily: 'serif',
//                       fontWeight: FontWeight.bold,
//                       color: _textDark,
//                       letterSpacing: 2.0,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(width: 50, height: 2, color: _coffeeMedium),
//                   const SizedBox(height: 40),
//
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "CASE IDENTIFIER",
//                       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _coffeeMedium, letterSpacing: 1.0),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _caseController,
//                     decoration: InputDecoration(
//                       hintText: "Enter Case Number",
//                       hintStyle: TextStyle(color: Colors.grey.shade400),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//
//                   SizedBox(
//                     width: double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_caseController.text.trim().isEmpty) {
//                           Fluttertoast.showToast(msg: "Please enter case identifier");
//                           return;
//                         }
//                         sendData();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _coffeeDark,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//                       ),
//                       child: const Text("SEARCH CASES", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             Text("Secure System Access", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, letterSpacing: 0.5)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChatInterface() {
//     return Column(
//       key: const ValueKey('chat'),
//       children: [
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(20),
//             itemCount: _questions.length,
//             itemBuilder: (context, index) {
//               final q = _questions[index];
//               return _buildQuestionItem(q);
//             },
//           ),
//         ),
//         _buildFooter(),
//       ],
//     );
//   }
//
//   Widget _buildQuestionItem(Map<String, dynamic> q) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: _creamBackground,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(12),
//               topRight: Radius.circular(12),
//               bottomRight: Radius.circular(12),
//             ),
//           ),
//           child: Text(
//             q['text'],
//             style: TextStyle(color: _textDark, fontFamily: 'serif', fontSize: 15),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Padding(
//           padding: const EdgeInsets.only(left: 40, bottom: 24),
//           child: Row(
//             children: [
//               _buildResponseOption(q['id'], "Yes"),
//               const SizedBox(width: 20),
//               _buildResponseOption(q['id'], "No"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildResponseOption(int qId, String label) {
//     bool selected = _responses[qId] == label;
//     return InkWell(
//       onTap: () => setState(() => _responses[qId] = label),
//       child: Row(
//         children: [
//           Container(
//             width: 18,
//             height: 18,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: selected ? _creamBackground : Colors.white38, width: 2),
//             ),
//             child: selected
//                 ? Center(child: Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: _creamBackground)))
//                 : null,
//           ),
//           const SizedBox(width: 8),
//           Text(label, style: TextStyle(color: selected ? _creamBackground : Colors.white60, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFooter() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       color: _coffeeDark,
//       child: SizedBox(
//         width: double.infinity,
//         height: 55,
//         child: ElevatedButton(
//           onPressed: () async {
//
//             print(_responses);
//             print(">>>>>>>>>>>>>>>>");
//             if (_responses.length < _questions.length) {
//               Fluttertoast.showToast(msg: "Please answer all questions");
//               return;
//             }
//
//
//
//             final sh = await SharedPreferences.getInstance();
//             String? url = sh.getString('url');
//             String? sid = sh.getString('sid');
//
//             final api = Uri.parse('$url/fetch_case_details/');
//
//             try {
//               final request = await http.post(api, body: {
//                 'sid': sid.toString(),
//                 "qa":_responses.toString()
//               });
//
//               if (request.statusCode == 200) {
//                 var data = jsonDecode(request.body);
//                 if (data['status'] == 'ok') {
//                   Fluttertoast.showToast(msg: 'Success');
//                   //       Navigate or Perform next action here
//                   //
//                   //       "section":ob.section,
//                   // "details":ob.details,
//                   // "punishment":ob.punish
//                   sh.setString("sid", data['section'].toString());
//                   print(data['section']);
//                   print(data['details']);
//                   print(data['punishment']);
//                   print( data["data"]);
//                   print( data["data"]);
//                   _questions = List<Map<String, dynamic>>.from(data["data"]);
//                   setState(() => _showChatInterface = true);
//
//
//                 } else {
//                   Fluttertoast.showToast(msg: 'Failed: Case not found');
//                 }
//               } else {
//                 Fluttertoast.showToast(msg: 'Connection error');
//               }
//             } catch (e) {
//               print(e);
//               Fluttertoast.showToast(msg: 'Error: $e');
//             }
//
//
//             Fluttertoast.showToast(msg: "Searching legal sections...");
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: _creamBackground,
//             foregroundColor: _textDark,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//           ),
//           child: const Text("SEARCH SECTION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CheckCase extends StatefulWidget {
  const CheckCase({super.key});

  @override
  State<CheckCase> createState() => _CheckCaseState();
}

class _CheckCaseState extends State<CheckCase> {
  // Theme colors
  final Color _coffeeDark = const Color(0xFF3E2723);
  final Color _coffeeMedium = const Color(0xFF5D4037);
  final Color _creamBackground = const Color(0xFFFDFBF7);
  final Color _textDark = const Color(0xFF2D1E1B);

  final TextEditingController _caseController = TextEditingController();

  // State management: 0 = Landing, 1 = Chat/Questions, 2 = Results
  int _currentStep = 0;
  bool _isLoading = false;

  List<Map<String, dynamic>> _questions = [];
  final Map<int, String> _responses = {};

  // Store the final result from the backend
  Map<String, dynamic>? _caseResult;

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
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
                // Clear result if going back from result page
                if (_currentStep == 1) _caseResult = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentStep) {
      case 0:
        return _buildLandingInterface();
      case 1:
        return _buildChatInterface();
      case 2:
        return _buildResultInterface();
      default:
        return _buildLandingInterface();
    }
  }

  // ---------------- STEP 1: LANDING INTERFACE ----------------
  Widget _buildLandingInterface() {
    return Center(
      key: const ValueKey('landing'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.gavel_rounded, size: 60, color: _creamBackground.withOpacity(0.2)),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: _creamBackground,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "CASE LOOKUP",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(width: 50, height: 2, color: _coffeeMedium),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CASE IDENTIFIER",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _coffeeMedium, letterSpacing: 1.0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _caseController,
                    decoration: InputDecoration(
                      hintText: "Enter Case Number",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : sendData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _coffeeDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("SEARCH CASES", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text("Secure System Access", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  // ---------------- STEP 2: CHAT/QUESTIONS INTERFACE ----------------
  Widget _buildChatInterface() {
    return Column(
      key: const ValueKey('chat'),
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final q = _questions[index];
              return _buildQuestionItem(q);
            },
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildQuestionItem(Map<String, dynamic> q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _creamBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Text(
            q['text'] ?? '',
            style: TextStyle(color: _textDark, fontFamily: 'serif', fontSize: 15),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 24),
          child: Row(
            children: [
              _buildResponseOption(q['id'], "Yes"),
              const SizedBox(width: 20),
              _buildResponseOption(q['id'], "No"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponseOption(int qId, String label) {
    bool selected = _responses[qId] == label;
    return InkWell(
      onTap: () => setState(() => _responses[qId] = label),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: selected ? _creamBackground : Colors.white38, width: 2),
            ),
            child: selected
                ? Center(child: Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: _creamBackground)))
                : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: selected ? _creamBackground : Colors.white60, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  // ---------------- STEP 3: RESULT INTERFACE ----------------
  Widget _buildResultInterface() {
    if (_caseResult == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      key: const ValueKey('result'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Section Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _creamBackground,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "LEGAL ANALYSIS",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _coffeeMedium, letterSpacing: 1.5),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Section Title
                Text(
                  _caseResult!['section'] ?? "Unknown Section",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 16),

                // Details
                _buildInfoLabel("DESCRIPTION"),
                Text(
                  _caseResult!['details'] ?? "No details available.",
                  style: TextStyle(color: _textDark, fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 20),

                // Punishment
                _buildInfoLabel("PUNISHMENT"),
                Text(
                  _caseResult!['punishment'] ?? "No punishment details.",
                  style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Relevant Clauses Header
          if (_caseResult!['data'] != null && (_caseResult!['data'] as List).isNotEmpty) ...[
            Text(
              "APPLICABLE SUBSECTIONS",
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12),
            ),
            const SizedBox(height: 16),

            // List of Clauses
            ...(_caseResult!['data'] as List).map((clause) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.article_outlined, color: _creamBackground, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        clause['Subsection'] ?? "",
                        style: TextStyle(color: _creamBackground, fontWeight: FontWeight.bold, fontFamily: 'serif', fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    clause['Details'] ?? "",
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Penalty: ${clause['Punishment']}",
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )),
          ],

          const SizedBox(height: 40),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                  _caseController.clear();
                  _responses.clear();
                  _questions.clear();
                  _caseResult = null;
                });
              },
              child: Text("START NEW SEARCH", style: TextStyle(color: Colors.white.withOpacity(0.6))),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _coffeeMedium, letterSpacing: 0.5),
      ),
    );
  }

  // ---------------- LOGIC ----------------

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: _coffeeDark,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _isLoading ? null : fetchResults,
          style: ElevatedButton.styleFrom(
            backgroundColor: _creamBackground,
            foregroundColor: _textDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
              : const Text("SEARCH SECTION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
      ),
    );
  }

  void sendData() async {
    String ccase = _caseController.text.trim();

    if (ccase.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in the Case Identifier', backgroundColor: _coffeeDark, textColor: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');
      final api = Uri.parse('$url/fetch_case/');

      final request = await http.post(api, body: {'case': ccase});

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          // Store sid for the next call
          if (data['sid'] != null) {
            sh.setString("sid", data['sid'].toString());
          }

          setState(() {
            _questions = List<Map<String, dynamic>>.from(data["data"]);
            _currentStep = 1; // Move to Chat
          });
        } else {
          Fluttertoast.showToast(msg: 'Failed: Case not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Connection error');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void fetchResults() async {
    if (_responses.length < _questions.length) {
      Fluttertoast.showToast(msg: "Please answer all questions");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');
      String? sid = sh.getString('sid');

      final api = Uri.parse('$url/fetch_case_details/');

      // The Python backend parses the string representation of the map,
      // expecting format like "{1: Yes, 2: No}". Dart's default .toString()
      // produces exactly this format, so we send it as is.
      final request = await http.post(api, body: {
        'sid': sid.toString(),
        "qa": _responses.toString()
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Analysis Complete');
          setState(() {
            _caseResult = data;
            _currentStep = 2; // Move to Results
          });
        } else {
          Fluttertoast.showToast(msg: 'Failed: Analysis failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Connection error');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}